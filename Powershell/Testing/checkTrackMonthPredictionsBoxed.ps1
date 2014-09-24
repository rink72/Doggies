$BET = 1
$BOXQ_3_COST = 3
$BOXQ_4_COST = 6
$BOXT_3_COST = 6
$BOXT_4_COST = 24
$con = New-Object System.Data.SqlClient.SqlConnection
$con.ConnectionString = "Server=localhost;database=RacingRestore;Integrated Security=true"
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

    $BoxQ3 = New-Object System.Object
    $BoxQ3 | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $BoxQ3 | Add-Member -MemberType NoteProperty -Name "Pick" -Value "BOXQ3" -Force
    $BoxQ3 | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $BoxQ3 | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force
    

    $BoxQ4 = New-Object System.Object
    $BoxQ4 | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $BoxQ4 | Add-Member -MemberType NoteProperty -Name "Pick" -Value "BOXQ4" -Force
    $BoxQ4 | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $BoxQ4 | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force

    $BoxT3 = New-Object System.Object
    $BoxT3 | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $BoxT3 | Add-Member -MemberType NoteProperty -Name "Pick" -Value "BOXT3" -Force
    $BoxT3 | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $BoxT3 | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force

    $BoxT4 = New-Object System.Object
    $BoxT4 | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $BoxT4 | Add-Member -MemberType NoteProperty -Name "Pick" -Value "BOXT4" -Force
    $BoxT4 | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $BoxT4 | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force


    $p1 = $pDogs.DOGID.indexof($adogs[0].DOGID)
    if ($p1 -lt 0) { $p1 = 10 }
    $p2 = $pDogs.DOGID.indexof($adogs[1].DOGID)
    if ($p2 -lt 0) { $p2 = 10 }
    $p3 = $pDogs.DOGID.indexof($adogs[2].DOGID)
    if ($p3 -lt 0) { $p3 = 10 }

    $BoxQ3.Correct = ($p1 -le 2) -and ($p2 -le 2)
    $BoxQ4.Correct = ($p1 -le 3) -and ($p2 -le 3)
    $BoxT3.Correct = ($p1 -le 2) -and ($p2 -le 2) -and ($p3 -le 2)
    $BoxT4.Correct = ($p1 -le 3) -and ($p2 -le 3) -and ($p3 -le 3)
    
    $accList.add($BoxQ3)
    $accList.add($BoxQ4)
    $accList.add($BoxT3)
    $accList.add($BoxT4)
}

function ProcessBets($betType, $picks, $bObject)
{
        if($betType -like "BOXQ3") { $COST = $BOXQ_3_COST }
        elseif($betType -like "BOXQ4") { $COST = $BOXQ_4_COST }
        elseif($betType -like "BOXT3") { $COST = $BOXT_3_COST }
        elseif($betType -like "BOXT4") { $COST = $BOXT_4_COST }

        $betamount = $BET
        $bName = "`$" + ($betamount)
        $bObject | Add-Member -MemberType NoteProperty -Name $bName -Value "" -Force

        $allBets = $picks.where( { $_.Pick -eq $betType } )
        $correctBets = $picks.where( { $_.correct -AND $_.Pick -eq $betType} )
        $bObject.$bName = -($COST * $allBets.Count)
        
        $correctBets.foreach( { 
            $cBet = $_
            $bObject.$bName += ([float]$cBet.Payout * $betamount) } )
        $bObject.PercentCorrect = ($correctBets.Count / $allBets.Count) * 100
        $bObject.NumBets = $allBets.Count
     
}

function calculatePayout($picks)
{
    $Payouts = @()
    

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "BOXQ3" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "BOXQ3" $picks $payout
    $Payouts += $payout

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "BOXQ4" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "BOXQ4" $picks $payout
    $Payouts += $payout

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "BOXT3" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "BOXT3" $picks $payout
    $Payouts += $payout

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "BOXT4" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "BOXT4" $picks $payout
    $Payouts += $payout

    Return $Payouts

 
}




$networkQuery = "SELECT DISTINCT ID FROM NETWORKDETAILS a INNER JOIN NETWORKRESULTS b ON a.ID = b.NNID WHERE a.TRACK IS NOT NULL AND b.BOXQ_4PRCNT IS NULL AND ID IN (SELECT DISTINCT NNID FROM PREDICTEDRESULTS)"
$networkDetails = ReadSQL($networkQuery)
$netCount = $networkDetails.count

$count = 0
foreach($network in $networkDetails)
{
    $netID = $network.ID
    $betData = New-Object System.Collections.Generic.List[object]
    Write-Host "Processing $netID..."

    $trackMonthQuery = "SELECT TRACK, MONTH FROM NETWORKDETAILS WHERE ID = '$netID'"
    $trackMonth = ReadSQL($trackMonthQuery)
    $trackID = $trackMonth.TRACK
    $month = $trackMonth.MONTH

    $RaceQuery = "SELECT RACEID, WINPAYING, PLACEPAYING, QUINELLAPAYING, TRIFECTAPAYING, FIRST4PAYING FROM RACES WHERE RACEID in ( SELECT DISTINCT RACEID FROM TRAININGDATA WHERE DATATYPE = 'TESTING') AND TRACKID = $trackID AND MONTH(STARTTIME) = $month ORDER BY newID()"
    $RaceDetails = ReadSQL($RaceQuery)


    $numbets = 0
    foreach($race in $RaceDetails)
    {
        $raceID = $race.RACEID
        $numbets++

        $predictQuery = "SELECT TOP 4 [DOGID], [PREDICTEDRESULTS] FROM PREDICTEDRESULTS WHERE RACEID = $RaceID AND NNID = '$netID' ORDER BY PREDICTEDRESULTS"        
        $predictResults = ReadSQL($predictQuery)

        if($predictResults -eq $NULL) { continue }
        
        $actualResultsQuery = "SELECT TOP 4 [DOGID] FROM RESULTS WHERE RACEID = $raceID ORDER BY RESULT"
        $actualResults = ReadSQL($actualResultsQuery)

        CheckPredictions $predictResults $actualResults $betData
    
        $entries = $betData.Count
        $betData[$entries-4].Payout = $race.QUINELLAPAYING
        $betData[$entries-4].RaceID = $race.RaceID
        $betData[$entries-3].Payout = $race.QUINELLAPAYING
        $betData[$entries-3].RaceID = $race.RaceID
        $betData[$entries-2].Payout = $race.TRIFECTAPAYING
        $betData[$entries-2].RaceID = $race.RaceID
        $betData[$entries-1].Payout = $race.TRIFECTAPAYING
        $betData[$entries-1].RaceID = $race.RaceID

  

    }
    $netPayout = calculatePayout $betData
    $BQ3PC = $netPayout[0].PercentCorrect
    $BQ4PC = $netPayout[1].PercentCorrect
    $BT3PC = $netPayout[2].PercentCorrect
    $BT4PC = $netPayout[3].PercentCorrect
    $BQ3PAY = $netPayout[0].'$1'
    $BQ4PAY = $netPayout[1].'$1'
    $BT3PAY = $netPayout[2].'$1'
    $BT4PAY = $netPayout[3].'$1'

    $insertQuery = "UPDATE NETWORKRESULTS SET BOXQ_4PRCNT=$BQ4PC,BOXQ_4PAY=$BQ4PAY,BOXQ_3PRCNT=$BQ3PC,BOXQ_3PAY=$BQ3PAY,BOXT_4PRCNT=$BT4PC,BOXT_4PAY=$BT4PAY,BOXT_3PRCNT=$BT3PC,BOXT_3PAY=$BT3PAY WHERE NNID = '$netID'"
    RunSQL($insertQuery)
    $netPayout | ft

    $count++
    $percent = ($count/($netCount+1))*100
    Write-Progress -Activity:"Processing Networks... ($percent%)" -PercentComplete:$percent
}

