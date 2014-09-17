$BET = 1
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


function checkPredictions($pDogs, $aDogs, $accList)
{
    $correct = @()
    $Picks = @()

    $Placing = New-Object System.Object
    $Placing | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $Placing | Add-Member -MemberType NoteProperty -Name "Pick" -Value "Placing" -Force
    $Placing | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $Placing | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force

    $pPos = $aDogs.DOGID.indexof($pDogs.DOGID)
    $Placing.correct = ($pPos -le 3) -and ($pPos -gt -1)
    
    $accList.add($Placing)
}

function ProcessBets($betType, $picks, $bObject)
{
   for($i=1; $i -le 1; $i++)
    {
        $betamount = $i * $BET
        $bName = "`$" + ($betamount)
        $bObject | Add-Member -MemberType NoteProperty -Name $bName -Value "" -Force

        $allBets = $picks.where( { $_.Pick -eq $betType } )
        $correctBets = $picks.where( { $_.correct -AND $_.Pick -eq $betType} )
        $bObject.$bName = -($betamount * $allBets.Count)
        
        $correctBets.foreach( { 
            $cBet = $_
            $bObject.$bName += ([float]$cBet.Payout * $betamount) } )
        $bObject.PercentCorrect = ($correctBets.Count / $allBets.Count) * 100
        $bObject.NumBets = $allBets.Count  

    }
}

function calculatePayout($picks)
{

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "Placing" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "Placing" $picks $payout

    Return $Payout
 
}




$networkQuery = "SELECT CONFIGVALUE FROM CONFIG WHERE CONFIGITEM = 'PREDICTIONMODEL'"
$networkDetails = (ReadSQL($networkQuery)).CONFIGVALUE

$trackIDsQuery = "SELECT DISTINCT b.TRACKID FROM PREDICTEDRESULTS a INNER JOIN RACES b on a.RACEID = b.RACEID WHERE a.nnid = '$networkDetails'"
$trackIDs = (ReadSQL($trackIDsQuery)).TRACKID

$trackData = New-Object System.Collections.Generic.List[object]

$allRaces = @()

foreach($track in $trackIDs)
{

    $RaceQuery = "SELECT RACEID, WINPAYING, PLACEPAYING, QUINELLAPAYING, TRIFECTAPAYING, FIRST4PAYING FROM RACES WHERE RACEID in ( SELECT DISTINCT RACEID FROM TRAININGDATA WHERE DATATYPE = 'TESTING') AND TRACKID = $track ORDER BY newID()"
    $RaceDetails = ReadSQL($RaceQuery)

    $allRaces += $RaceDetails.RACEID

    $count = 0

    $total = $RaceDetails.Count

    $netID = $networkDetails
    $betData = New-Object System.Collections.Generic.List[object]
    Write-Host "Processing Track $track..."

    $numbets = 0
    foreach($race in $RaceDetails)
    {
        $raceID = $race.RACEID
        $numbets++

        $predictQuery = "SELECT TOP 1 [DOGID], [PREDICTEDRESULTS] FROM PREDICTEDRESULTS WHERE RACEID = $RaceID AND NNID = '$netID' ORDER BY PREDICTEDRESULTS"        
        $predictResults = ReadSQL($predictQuery)

        if($predictResults -eq $NULL) 
        { 
            Write-Host "Skipped"
            $count++
            continue 
        }
        
        $actualResultsQuery = "SELECT TOP 3 [DOGID] FROM RESULTS WHERE RACEID = $raceID ORDER BY RESULT"
        $actualResults = ReadSQL($actualResultsQuery)

        CheckPredictions $predictResults $actualResults $betData
    
        $entries = $betData.Count
        $betData[$entries-1].Payout = $race.PLACEPAYING
        $betData[$entries-1].RaceID = $race.RaceID

   
        if($count % 10 -eq 0)
        {
            $percent = $percent = [math]::round((($count/($total)) * 100), 0)
            Write-Progress -Activity:"Processing Track... ($percent%)" -PercentComplete:$percent
        }
        $count++

    }
    $netPayout = calculatePayout $betData

    $trackAccuracy = New-Object System.Object
    $trackAccuracy | Add-Member -MemberType NoteProperty -Name "TrackID" -Value "" -Force
    $trackAccuracy | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $trackAccuracy | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force
    $trackAccuracy | Add-Member -MemberType NoteProperty -Name "NumberBets" -Value "" -Force

    $trackAccuracy.TrackID = $track
    $trackAccuracy.PercentCorrect = $netPayout.PercentCorrect
    $trackAccuracy.Payout = $netPayout.'$1'
    $trackAccuracy.NumberBets = $numbets

    $trackData.Add($trackAccuracy)


}


    $overall = New-Object System.Object
    $overall | Add-Member -MemberType NoteProperty -Name "TrackID" -Value "Overall" -Force
    $overall | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $overall | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force
    $overall | Add-Member -MemberType NoteProperty -Name "NumberBets" -Value "" -Force

    $pCorrect = 0
    $payout = 0
    $nBets = 0

    foreach($track in $trackData)
    {
        $pCorrect += $track.PercentCorrect
        $payout += $track.Payout
        $nBets += $track.NumberBets
    }

    $pCorrect = $pCorrect / $trackData.count

    $overall.PercentCorrect = $pCorrect
    $overall.Payout = $payout
    $overall.NumberBets = $nBets

    $trackData.Add($overall)
