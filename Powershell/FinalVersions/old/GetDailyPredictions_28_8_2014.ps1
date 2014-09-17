Import-Module sqlps -DisableNameChecking

############################################################
# This script will perform the following functions:
#
# 1. Get all greyhound races for day 
# 2. Create a race record in the RACES table in DB
# 3. Enter details into FUTURERACES table. This will be used later to predict outcomes.
# 4. Start R script to get data from FUTURERACES table and create predictions.
#    These predictions will be placed into the DAILYPREDICTIONS table
# 5. The script will then output these predictions
#
############################################################

$pageSave = "..\pageData.txt"
$SQLLOCATION = "SQLSERVER:\SQL\localhost\SQLEXPRESS\databases\Racing"

function GetMeetCode($text)
{
    $pos1 = $text.indexof("""")
    $pos2 = $text.indexof("""", $pos1+1)
    $result = $text.substring($pos1+1, $pos2-$pos1-1)
    
    Return $result

}

function GetTrackName($meet)
{
    $name = $meet.allElements.InnerHTML
    $name = $name -split "`r`n"
    $name = ($name -like "<H2>*")[0]
    $name = $name.toupper()

    $name = $name -split " "

    $startPos = 2
    $ghPos = $name.indexof("GREYHOUNDS")

    for($i=$startPos;$i -le $ghPos; $i++) { $return = $return + " " + $name[$i] }

    $return = $return.trim()
    return($return)

    
}

function ProcessMeet($meet)
{
    $meetTrack = GetTrackName($meet)
    if($meetTrack -eq $NULL) { return $NULL }
    $tIDQuery = "SELECT TRACKID FROM TRACKS WHERE TRACKNAME = '$meetTrack'"
    $trackID = Invoke-Sqlcmd $tIDQuery -SuppressProviderContextWarning
    if($trackID -eq $NULL) { $trackID = 4 }

    $ErrorActionPreference = "SilentlyContinue"
    $tDetails = $meet.allElements | where { $_.class -eq "right" }
    $tDetails = $tDetails[0].innerText
    $tDetails = $tDetails -split "`r`n"
    
    $weather = $tDetails[1].substring(9)
    $weather = $weather.toupper()
    $trackC = $tDetails[2].substring(7)
    $trackC = $trackC.toUpper()
    $ErrorActionPreference = "Continue"

    if($weather -eq $NULL) { $weather = "FINE" }
    if($trackC -eq $NULL) { $trackC = "GOOD" }
    
    $links = $meet.links

    $i = 0
    $races = New-Object System.Collections.Generic.List[object]
    
    while($links[$i].innerHTML -notmatch "^[1-9]") { $i++ }

    $raceCount = 0
    while($links[$i].innerHTML -match "^[1-9]")
    {
        $races.Add(($links[$i].href).trim("#"))
        $i++
        $raceCount++
    }

    $raceDetails = New-Object System.Collections.Generic.List[object]
    $raceNum = 1
    foreach($race in $races)
    {
        $raceDets = ProcessRace $race $raceCount
        $raceDets.Weather = $weather
        $raceDets.TrackC = $trackC
        $raceDets.RaceNumber = $raceNum
        $raceDets.TrackID = $trackID.TRACKID
        $raceDets.Date = Get-Date
        $raceDetails += $raceDets
        $raceNum++
        
        $percent = (($raceNum-1) / $races.Count) * 100
        Write-Progress -id 2 -parentid 1 -Activity:"Processing races.. ($percent%)" -PercentComplete:$percent    
        
    }

    return $raceDetails

}

function ProcessRace($raceURL, $numRaces)
{
    $URLpage = "https://www.tab.co.nz/racing/ajax/page/$raceURL"
    $racePage = Invoke-WebRequest $URLpage
    
    $raceDetails = New-Object System.Object
    $raceDetails | Add-Member -MemberType NoteProperty -Name "Dogs" -Value '' -Force
    $raceDetails | Add-Member -MemberType NoteProperty -Name "Distance" -Value '' -Force
    $raceDetails | Add-Member -MemberType NoteProperty -Name "Weather" -Value '' -Force
    $raceDetails | Add-Member -MemberType NoteProperty -Name "TrackC" -Value '' -Force
    $raceDetails | Add-Member -MemberType NoteProperty -Name "TrackID" -Value '' -Force
    $raceDetails | Add-Member -MemberType NoteProperty -Name "RaceNumber" -Value '' -Force
    $raceDetails | Add-Member -MemberType NoteProperty -Name "Date" -Value '' -Force

    $distance = $racePage.allElements.InnerHTML
    $distance = $distance -split "`r`n"
    $distance = ($distance -like "<H3>*")[0]

    $dLoc = [regex]::match($racePage.AllElements.innerHTML,"\d{3}m")
    $raceDetails.Distance = $dLoc.Value.Substring(0,3)

    $startPos = 0
    $Dogs = New-Object System.Collections.Generic.List[object]

    do
    { 
        $line = $racePage.Links[$startPos].innerHTML
        $startPos++
    }until($line -match "^[1-9]")


    $startPos = $startPos + $numRaces
    if($racePage.Links[$startPos].innerText -eq "Help on bet types?") { $startPos++ }
    if($racePage.Links[$startPos].innerText -eq $NULL) { $startPos++ }
    $linkCount = $racePage.Links.count

    $trainerNames = $racePage.AllElements | where { $_.class -eq "cj" }
    $trainerNames = $trainerNames.innerText

    $dogCount = 1
    for($i=$startPos;$i -le ($linkCount -5);$i++) 
    { 
        $dogName = $racePage.links[$i].innerText.ToUpper()
        $tName = ""
        if($trainerNames[$dogCount] -ne $NULL) { $tName = $trainerNames[$dogCount].toupper().trim() }


        if($tName -ne "SCRATCHED") { $Dogs.add($dogName) }
        else { $Dogs.Add("SCRATCHED") } 
        
        #else { $dogCount++ } # This is a second addition needed for VACANT BOX NULL trainers
        $dogCount++
    }
    
    $raceDetails.Dogs = $Dogs
    return $raceDetails

}

function CleanDog($dogname)
{
    $dogname = $dogname -replace ",",""
    $dogname = $dogname -replace "\'",""
    $dogname = $dogname -replace ";",""
    $dogname = $dogname.toupper()
    $dogname = $dogname.trim()
    Return $dogname
}


function CreateFutureRaces()
{

    # Get TAB races for the day. 
    # We save the URL to a file because for some reason when
    # it is in an object, any operations on the object hang
    # powershell.


    $URL = "https://www.tab.co.nz/racing/"
    Invoke-WebRequest -Uri $URL -OutFile $pageSave
    $pageData = Get-Content $pageSave

    $todayPos = $pageData.IndexOf("<dt>Today</dt>")

    $pos = $todayPos + 2
    $meetCodes = @()

    Do
    {
        $line = $pageData[$pos]
        if($line -like "*GREYHOUND*") { $meetCodes += GetMeetCode($line) }
        $pos++


    } until($line -eq "</dl></dd>")


    Push-Location
    Set-Location $SQLLOCATION
    $clearQuery = "TRUNCATE TABLE FUTURERESULTS"
    Invoke-Sqlcmd $clearQuery -SuppressProviderContextWarning
    $clearQuery  = "UPDATE RACES SET FUTURERACE = NULL"
    Invoke-Sqlcmd $clearQuery -SuppressProviderContextWarning
    $meetCount = 0

    foreach($meet in $meetCodes)
    {
        $meetCount++
        $percent = ($meetCount / $meetCodes.count) * 100
        Write-Progress -id 1 -Activity:"Processing meets.. ($percent%)" -PercentComplete:$percent

        $meetURL = "https://www.tab.co.nz/racing/ajax/page/$meet"
        $meetInfo = Invoke-WebRequest $meetURL
    
        $meetDetails = ProcessMeet($meetInfo)
        if($meetDetails -eq $NULL) { continue }

        foreach($race in $meetDetails)
        {
            $dist = $race.distance
            $weath = $race.weather
            $trackc = $race.trackc
            $trackID = $race.trackID
            $raceNum =  $race.raceNumber
            $date = get-date -Format yyyy-MM-dd

            $raceQuery = "EXEC AddFutureRaceDetails $trackID, '$date', $dist, '$trackc', '$weath', $raceNum"
            Invoke-Sqlcmd $raceQuery -SuppressProviderContextWarning

            $raceIDQuery = "SELECT RACEID FROM RACES WHERE TRACKID = $trackID AND DATE = '$date' AND RACENUMBER = $racenum" 
            $raceID = Invoke-Sqlcmd $raceIDQuery -SuppressProviderContextWarning
            $raceID = $raceId.RACEID

            $box = 0
            foreach($dog in $race.Dogs)
            {
                $box++
                $dog = CleanDog($dog)
                $dogIDQuery = "EXEC GetDogID '$dog'"
                $dogID = Invoke-Sqlcmd $dogIDQuery -SuppressProviderContextWarning
                $dogID = $dogID.DOGID
                $raceEntryQuery = "EXEC AddFutureRaceResult $trackID, $raceID, $dogID, $box"
                Invoke-Sqlcmd $raceEntryQuery -SuppressProviderContextWarning

            
            }
            
        }
    

    }

}

function CreatePredictionData()
{
    $prepareQuery = "EXEC CreateTempRaceData"
    Invoke-Sqlcmd $prepareQuery -SuppressProviderContextWarning

    $fRaceQuery = "SELECT RACEID, DOGID FROM FUTURERESULTS"
    $fRaces = Invoke-Sqlcmd $fRaceQuery -SuppressProviderContextWarning

    $count = 0
    foreach($entry in $fRaces)
    {

        $dogID = $entry.DOGID
        $raceID = $entry.RACEID
        $entryQuery = "EXEC GenerateFutureLine $DogID, $RaceID"
        Invoke-Sqlcmd $entryQuery -SuppressProviderContextWarning


        $percent = $percent = [math]::round((($count/$fRaces.Count) * 100), 0)
        Write-Progress -Activity:"Processing Data... ($percent%)" -PercentComplete:$percent

    $count++
    }

}

function GeneratePredictions()
{
    $exe = "C:\Program Files\R\R-3.1.1\bin\Rscript.exe"
    $script = """C:\Projects\Racing\R\PredictFutureResults.r"""
    Start-Process $exe -ArgumentList $script
}

function ProcessQuinellaReccomendations()
{
    $NN = @()
    $NN += "Q_1_E_0.01_5000_N_13"
	$NN += "Q_3_E_0.025_5000_N_13"
	$NN += "Q_3_E_0.01_5000_N_13"
    
    Set-Location $SQLLOCATION

    $RaceQuery = "SELECT RACEID FROM RACES WHERE FUTURERACE = 1"
    $RaceDetails = Invoke-Sqlcmd $RaceQuery -SuppressProviderContextWarning

    $count = 0
    foreach($race in $RaceDetails)
    {
        $raceID = $race.RACEID
        $predictResults = New-Object System.Collections.Generic.List[object]
        $count++
        foreach($net in $NN) 
        { 
            $predictQuery = "SELECT TOP 4 [DOGID] FROM FUTUREPREDICTIONS WHERE RACEID = $RaceID AND NNID = '$net' ORDER BY PREDICTEDRESULTS"        
            $sqlResults = Invoke-Sqlcmd $predictQuery -SuppressProviderContextWarning
            $predictResults.add($sqlResults)
        }

        if($predictResults -eq $NULL) 
        { 
            Write-Host "Skipped"
            continue }

        $1Dog = $predictResults[0][0].DOGID
        $2Dog = $predictResults[0][1].DOGID
        $3Dog = $predictResults[0][2].DOGID
        $4Dog = $predictResults[0][3].DOGID

        $reccomend = $true
        for($i=1;$i-lt$NN.Count;$i++)
        {
            if($1Dog -ne $predictResults[$i][0].DOGID) { $reccomend = $false }   
            if($2Dog -ne $predictResults[$i][1].DOGID) { $reccomend = $false }
            if($3Dog -ne $predictResults[$i][2].DOGID) { $reccomend = $false }

        }

        $percent = $percent = [math]::round((($count/$raceDetails.Count) * 100), 0)
        Write-Progress -Activity:"Processing quinella reccomendations... ($percent%)" -PercentComplete:$percent

        if(!$reccomend) { continue }

        $dog1Query = "UPDATE FUTURERESULTS SET QUINREC = 1 WHERE RACEID = $raceID AND DOGID = $1Dog"
        $dog2Query = "UPDATE FUTURERESULTS SET QUINREC = 2 WHERE RACEID = $raceID AND DOGID = $2Dog"
        $dog3Query = "UPDATE FUTURERESULTS SET QUINREC = 3 WHERE RACEID = $raceID AND DOGID = $3Dog"
        $dog4Query = "UPDATE FUTURERESULTS SET QUINREC = 4 WHERE RACEID = $raceID AND DOGID = $4Dog"
        Invoke-Sqlcmd $dog1Query -SuppressProviderContextWarning
        Invoke-Sqlcmd $dog2Query -SuppressProviderContextWarning
        Invoke-Sqlcmd $dog3Query -SuppressProviderContextWarning
        Invoke-Sqlcmd $dog4Query -SuppressProviderContextWarning







    }

}

function ProcessPlacingReccomendations()
{
    $NN = @()
    $NN += "Q_1_E_0.01_5000_N_13"
	$NN += "Q_3_E_0.025_5000_N_13"
	$NN += "Q_1_E_0.025_5000_N_13"
    
    Set-Location $SQLLOCATION

    $RaceQuery = "SELECT RACEID FROM RACES WHERE FUTURERACE = 1"
    $RaceDetails = Invoke-Sqlcmd $RaceQuery -SuppressProviderContextWarning

    $count = 0
    foreach($race in $RaceDetails)
    {
        $raceID = $race.RACEID
        $predictResults = New-Object System.Collections.Generic.List[object]
        $count++
        foreach($net in $NN) 
        { 
            $predictQuery = "SELECT TOP 4 [DOGID] FROM FUTUREPREDICTIONS WHERE RACEID = $RaceID AND NNID = '$net' ORDER BY PREDICTEDRESULTS"        
            $sqlResults = Invoke-Sqlcmd $predictQuery -SuppressProviderContextWarning
            $predictResults.add($sqlResults)
        }

        if($predictResults -eq $NULL) 
        { 
            Write-Host "Skipped"
            continue }

        $1Dog = $predictResults[0][0].DOGID
        $2Dog = $predictResults[0][1].DOGID
        $3Dog = $predictResults[0][2].DOGID
        $4Dog = $predictResults[0][3].DOGID

        $reccomend = $true
        for($i=1;$i-lt$NN.Count;$i++)
        {
            if($1Dog -ne $predictResults[$i][0].DOGID) { $reccomend = $false }   
            #if($2Dog -ne $predictResults[$i][1].DOGID) { $reccomend = $false }
        }

        $percent = $percent = [math]::round((($count/$raceDetails.Count) * 100), 0)
        Write-Progress -Activity:"Processing placing reccomendations... ($percent%)" -PercentComplete:$percent

        if(!$reccomend) { continue }

        $dog1Query = "UPDATE FUTURERESULTS SET PLACEREC = 1 WHERE RACEID = $raceID AND DOGID = $1Dog"
        $dog2Query = "UPDATE FUTURERESULTS SET PLACEREC = 2 WHERE RACEID = $raceID AND DOGID = $2Dog"
        $dog3Query = "UPDATE FUTURERESULTS SET PLACEREC = 3 WHERE RACEID = $raceID AND DOGID = $3Dog"
        $dog4Query = "UPDATE FUTURERESULTS SET PLACEREC = 4 WHERE RACEID = $raceID AND DOGID = $4Dog"
        Invoke-Sqlcmd $dog1Query -SuppressProviderContextWarning
        Invoke-Sqlcmd $dog2Query -SuppressProviderContextWarning
        Invoke-Sqlcmd $dog3Query -SuppressProviderContextWarning
        Invoke-Sqlcmd $dog4Query -SuppressProviderContextWarning






    }

}

function ProcessAllRaces()
{
    $NN = "Q_4_E_0.01_5000_N_13"
    
    Set-Location $SQLLOCATION

    $RaceQuery = "SELECT RACEID FROM RACES WHERE FUTURERACE = 1"
    $RaceDetails = Invoke-Sqlcmd $RaceQuery -SuppressProviderContextWarning

    $count = 0
    foreach($race in $RaceDetails)
    {
        $raceID = $race.RACEID
        $predictResults = New-Object System.Collections.Generic.List[object]
        $count++

        $predictQuery = "SELECT TOP 4 [DOGID] FROM FUTUREPREDICTIONS WHERE RACEID = $RaceID AND NNID = '$NN' ORDER BY PREDICTEDRESULTS"        
        $sqlResults = Invoke-Sqlcmd $predictQuery -SuppressProviderContextWarning
        $predictResults = $sqlResults


        if($predictResults -eq $NULL) 
        { 
            Write-Host "Skipped"
            continue }

        $1Dog = $predictResults[0].DOGID
        $2Dog = $predictResults[1].DOGID
        $3Dog = $predictResults[2].DOGID
        $4Dog = $predictResults[3].DOGID

        $percent = $percent = [math]::round((($count/$raceDetails.Count) * 100), 0)
        Write-Progress -Activity:"Processing all races.. ($percent%)" -PercentComplete:$percent

        $dog1Query = "UPDATE FUTURERESULTS SET PLACE = 1 WHERE RACEID = $raceID AND DOGID = $1Dog"
        $dog2Query = "UPDATE FUTURERESULTS SET PLACE = 2 WHERE RACEID = $raceID AND DOGID = $2Dog"
        $dog3Query = "UPDATE FUTURERESULTS SET PLACE = 3 WHERE RACEID = $raceID AND DOGID = $3Dog"
        $dog4Query = "UPDATE FUTURERESULTS SET PLACE = 4 WHERE RACEID = $raceID AND DOGID = $4Dog"
        Invoke-Sqlcmd $dog1Query -SuppressProviderContextWarning
        Invoke-Sqlcmd $dog2Query -SuppressProviderContextWarning
        Invoke-Sqlcmd $dog3Query -SuppressProviderContextWarning
        Invoke-Sqlcmd $dog4Query -SuppressProviderContextWarning
    }

}

function ExportPredictions()
{
    $date = Get-Date
    $timestamp = [String]$date.Day + "_" + $date.Month + "_" + $date.Year + "_" + $date.hour + "_" + $date.minute
 
    $AllRacesQuery = "EXEC GetAllPredictions"
    $allRaces = Invoke-Sqlcmd $AllRacesQuery -SuppressProviderContextWarning
    $allRaces | Export-Csv "C:\Projects\Racing\Reports\AllRaces_$timestamp.csv"
    $numRaces = $allRaces.count / 4
    Write-Host "Total Races: $numRaces"

    $QuinQuery = "EXEC GetQuinellaPredictions"
    $quinRaces = Invoke-Sqlcmd $QuinQuery -SuppressProviderContextWarning
    $quinRaces | Export-Csv "C:\Projects\Racing\Reports\QuinRaces_$timestamp.csv"
    $numRaces = $quinRaces.count / 4
    Write-Host "Quinella Reccomended Races: $numRaces"

    $PlaceQuery = "EXEC GetPlacePredictions"
    $placeraces = Invoke-Sqlcmd $PlaceQuery -SuppressProviderContextWarning
    $placeraces | Export-Csv "C:\Projects\Racing\Reports\PlaceRaces_$timestamp.csv"
    $numRaces = $placeraces.count / 4
    Write-Host "Place Reccomended Races: $numRaces"
}

Set-Location C:\

Write-Host "Populating new races..."
CreateFutureRaces

Write-Host "Generating prediction data..."
CreatePredictionData

Write-Host "Generating predictions..."
GeneratePredictions

Sleep -Seconds 20

Write-Host "Processing Quinellas..."
ProcessQuinellaReccomendations

Write-Host "Processing Placings..."
ProcessPlacingReccomendations

Write-Host "Processing All Races..."
ProcessAllRaces

ExportPredictions


Pop-Location