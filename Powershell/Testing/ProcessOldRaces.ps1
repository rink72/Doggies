$SCHEDULEURL = "http://xml.tab.co.nz/schedule/"
$RESULTSURL = "http://xml.tab.co.nz/results/"

[reflection.assembly]::LoadWithPartialName("'Microsoft.VisualBasic")

        $con = New-Object System.Data.SqlClient.SqlConnection
        $con.ConnectionString = "Server=localhost\sqlexpress;database=RacingRestore;Integrated Security=true"
        $con.Open()

function RunSQL($query)
{
    $cmd = New-Object System.Data.SqlClient.SqlCommand($query,$con)
    $output = $cmd.ExecuteNonQuery()
}

function ReadSQL($query)
{
    $table = New-Object System.Data.DataTable
    $cmd = $con.CreateCommand()
    $cmd.CommandText = $query
    $result = $cmd.ExecuteReader()

    $table.Load($result)

    return $table

}

function GetTrackID($TrackName, $CountryCode)
{
    $TrackQuery = "EXEC GetTrackID @TRACKNAME = '$TRACKNAME', @COUNTRYCODE = '$CountryCode'"
    $TrackID = ReadSQL($TrackQuery)
    Return $TrackID.TrackID
}

function GetDogID($DogName)
{
    $dogname = $dogname.toupper()
    $dogname = $dogname -replace ",",""
    $dogname = $dogname -replace "\'",""
    $dogname = $dogname -replace ";",""
    $dogname = $dogname -replace "'",""
    $DogQuery = "EXEC GetDogID @DOGNAME = '$DOGNAME'"
    $DogID = ReadSQL($DogQuery)
    Return $DogID.DogID
}

function DownloadOldMeetsXML
{
    $TIMEPERIOD = 4
    $STARTDATE = (Get-Date).AddDays(-1)
    $FINISHDATE = $STARTDATE.AddDays(-$TIMEPERIOD)

    $meetCount = 0
    $count = 0
    for($currentdate = $STARTDATE; $currentdate -ge $FINISHDATE; $currentdate = $currentdate.AddDays(-1))
    {
        $date = Get-date $currentdate -Format yyyy-MM-dd
        $url = $SCHEDULEURL + $date

        $ProgressPreference = "SilentlyContinue"
        $dayPage = Invoke-WebRequest -Uri $url
        $ProgressPreference = "Continue"
        $xmlPage = [xml]$dayPage.content

        $meets = $xmlPage.schedule.meetings.meeting | where { $_.type -eq "GR" -AND $_.betslip_type -like "STD" -AND $_.NAME -notlike "*QUADDIE*" -AND $_.NAME -notlike "*ABAN*"}
        $meetCount += $meets.count

        foreach($meet in $meets)
        {
            
            $bs = $meet.betslip_type
            $code = $meet.code
            if($meet.country -eq $NULL) { $country = "''" }
            else { $country = $meet.country.toupper() }
            $date = $meet.date
            $name = $meet.name.toupper()
            if($name -like "*(*")
            {
                $bPos = $name.indexof("(")
                $name = $name.Substring(0, $bPos)
            }

            $number = $meet.number
            $status = $meet.status
            $type = $meet.type
            $venue = $meet.venue.toupper()

            

            $addMeetQuery = "exec AddMeet @BETSLIP = '$bs', @CODE = '$code', @COUNTRY = '$country', @DATE = '$date', @NAME = '$name', @NUMBER = $number, @STATUS = '$status', @TYPE = '$type', @VENUE = '$venue'"
            RunSQL($addMeetQuery)

            $races = $meet.races.race

            $trackID = GetTrackID -TrackName $name -CountryCode $country
            $meetIDQuery = "SELECT MEETID FROM MEETS WHERE DATE = '$date' AND NAME = '$name'"
            $meetID = (ReadSQL $meetIDQuery).MEETID


            foreach($race in $races) { ProcessOldRaceXML -raceXML $race -meetNumber $number -date $date -trackID $trackID -meetID $meetID}

        }

        $count++
        $percent = ($count/($TIMEPERIOD+1))*100
        Write-Progress -Activity:"Processing Meet Days... ($percent%)" -PercentComplete:$percent

    }




}

function ProcessOldRaceXML($raceXML, $date, $meetNumber, $trackID, $meetID)
{
    $length = $raceXML.length
    $name = $raceXML.name
    $name = $name -replace "'", ""
    $starttime = $raceXML.norm_time
    $racenumber = $raceXML.number
    $status = $raceXML.status
    $trackC = $raceXML.track
    $weather = $raceXML.weather

    $ProgressPreference = "SilentlyContinue"
    $resultsPage = Invoke-WebRequest "$RESULTSURL$date/$meetNumber/$racenumber"
    $ProgressPreference = "Continue"
    $resultsXML = [xml]$resultsPage.content
    
    $placings = $resultsXML.meetings.meeting.races.race.placings.placing
    $otherdogs = $resultsXML.meetings.meeting.races.race.also_ran.runners.runner
    $scratchings = $resultsXML.meetings.meeting.races.race.scratchings.scratching.name
    $pools = $resultsXML.meetings.meeting.races.race.pools.pool

    if($pools -eq $NULL) { return } 

    $winpay = $pools[0].amount
    $placepay = [float]$pools[1].amount
    if($placepay -eq 0) { $placepay = 1 }
    
    
    if($pools[2].type -eq "PLC") 
    { 
        $twopay = $pools[2].amount 
        $pos = 3
    }
    else 
    { 
        $twopay = 1
        $pos = 2 
    }

    if($pools[3].type -eq "PLC")
    {
        $threepay = [float]$pools[3].amount
        if($threepay -eq 0) { $threepay = 1 }
        $quinpay = $pools[4].amount
        $tripay = $pools[5].amount
        $ffpay = $pools[6].amount
    }
    else
    {
        $threepay = 1
        $quinpay = $pools[$pos].amount
        $pos++
        $tripay = $pools[$pos].amount
        $ffpay = 1
    }
    $raceQuery = "EXEC AddRaceDetails @MEETID = $meetID, @TRACKID = $trackID, @NAME = '$name', @STARTTIME = '$starttime', @DISTANCE = $length, @TRACKCONDITION = '$trackC', @WEATHER = '$weather', @RACENUMBER = $racenumber, @WINPAYING = $winpay, @PLACEPAYING = $placepay, @2PLACE = $twopay, @3PLACE = $threepay, @QUINELLAPAYING = $quinpay, @TRIFECTAPAYING = $tripay, @FIRST4PAYING = $ffpay, @STATUS = 1"
    RunSQL $raceQuery

    $raceIDQuery = "SELECT RACEID FROM RACES WHERE MEETID = $meetID AND RACENUMBER = $racenumber"
    $raceID = (ReadSQL $raceIDQuery).RACEID

    foreach($dog in $placings)
    {
        $dName = $dog.name
        $rank = $dog.rank
        $box =$dog.number
        $dogID = GetDogID -DogName $dName
        $dogQuery = "EXEC AddRaceResult @TRACKID = $trackID, @RACEID = $raceID, @DOGID = $dogID, @BOX = $box, @RESULT = $rank"
        RunSQL $dogQuery
    }

    foreach($dog in $otherdogs)
    {
        $dName = $dog.name
        if($scratchings -contains $dName) { continue }
        $rank = [int]$dog.finish_position
        if($rank -eq 0) { $rank = 10 }
        $box =$dog.number
        $dogID = GetDogID -DogName $dName
        $dogQuery = "EXEC AddRaceResult @TRACKID = $trackID, @RACEID = $raceID, @DOGID = $dogID, @BOX = $box, @RESULT = $rank"
        RunSQL $dogQuery
    }
       
}

function DownloadNewMeetsXML
{
    $url = $SCHEDULEURL

    $ProgressPreference = "SilentlyContinue"
    $dayPage = Invoke-WebRequest -Uri $url
    $ProgressPreference = "Continue"
    $xmlPage = [xml]$dayPage.content

    $meets = $xmlPage.schedule.meetings.meeting | where { $_.type -eq "GR" -AND $_.betslip_type -like "STD" -AND $_.NAME -notlike "*QUADDIE*" -AND $_.NAME -notlike "*ABAN*"}

    foreach($meet in $meets)
    {
            
        $bs = $meet.betslip_type
        $code = $meet.code
        if($meet.country -eq $NULL) { $country = "''" }
        else { $country = $meet.country.toupper() }
        $date = $meet.date
        $name = $meet.name.toupper()
        if($name -like "*(*")
        {
            $bPos = $name.indexof("(")
            $name = $name.Substring(0, $bPos)
        }

        $number = $meet.number
        $status = $meet.status
        $type = $meet.type
        $venue = $meet.venue.toupper()

            

        $addMeetQuery = "exec AddMeet @BETSLIP = '$bs', @CODE = '$code', @COUNTRY = '$country', @DATE = '$date', @NAME = '$name', @NUMBER = $number, @STATUS = '$status', @TYPE = '$type', @VENUE = '$venue'"
        RunSQL($addMeetQuery)

        $races = $meet.races.race

        $trackID = GetTrackID -TrackName $name -CountryCode $country
        $predictTrackQuery = "SELECT PREDICT FROM TRACKS WHERE TRACKID = $trackID and PREDICT = 1"
        $doPredict = (ReadSQL($predictTrackQuery)).PREDICT
        if($doPredict -eq $NULL) { continue }

        $meetIDQuery = "SELECT MEETID FROM MEETS WHERE DATE = '$date' AND NAME = '$name'"
        $meetID = (ReadSQL $meetIDQuery).MEETID


        foreach($race in $races) 
        { 
            $length = $race.length
            $name = $race.name
            $name = $name -replace "'", ""
            $starttime = $race.norm_time
            $racenumber = $race.number
            $status = $race.status
            $trackC = $race.track
            $weather = $race.weather

            $raceQuery = "EXEC AddRaceDetails @MEETID = $meetID, @TRACKID = $trackID, @NAME = '$name', @STARTTIME = '$starttime', @DISTANCE = $length, @TRACKCONDITION = '$trackC', @WEATHER = '$weather', @RACENUMBER = $racenumber"
            RunSQL $raceQuery
        
        }

    }

}

function ArchiveRaces
{
    $raceQuery = "SELECT RACEID, DOGID FROM FUTURERESULTS"
    $raceEntries = ReadSQL($raceQuery)

    $count = 0
    foreach($entry in $raceEntries)
    {
        $count++
        $raceID = $entry.RACEID
        $dogID = $entry.DOGID
        $archiveQuery = "EXEC ArchiveRaceData @RACEID = $raceID, @DOGID = $dogID"
        RunSQL($archiveQuery)

        $percent = ($count/$raceEntries.count)*100
        Write-Progress -Activity:"Processing Archive Data... ($percent%)" -PercentComplete:$percent

    }

    $cleanQuery = "EXEC CleanFutureRaces"
    RunSQL($cleanQuery)
}

function GenerateTrackStats
{
    $tracksQuery = "SELECT DISTINCT TRACKID FROM ARCHIVERACES"
    $tracks = (ReadSQL($tracksQuery)).TRACKID

    foreach($track in $tracks)
    {
        $datesQuery = "SELECT DISTINCT DATE FROM ARCHIVERACES WHERE TRACKID = $track"
        $dates = (ReadSQL($datesQuery)).DATE

        foreach($date in $dates)
        {
            $statsQuery = "EXEC GenerateTrackStats @DATE='$date', @TRACKID=$track"
            RunSQL($statsQuery)
        }
    }

}


Write-Host "Downloading old meets..."
DownloadOldMeetsXML

Write-Host "Downloading new meets..."
DownloadNewMeetsXML

Write-Host "Archiving Previous Predictions..."
ArchiveRaces

Write-Host "Generating Track Stats..."
GenerateTrackStats


$con.Close()