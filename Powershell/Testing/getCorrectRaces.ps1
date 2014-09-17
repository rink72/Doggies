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
    $Payouts = @()
    

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "First" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "First" $picks $payout
    $Payouts += $payout

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "Placing" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "Placing" $picks $payout
    $Payouts += $payout

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "Quinella" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "Quinella" $picks $payout
    $Payouts += $payout

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "Trifecta" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "Trifecta" $picks $payout
    $Payouts += $payout

    Return $Payouts

 
}




$racesQuery = "SELECT DISTINCT RACEID FROM TRAININGDATA WHERE DATATYPE='TESTING'"
$races = ReadSQL($racesQuery)
$count = 0

$total = $races.Count
if($total -eq 0) { $total = $RaceDetails.Count}

$netID = 'Q_1_E_0.1_5000_48_N_3'
$betData = New-Object System.Collections.Generic.List[object]
Write-Host "Processing $netID..."

$numbets = 0
foreach($race in $races)
{
    $raceID = $race.RACEID
    $numbets++

    $predictQuery = "SELECT TOP 1 [DOGID], [PREDICTEDRESULTS] FROM PREDICTEDRESULTS WHERE RACEID = $RaceID AND NNID = '$netID' ORDER BY PREDICTEDRESULTS"        
    $predictResults = ReadSQL($predictQuery)

    if($predictResults -eq $NULL) 
    { 
        $count++
        continue 
    }
        
    $actualResultsQuery = "SELECT TOP 3 [DOGID] FROM RESULTS WHERE RACEID = $raceID ORDER BY RESULT"
    $actualResults = ReadSQL($actualResultsQuery)

    CheckPredictions $predictResults $actualResults $betData
    
    $entries = $betData.Count
    $betData[$entries-1].Payout = $race.PLACEPAYING
    $betData[$entries-1].RaceID = $race.RaceID

   
    if($count % 100 -eq 0)
    {
        $percent = $percent = [math]::round((($count/($total)) * 100), 0)
        Write-Progress -Activity:"Processing Data... ($percent%)" -PercentComplete:$percent
    }
    $count++

}


$raceData = New-Object System.Collections.Generic.List[object]

foreach($race in $betData)
{
    $raceID = $race.RACEID
    $resultsQuery = "SELECT TOP 5 PREDICTEDRESULTS FROM PREDICTEDRESULTS WHERE RACEID = $raceID ORDER BY PREDICTEDRESULTS"
    $results = ReadSQL($resultsQuery)

    $raceEntry = New-Object System.Object
    $raceEntry | Add-Member -MemberType NoteProperty -Name "RACEID" -Value "" -Force
    $raceEntry | Add-Member -MemberType NoteProperty -Name "Position1" -Value "" -Force
    $raceEntry | Add-Member -MemberType NoteProperty -Name "Position2" -Value "" -Force
    $raceEntry | Add-Member -MemberType NoteProperty -Name "Position3" -Value "" -Force
    $raceEntry | Add-Member -MemberType NoteProperty -Name "Position4" -Value "" -Force
    $raceEntry | Add-Member -MemberType NoteProperty -Name "Position5" -Value "" -Force
    $raceEntry | Add-Member -MemberType NoteProperty -Name "Pos1_2Difference" -Value "" -Force
    $raceEntry | Add-Member -MemberType NoteProperty -Name "Pos1_5Difference" -Value "" -Force
    $raceEntry | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force

    $raceEntry.RACEID = $raceID
    $raceEntry.Position1 = $results[0].PredictedResults
    $raceEntry.Position2 = $results[1].PredictedResults
    $raceEntry.Position3 = $results[2].PredictedResults
    $raceEntry.Position4 = $results[3].PredictedResults
    $raceEntry.Position5 = $results[4].PredictedResults
    $raceEntry.Pos1_2Difference = [math]::abs($raceEntry.Position2 - $raceEntry.Position1)
    $raceEntry.Pos1_5Difference = [math]::abs($raceEntry.Position5 - $raceEntry.Position1)
    $raceEntry.Correct = $race.Correct

    $raceData.add($raceEntry)

}
