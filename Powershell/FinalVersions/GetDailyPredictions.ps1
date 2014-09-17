﻿        $con = New-Object System.Data.SqlClient.SqlConnection
        $con.ConnectionString = "Server=localhost\sqlexpress;database=Racing;Integrated Security=true"
        $con.Open()

$SCHEDULEURL = "http://xml.tab.co.nz/schedule"
$RESULTSURL = "http://xml.tab.co.nz/results"

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

function UpdateRaceDataXML
{
    $futureRacesQuery = "SELECT a.RACEID, b.NUMBER AS MEETNUMBER, a.RACENUMBER FROM RACES a INNER JOIN MEETS b ON a.MEETID = b.MEETID WHERE a.STARTTIME > getdate()"
    $futureRaces = ReadSQL($futureRacesQuery)
    $date = Get-Date -Format yyyy-MM-dd
    
    $count = 0
    foreach($race in $futureRaces)
    {
        $meetNum = $race.MEETNUMBER
        $raceNum = $race.RACENUMBER
        
        $url = "$SCHEDULEURL\$date\$meetNum\$raceNum"

        $ProgressPreference = "SilentlyContinue"
        $rPage = Invoke-WebRequest $url
        $ProgressPreference = "Continue"

        $rPageXML = [xml]$rPage
        
        $details = $rPageXML.schedule.meetings.meeting.races.race
        $trackC = $details.track
        $weather = $details.weather

        if($trackC -eq $NULL) { $trackC = "GOOD" }
        if($weather -eq $NULL) { $weather = "FINE" }
        $raceID = $race.RACEID

        $updateRaceDetailsQuery = "EXEC UpdateRaceDetails @RACEID=$raceID, @WEATHER=$weather, @TRACKCONDITION=$trackC"
        RunSQL($updateRaceDetailsQuery)

        $dogs = $details.entries.entry
        foreach($dog in $dogs)
        {
            $dogID = GetDogID -DogName $dog.name
            if($dog.scratched -eq 1)
            {
                $deleteQuery = "DELETE FROM FUTURERESULTS WHERE RACEID=$raceID AND DOGID=$dogID"
                RunSQL($deleteQuery)
            }else
            {
                $box = $dog.number
                $updateQuery = "EXEC UpdateDogDetails @RACEID=$raceID, @DOGID=$dogID, @BOX=$box"
                RunSQL($updateQuery)
            }

        }

        $count++
        $percent = $percent = [math]::round((($count/$futureRaces.Count) * 100), 0)
        Write-Progress -Activity:"Processing Races... ($percent%)" -PercentComplete:$percent



    }
}

function UpdateCompletedRacesXML
{
    $raceQuery = "SELECT a.RACEID, a.MEETID, b.NUMBER AS MEETNUMBER, a.RACENUMBER FROM RACES a INNER JOIN MEETS b ON a.MEETID = b.MEETID WHERE a.STARTTIME < getdate() AND a.STATUS is NULL"
    $races = ReadSQL($raceQuery)

    $count = 0
    foreach($race in $races)
    {
        $count++
        $meetID = $race.MEETID
        $raceID = $race.RACEID
        $date = get-date -Format yyyy-MM-dd
        $meetNum = $race.MEETNUMBER
        $raceNum = $race.RACENUMBER
        $url = "$RESULTSURL/$date/$meetNum/$raceNum"

        $ProgressPreference = "SilentlyContinue"
        $results = Invoke-WebRequest $url
        $ProgressPreference = "Continue"
        $resultsXML = [xml]$results

        $placings = $resultsXML.meetings.meeting.races.race.placings.placing
        if($placings -eq $NULL) { continue }

        $otherdogs = $resultsXML.meetings.meeting.races.race.also_ran.runners.runner
        $scratchings = $resultsXML.meetings.meeting.races.race.scratchings.scratching.name
        $pools = $resultsXML.meetings.meeting.races.race.pools.pool

        if($pools -eq $NULL) { continue } 

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
        $raceQuery = "EXEC UpdateRacePayouts @RACEID = $raceID, @WINPAYING = '$winpay', @PLACEPAYING = '$placepay', @2PLACE = '$twopay', @3PLACE = '$threepay', @QUINELLAPAYING = '$quinpay', @TRIFECTAPAYING = '$tripay', @FIRST4PAYING = '$ffpay'"#, @STATUS = 1"
        RunSQL $raceQuery

        foreach($dog in $placings)
        {
            $dName = $dog.name
            $rank = $dog.rank
            $box =$dog.number
            $dogID = GetDogID -DogName $dName
            $dogQuery = "EXEC UpdateRaceResult @RACEID = $raceID, @DOGID = $dogID, @ACTUALRESULT = $rank"
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
            $dogQuery = "EXEC UpdateRaceResult @RACEID = $raceID, @DOGID = $dogID, @ACTUALRESULT = $rank"
            RunSQL $dogQuery
        }
        
        
        $percent = $percent = [math]::round((($count/$races.Count) * 100), 0)
        Write-Progress -Activity:"Processing Races... ($percent%)" -PercentComplete:$percent         

    }

}

function CreatePredictionData()
{
    $prepareQuery = "EXEC CreateTempRaceData"
    RunSQL($prepareQuery)

    $fRaceQuery = "SELECT RACEID, DOGID FROM FUTURERESULTS"
    $fRaces = ReadSQL($fRaceQuery)

    $count = 0
    foreach($entry in $fRaces)
    {

        $dogID = $entry.DOGID
        $raceID = $entry.RACEID
        $entryQuery = "EXEC GenerateFutureLine $DogID, $RaceID"
        RunSQL($entryQuery)


        $percent = $percent = [math]::round((($count/$fRaces.Count) * 100), 0)
        Write-Progress -Activity:"Processing Data... ($percent%)" -PercentComplete:$percent

    $count++
    }

}

function GeneratePredictions()
{
    $exe = "C:\Program Files\R\R-3.1.1\bin\Rscript.exe"
    $script = """C:\Projects\Racing\R\FinalVersions\PredictFutureResults.r"""
    Start-Process $exe -ArgumentList $script
}

function ProcessAllRaces()
{
    $modelQuery = "SELECT CONFIGVALUE FROM CONFIG WHERE CONFIGITEM = 'PREDICTIONMODEL'"
    $NN = (ReadSQL($modelQuery)).CONFIGVALUE

    $RaceQuery = "SELECT a.RACEID FROM RACES a INNER JOIN MEETS b ON a.MEETID = b.MEETID WHERE b.DATE = convert(date, getdate())"
    $RaceDetails = ReadSQL($RaceQuery)

    $count = 0
    foreach($race in $RaceDetails)
    {
        $raceID = $race.RACEID
        $predictResults = New-Object System.Collections.Generic.List[object]
        $count++

        $predictQuery = "SELECT TOP 4 [DOGID] FROM FUTUREPREDICTIONS WHERE RACEID = $RaceID AND NNID = '$NN' ORDER BY PREDICTEDRESULTS"        
        $sqlResults = ReadSQL($predictQuery)
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

        $clearQuery = "UPDATE FUTURERESULTS SET PREDICTION = NULL WHERE RACEID = $raceID"
        $dog1Query = "UPDATE FUTURERESULTS SET PREDICTION = 1 WHERE RACEID = $raceID AND DOGID = $1Dog"
        $dog2Query = "UPDATE FUTURERESULTS SET PREDICTION = 2 WHERE RACEID = $raceID AND DOGID = $2Dog"
        $dog3Query = "UPDATE FUTURERESULTS SET PREDICTION = 3 WHERE RACEID = $raceID AND DOGID = $3Dog"
        $dog4Query = "UPDATE FUTURERESULTS SET PREDICTION = 4 WHERE RACEID = $raceID AND DOGID = $4Dog"
        RunSQL($clearQuery)
        RunSQL($dog1Query)
        RunSQL($dog2Query)
        RunSQL($dog3Query)
        RunSQL($dog4Query)
    }

}

function ExportPredictions()
{
    $date = Get-Date
    $timestamp = [String]$date.Day + "_" + $date.Month + "_" + $date.Year + "_" + $date.hour + "_" + $date.minute
 
    $AllRacesQuery = "EXEC GetAllPredictions"
    $allRaces = ReadSQL($AllRacesQuery)
    $allRaces | Export-Csv "C:\Projects\Racing\Reports\AllRaces_$timestamp.csv"
    $numRaces = $allRaces.count / 4
    Write-Host "Total Races: $numRaces"

}


Write-Host "Updating race details..."
UpdateRaceDataXML

Write-Host "Processing completed races..."
UpdateCompletedRacesXML

Write-Host "Generating prediction data..."
CreatePredictionData

Write-Host "Generating predictions..."
GeneratePredictions

Sleep -Seconds 5

Write-Host "Processing All Races..."
ProcessAllRaces

ExportPredictions
