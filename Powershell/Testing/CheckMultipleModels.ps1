﻿# This script checks the results of using more than one model to predict results.
# Only races that match all filters are considered and then the accuracy of these predictions is calculated.

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



#Define NN's to be used as filters. Any number can be used.
    $NN = @()
    $NN += "Q_1_E_0.05_5000_133_N_2_rprop+_tanh"
    $NN += "Q_1_E_0.001_5000_85_N_2"
    $NN += "Q_1_E_0.01_5000_78_N_2"

$BET = 1



function checkPredictions($pDogs, $aDogs, $accList)
{
    $correct = @()
    $Picks = @()

    for($i=0;$i -le 3; $i++) { $correct += ($pDogs[$i].DOGID -eq $aDogs[$i].DOGID ) }


    $First = New-Object System.Object
    $First | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $First | Add-Member -MemberType NoteProperty -Name "Pick" -Value "First" -Force
    $First | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $First | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force
    
    $Placing = New-Object System.Object
    $Placing | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $Placing | Add-Member -MemberType NoteProperty -Name "Pick" -Value "Placing" -Force
    $Placing | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $Placing | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force

    $Quin = New-Object System.Object
    $Quin | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $Quin | Add-Member -MemberType NoteProperty -Name "Pick" -Value "Quinella" -Force
    $Quin | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $Quin | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force

    $Trifecta = New-Object System.Object
    $Trifecta | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $Trifecta | Add-Member -MemberType NoteProperty -Name "Pick" -Value "Trifecta" -Force
    $Trifecta | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $Trifecta | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force

    $First.Correct = $correct[0]
    $Trifecta.Correct = $correct[0] -and $correct[1] -and $correct[2]

    $pPos = $aDogs.DOGID.indexof($pDogs[0].DOGID)
    $Placing.correct = ($pPos -le 3) -and ($pPos -gt -1)

    $quinPick = ($aDogs[0].DOGID -eq $pDogs[1].DOGID) -AND ($aDogs[1].DOGID -eq $pDogs[0].DOGID)
    $Quin.correct = ($correct[0] -and $correct[1]) -OR $quinPick


    
    $accList.add($First)
    $accList.add($Placing)
    $accList.add($Quin)
    $accList.add($Trifecta)

    #return $accList
}

function ProcessBets($betType, $picks, $bObject)
{
   for($i=1; $i -le 1; $i++)
    {
        $betamount = $i * $BET
        $bName = "`$" + ($betamount)
        $bObject | Add-Member -MemberType NoteProperty -Name $bName -Value "" -Force

        $allBets = $picks | where { $_.Pick -eq $betType }
        $correctBets = $picks | where { $_.correct -AND $_.Pick -eq $betType}
        $bObject.$bName = -($betamount * $allBets.Count)
        
        foreach($cBet in $correctBets) { $bObject.$bName += ([float]$cBet.Payout * $betamount) }
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


$networkQuery = "SELECT DISTINCT ID FROM NETWORKDETAILS"
$RaceQuery = "SELECT RACEID, WINPAYING, PLACEPAYING, QUINELLAPAYING, TRIFECTAPAYING, FIRST4PAYING FROM RACES WHERE RACEID in ( SELECT DISTINCT RACEID FROM TRAININGDATA WHERE DATATYPE = 'TESTING') ORDER BY newID()"
$networkDetails = ReadSQL($networkQuery)
$RaceDetails = ReadSQL($RaceQuery)

$count = 0

$betData = New-Object System.Collections.Generic.List[object]

foreach($race in $RaceDetails)
{
    if($count % 10 -eq 0)
    {
        $percent = $percent = [math]::round((($count/($RaceDetails.Count)) * 100), 0)
        Write-Progress -Activity:"Processing Data... ($percent%)" -PercentComplete:$percent
    }
    
    $raceID = $race.RACEID
    $predictResults = New-Object System.Collections.Generic.List[object]
       
    foreach($net in $NN) 
    { 
        $predictQuery = "SELECT TOP 3 [DOGID] FROM PREDICTEDRESULTS WHERE RACEID = $RaceID AND NNID = '$net' ORDER BY PREDICTEDRESULTS"        
        $sqlResults = ReadSQL($predictQuery)
        $predictResults.add($sqlResults)
    }

    if($predictResults -eq $NULL) 
    { 
        $count++
        continue 
    }

    $1Dog = $predictResults[0][0].DOGID
    $2Dog = $predictResults[0][1].DOGID
    $3Dog = $predictResults[0][2].DOGID
    $4Dog = $predictResults[0][3].DOGID

    $continue = $true
    for($i=1;$i-lt$NN.Count;$i++)
    {
        if($1Dog -ne $predictResults[$i][0].DOGID) { $continue = $false }   
        if($2Dog -ne $predictResults[$i][1].DOGID) { $continue = $false }
        #if($3Dog -ne $predictResults[$i][2].DOGID) { $continue = $false }
        #if($4Dog -ne $predictResults[$i][3].DOGID) { $continue = $false }
    }
    
    
    if(!$continue)
    {
        $count++
        continue
    }

    $predictResults = $predictResults[0]
    $actualResultsQuery = "SELECT TOP 3 [DOGID] FROM RESULTS WHERE RACEID = $raceID ORDER BY RESULT"
    $actualResults = ReadSQL($actualResultsQuery)

    CheckPredictions $predictResults $actualResults $betData
    
    $entries = $betData.Count
    $betData[$entries-4].Payout = $race.WINPAYING
    $betData[$entries-4].RaceID = $race.RaceID
    $betData[$entries-3].Payout = $race.PLACEPAYING
    $betData[$entries-3].RaceID = $race.RACEID
    $betData[$entries-2].Payout = $race.QUINELLAPAYING
    $betData[$entries-2].RaceID = $race.RaceID
    $betData[$entries-1].Payout = $race.TRIFECTAPAYING
    $betData[$entries-1].RaceID = $race.RaceID

   

    $count++

}
$netPayout = calculatePayout $betData
$FPrcnt = $netPayout[0].PercentCorrect
$PPrcnt = $netPayout[1].PercentCorrect
$QPrcnt = $netPayout[2].PercentCorrect
$TPrcnt = $netPayout[3].PercentCorrect
$FPay = $netPayout[0].'$1'
$PPay = $netPayout[1].'$1'
$QPay = $netPayout[2].'$1'
$TPay = $netPayout[3].'$1'

$numBets = $netPayout[0].NumBets

$netid = ""
$NN.ForEach({ $netid = $netid + "," + $_})

$insertQuery = "INSERT INTO NETWORKRESULTS VALUES ('$netid', $FPrcnt, $FPay, $PPrcnt, $PPay, $QPrcnt, $QPay, $TPrcnt, $TPay, $numBets, '')"
RunSQL($insertQuery)

$netPayout | ft

