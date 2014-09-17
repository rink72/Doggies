Import-Module sqlps
$BET = 5
$SQLLOCATION = "SQLSERVER:\SQL\localhost\SQLEXPRESS\databases\Racing"


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

    $First4 = New-Object System.Object
    $First4 | Add-Member -MemberType NoteProperty -Name "RaceID" -Value "" -Force
    $First4 | Add-Member -MemberType NoteProperty -Name "Pick" -Value "First4" -Force
    $First4 | Add-Member -MemberType NoteProperty -Name "Correct" -Value "" -Force
    $First4 | Add-Member -MemberType NoteProperty -Name "Payout" -Value "" -Force

    $First.Correct = $correct[0]
    $Trifecta.Correct = $correct[0] -and $correct[1] -and $correct[2]
    $First4.Correct = $correct[0] -and $correct[1] -and $correct[2] -and $correct[3]

    $pPos = $aDogs.DOGID.indexof($pDogs[0].DOGID)
    $Placing.correct = ($pPos -le 3) -and ($pPos -gt -1)
    
    $quinPick = ($aDogs[0].DOGID -eq $pDogs[1].DOGID) -AND ($aDogs[1].DOGID -eq $pDogs[0].DOGID)
    $Quin.correct = ($correct[0] -and $correct[1]) -OR $quinPick

    
    $accList.add($First)
    $accList.add($Placing)
    $accList.add($Quin)
    $accList.add($Trifecta)
    $accList.add($First4)

    #return $accList
}

function ProcessBets($betType, $picks, $bObject)
{
   for($i=1; $i -le 5; $i++)
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

    $payout = New-Object System.Object
    $payout | Add-Member -MemberType NoteProperty -Name "Type" -Value "First4" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "PercentCorrect" -Value "" -Force
    $payout | Add-Member -MemberType NoteProperty -Name "NumBets" -Value "" -Force
    ProcessBets "First4" $picks $payout
    $Payouts += $payout


    Return $Payouts

 
}




Push-Location
Set-Location $SQLLOCATION

$RaceQuery = "SELECT RACEID, WINPAYING, PLACEPAYING, QUINELLAPAYING, TRIFECTAPAYING, FIRST4PAYING FROM RACES WHERE RACEID in ( SELECT DISTINCT RACEID FROM FUTUREPREDICTIONS) ORDER BY newID()"
$RaceDetails = Invoke-Sqlcmd $RaceQuery -SuppressProviderContextWarning

$FP_Picks = 0
$FP_Payout = 0
$P_Picks = 0
$P_Payout = 0
$Q_Picks = 0
$Q_Payout = 0
$T_Picks = 0
$T_Payout = 0
$FF_Picks = 0
$FF_Payout = 0

$count = 0
$betData = New-Object System.Collections.Generic.List[object]


foreach($race in $RaceDetails)
{
    $count
    $raceID = $race.RACEID
    $predictQuery = "SELECT TOP 4 [DOGID], [PREDICTEDRESULTS] FROM FUTUREPREDICTIONS WHERE RACEID = $RaceID ORDER BY PREDICTEDRESULTS"
    #$predictQuery = "SELECT TOP 4 [DOGID], [PREDICTEDRESULTS] FROM FUTUREPREDICTIONS WHERE RACEID = $RaceID AND (SELECT TOP 1 PREDICTEDRESULTS FROM FUTUREPREDICTIONS WHERE RACEID = $RaceID ORDER BY PREDICTEDRESULTS) < 0 ORDER BY PREDICTEDRESULTS"
    $predictResults = Invoke-Sqlcmd $predictQuery -SuppressProviderContextWarning
    

    if($predictResults -eq $NULL) 
    { 
        $count++
        continue 
    }

    $actualResultsQuery = "SELECT TOP 4 [DOGID] FROM FUTURERESULTS WHERE RACEID = $raceID ORDER BY RESULT"
    $actualResults = Invoke-Sqlcmd $actualResultsQuery -SuppressProviderContextWarning

    CheckPredictions $predictResults $actualResults $betData
    
    $entries = $betData.Count
    $betData[$entries-5].Payout = $race.WINPAYING
    $betData[$entries-5].RaceID = $race.RaceID
    $betData[$entries-4].Payout = $race.PLACEPAYING
    $betData[$entries-4].RaceID = $race.RaceID
    $betData[$entries-3].Payout = $race.QUINELLAPAYING
    $betData[$entries-3].RaceID = $race.RaceID
    $betData[$entries-2].Payout = $race.TRIFECTAPAYING
    $betData[$entries-2].RaceID = $race.RaceID
    $betData[$entries-1].Payout = $race.FIRST4PAYING
    $betData[$entries-1].RaceID = $race.RaceID

   
    if($count % 10 -eq 0)
    {
        $percent = $percent = [math]::round((($count/$RaceDetails.Count) * 100), 0)
        Write-Progress -Activity:"Processing Data... ($percent%)" -PercentComplete:$percent
    }
    $count++

}

$finalData = calculatePayout $betData
$finalData | ft

Pop-Location