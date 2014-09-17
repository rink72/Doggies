Import-Module sqlps -DisableNameChecking
$SQLLOCATION = "SQLSERVER:\SQL\localhost\SQLEXPRESS\databases\Racing"

function RemoveTags($tagString)
{
    $pos1 = $tagString.indexof(">")
    $pos2 = $tagString.indexof("<", $pos1)
    $result = $tagString.substring($pos1+1, $pos2-$pos1-1)
    
    Return $result
}

function ProcessOtherDogs($dogString)
{
    $dogString = $dogString.substring(51)
    $dogString = $dogString.trimend("</DIV>")
    $dogString = $dogString -split ","

    $position = 4

    $OtherDogs = @()

    foreach($line in $dogString)
    {
        $line = $line.trimStart("<BR>")
        $line = $line -split "-"
        $box = $line[0]
        $dog = $line[1]
        $OtherDogs += CreateDogEntry $dog $box $position
        $position++
    }
    
    Return $OtherDogs
}

function ProcessScratchDogs($dogString)
{
    $dogString = $dogString.substring(51)
    $dogString = $dogString.trimend("<BR></DIV>")
    $dogString = $dogString -replace "\.", ""
    $dogString = $dogString -split ","
    

    $position = 'S'

    $ScratchDogs = @()

    foreach($line in $dogString)
    {
        $line = $line -split "-"
        $box = $line[0]
        $dog = $line[1]
        $ScratchDogs += CreateDogEntry $dog $box $position
    }
    
    Return $ScratchDogs
}

function GetTrackID($TrackName)
{
    $TrackQuery = "EXEC GetTrackID @TRACKNAME = '$TRACKNAME'"
    $TrackID = Invoke-Sqlcmd $TrackQuery -SuppressProviderContextWarning
    Return $TrackID.TrackID
}

function GetDogID($DogName)
{
    $dogname = $dogname -replace ",",""
    $dogname = $dogname -replace "\'",""
    $dogname = $dogname -replace ";",""
    $dogname = $dogname -replace "'",""
    $DogQuery = "EXEC GetDogID @DOGNAME = '$DOGNAME'"
    $DogID = Invoke-Sqlcmd $DogQuery -SuppressProviderContextWarning
    Return $DogID.DogID
}

function CreateDogEntry($dogname, $box, $position)
{
    $dogname = $dogname -replace ",",""
    $dogname = $dogname -replace "\'",""
    $dogname = $dogname -replace ";",""
    $dogname = $dogname.toupper()
    $dogname = $dogname.trim()
    $Dog = New-Object System.Object
    $Dog | Add-Member -MemberType NoteProperty -Name "dogname" -Value $dogname -Force
    $Dog | Add-Member -MemberType NoteProperty -Name "Box" -Value $box -Force
    $Dog | Add-Member -MemberType NoteProperty -Name "FinalPosition" -Value $position -Force
    
    Return $Dog
}

function ProcessMeet($URL)
{
    $page = Invoke-WebRequest $URL.URL
    $RaceDate = $URL.RACEDATE
    
    $trackName = ($page.AllElements | where { $_.class -eq "header green" }).innerText
    if($trackName -like "*ABAN*") { return }

    if($trackName -like "*(*")
    {
        $bPos = $trackName.indexof("(")
        $trackName = $trackName.Substring($bPos-1)
    }
    
    $dPos = $trackName.indexof("-")
    $trackName = $trackName.substring($dPos+2).trim().toupper()

    $TrackID = GetTrackID($TrackName)

    $races = $page.links.href | where {$_ -like "*result" }

    $SQLQueries = @()
    $raceNum = 1
    

    foreach($race in $races)
    {
        $racePage = Invoke-WebRequest $race
        if($racePage.allelements[0].innerText -like "*ABANDONED RACE*") { continue }
        $boxes = @()
        $dogs = @()
        $distance = ([regex]::match($racePage.content,"\d{3}m")).Value.trim("m")
        $condDetails = ($racePage.allelements | where {$_.class -eq "subheader" })[1].innerText
        $condDetails = $condDetails -split " | "
        $condCount = $condDetails.count
        $weather = $condDetails[$condCount-3].trim()
        $trackC = $condDetails[$condCount-2].trim()
        
        $dogs = ($racePage.allelements | where {$_.class -eq "runner-name" }).innerText
        if($dogs.count -lt 3) { continue }
        
        $dogs = $dogs.toupper().trim()
        $odds = ($racePage.allelements | where {$_.class -eq "tr" }).innerText

        $winOdd = [float]$odds[0].trim("$").trim()
        $1placeOdd = $odds[1].trim("$").trim()
        if($1placeOdd -eq "No Dividend") { $1placeOdd = 0 }
        $2placeOdd = $odds[3].trim("$").trim()
        if($2placeOdd -eq "No Dividend") { $2placeOdd = 0 }
        $3placeOdd = $odds[5].trim("$").trim()
        if($3placeOdd -eq "No Dividend") { $3placeOdd = 0 }
        $1placeOdd = [float]$1placeOdd
        $2placeOdd = [float]$2placeOdd
        $3placeOdd = [float]$3placeOdd
        if($odds[6] -eq $NULL) { $qOdd = 0 }
        else { $qOdd = [float]$odds[6].trim("$").trim() }
        if($odds[7] -eq $NULL) { $tOdd = 0 }
        else { $tOdd = [float]$odds[7].trim("$").trim() }
        if($odds[8] -eq $NULL) { $f4Odd = 0 }
        else { $f4Odd = [float]$odds[8].trim("$").trim() }

        $tdData = ($racePage.allelements | where {$_.tagname -eq "TD" }).innerText
        
        $boxPos = 0
        foreach($dog in $dogs)
        {
            $boxes += $tdData[$boxPos]
            $boxPos += 5
        }

        #$boxes += $tdData[0]
        #$boxes += $tdData[5]
        #$boxes += $tdData[10]
        #if($dogs.count -eq 4) {$boxes += $tdData[15] }



        $OtherDogs = ($racePage.allelements | where { $_.class -eq "element" })[1].innerText
        $OtherDogs = $OtherDogs -split "`r`n"
        foreach($dog in $OtherDogs)
        {
            if($dog -like "Also ran:") { continue }
            $dogInfo = $dog -split " - "
            $boxes += $dogInfo[0]
            $Dogs += $dogInfo[1].trim().toupper()
        }
        
        $RaceQuery = "EXEC AddRaceDetails @TRACKID = $trackID,@DATE = '$RaceDate',@DISTANCE = $distance,@WINPAYING = $winOdd,@PLACEPAYING = $1placeOdd,@QUINELLAPAYING = $qOdd,@TRIFECTAPAYING = $tOdd,@FIRST4PAYING = $f4Odd,@2PLACE=$2placeOdd,@3PLACE=$3placeOdd,@TRACKCONDITION = '$trackc',@WEATHER = '$weather',@RACENUMBER = $RaceNum"
        Invoke-Sqlcmd $RaceQuery -SuppressProviderContextWarning
        
        $RaceIDQuery =  "SELECT [RACEID] FROM [RACES] WHERE [TRACKID] = $TRACKID AND [DATE] = '$RaceDate' AND [RACENUMBER] = $RaceNum"
        $RaceID = Invoke-Sqlcmd $RaceIDQuery -SuppressProviderContextWarning
        $RaceID = $RaceID.RACEID
        
        $dCount = 0
        foreach($dog in $Dogs)
        {
        
            $DogID = GetDogID($dog)
            $box = $Boxes[$dCount]
            $position = $dCount+1
            $SQLQueries += "EXEC AddRaceResult @RACEID=$RaceID,@TRACKID=$TrackID,@DOGID=$DogID,@BOX=$box,@RESULT='$position'"
            $dCount++
        }
        
        $raceNum++
       

    }
    
    if($Error.Count -eq 0) { foreach($query in $SQLQueries) { 
    Invoke-Sqlcmd $query -SuppressProviderContextWarning } }
    

}

function DownloadOldMeets
{
    $TIMEPERIOD = 2
    $STARTDATE = (Get-Date).AddDays(-1)
    $FINISHDATE = $STARTDATE.AddDays(-$TIMEPERIOD)
    $TABURL = "https://i.tab.co.nz/racing/r/"

    $meetCount = 0
    for($currentdate = $STARTDATE; $currentdate -ge $FINISHDATE; $currentdate = $currentdate.AddDays(-1))
    {
        $date = Get-date $currentdate -Format yyyy-MM-dd
        $url = $TABURL + $date

        $dayPage = Invoke-WebRequest -Uri $url
        $meets = $dayPage.Links | where {$_.innerHTML -like '*GREYHOUNDS*'}
        $meetCount += $meets.count

        foreach($meet in $meets)
        {
            $meetURL = $meet.href
            $addMeetQuery = "exec AddRacingDownload @URL = '$meetURL', @RACEDATE = '$currentdate'"
            Invoke-Sqlcmd $addMeetQuery -SuppressProviderContextWarning
        }

    }
    Write-Host "Found $meetCount meets."

}

function ProcessOldMeets
{
    $downloadQuery = "EXEC GetUnprocessedRaces"
    #$downloadQuery = "EXEC GetErrorRaces"
    $URLs = Invoke-Sqlcmd $downloadQuery -SuppressProviderContextWarning
    $count = 0
    $TotalPages = $URLs.Count

    foreach($url in $URLs) 
    { 
        $Error.Clear()
        $urlID = $url.DOWNLOADID
        ProcessMeet($URL) 
    
        If($Error.Count -gt 0) { $downloadQuery = "EXEC UpdateDownloadDetails @DOWNLOADID = $URLID, @STATE = 3" }
        else { $downloadQuery = "EXEC UpdateDownloadDetails @DOWNLOADID = $URLID, @STATE = 1" }
    
        Invoke-Sqlcmd $downloadQuery -SuppressProviderContextWarning

        $count++
        Write-Host "Processed $count of $TotalPages..."
    
    }
}

function ArchiveRaces
{
    $raceQuery = "SELECT RACEID, DOGID FROM FUTURERESULTS"
    $raceEntries = Invoke-Sqlcmd $raceQuery -SuppressProviderContextWarning

    $count = 0
    foreach($entry in $raceEntries)
    {
        $count++
        $raceID = $entry.RACEID
        $dogID = $entry.DOGID
        $archiveQuery = "EXEC ArchiveRaceData @RACEID = $raceID, @DOGID = $dogID"
        Invoke-Sqlcmd $archiveQuery -SuppressProviderContextWarning

        $percent = ($count/$raceEntries.count)*100
        Write-Progress -Activity:"Processing Archive Data... ($percent%)" -PercentComplete:$percent

    }

}

Push-Location
Set-Location $SQLLOCATION

Write-Host "Downloading old meets..."
DownloadOldMeets

Write-Host "Processing old meets..."
ProcessOldMeets

Write-Host "Archiving Previous Predictions..."
ArchiveRaces

Pop-Location
