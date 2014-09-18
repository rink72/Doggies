$MINPERCENT = "58"
$MONTHS = 12

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

function processNetwork($netID, $raceDetails)
{
    
    $betData = New-Object System.Collections.Generic.List[object]

    $numbets = 0
    $count = 0
    foreach($race in $RaceDetails)
    {
        $raceID = $race.RACEID
        $numbets++

        $predictQuery = "SELECT TOP 3 [DOGID], [PREDICTEDRESULTS] FROM PREDICTEDRESULTS WHERE RACEID = $RaceID AND NNID = '$netID' ORDER BY PREDICTEDRESULTS"        
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
        $betData[$entries-4].Payout = $race.WINPAYING
        $betData[$entries-4].RaceID = $race.RaceID
        $betData[$entries-3].Payout = $race.PLACEPAYING
        $betData[$entries-3].RaceID = $race.RaceID
        $betData[$entries-2].Payout = $race.QUINELLAPAYING
        $betData[$entries-2].RaceID = $race.RaceID
        $betData[$entries-1].Payout = $race.TRIFECTAPAYING
        $betData[$entries-1].RaceID = $race.RaceID

   
        
        $percent = $percent = [math]::round((($count/($RaceDetails.count)) * 100), 0)
        if($percent -eq $NULL) { $percent = 0 }
        Write-Progress -Activity:"Processing Data... ($percent%)" -PercentComplete:$percent -Id 4 -ParentId 3
        $count++

    }
    Return($betData)


}




$modelQuery = "SELECT a.ID FROM NETWORKDETAILS a INNER JOIN NETWORKRESULTS b on a.ID = b.NNID WHERE b.PLACEPRCNT > $MINPERCENT" #AND a.ID NOT IN (SELECT DISTINCT NNID FROM TESTINGSTATISTICS)"
$models = (ReadSQL($modelQuery)).ID

$tracksQuery = "SELECT TRACKID FROM TRACKS"
$tracks = (ReadSQL($tracksQuery)).TRACKID

$mCount = 1
foreach($model in $models)
{
    
    $percent = $percent = [math]::round((($mCount/($models.count)) * 100), 0)
    Write-Progress -Activity:"Processing Model $model... ($percent%)" -PercentComplete:$percent -Id 1
    
    $tCount = 1
    foreach($t in $tracks)
    {
        $percent = $percent = [math]::round((($tCount/($tracks.count)) * 100), 0)
        Write-Progress -Activity:"Processing Track $t... ($percent%)" -PercentComplete:$percent -Id 2 -ParentId 1 
       
       
        for($m = 1; $m -le $MONTHS; $m++)
        {            
            $percent = $percent = [math]::round((($m/($MONTHS)) * 100), 0)
            Write-Progress -Activity:"Processing Month $m... ($percent%)" -PercentComplete:$percent -Id 3 -ParentId 2
            
            $racesQuery = "SELECT RACEID, WINPAYING, PLACEPAYING, QUINELLAPAYING, TRIFECTAPAYING FROM RACES WHERE TRACKID = $t and month(STARTTIME) = $m AND RACEID in ( SELECT DISTINCT RACEID FROM TRAININGDATA WHERE DATATYPE = 'TESTING') ORDER BY newID()"
            $races = ReadSQL($racesQuery)
            $raceData = processNetwork -netID $model -raceDetails $races

            $totalRaces = ($raceData | where { $_.Pick -eq "First" }).count
            if($totalRaces -gt 0)
            {
                $firsts = $raceData | where { $_.Pick -eq "First" -and $_.correct -eq "TRUE"}
                $firstsCorrect = $firsts.count
                $firstsPrcnt = ($firstsCorrect / $totalRaces) * 100
                $firstsPay = (($firsts | Measure-Object Payout -Sum)).SUM - $totalRaces
                
                $places = $raceData | where { $_.Pick -eq "Placing" -and $_.correct -eq "TRUE"}
                $placesCorrect = $places.count
                $placesPrcnt = ($placesCorrect / $totalRaces) * 100
                $placesPay = (($places | Measure-Object Payout -sum)).SUM - $totalRaces

                $quins = $raceData | where { $_.Pick -eq "Quinella" -and $_.correct -eq "TRUE"}
                $quinsCorrect = $quins.count
                $quinsPrcnt = ($quinsCorrect / $totalRaces) * 100
                $quinsPay = (($quins | Measure-Object Payout -Sum)).SUM - $totalRaces

                $tris = $raceData | where { $_.Pick -eq "Trifecta" -and $_.correct -eq "TRUE"}
                $trisCorrect = $tris.count
                $trisPrcnt = ($trisCorrect / $totalRaces) * 100
                $trisPay = (($tris | Measure-Object Payout -Sum)).SUM - $totalRaces

            }
            else
            {
                $firsts = 0
                $firstsCorrect = 0
                $firstsPrcnt = 0
                $firstsPay = 0
                $places = 0
                $placesCorrect = 0
                $placesPrcnt = 0
                $placesPay = 0
                $quins = 0 
                $quinsCorrect = 0
                $quinsPrcnt = 0
                $quinsPay = 0
                $tris = 0
                $trisCorrect = 0
                $trisPrcnt = 0
                $trisPay = 0

            }

            if($totalRaces -ne 0)
            {
                $statQuery = "INSERT INTO TESTINGSTATISTICS ([NNID],[MONTH],[TRACKID],[TOTALRACES],[FIRSTS],[FPRCNT],[FPAY],[PLACES],[PPRCNT],[PPAY],[QUIN],[QPRNCT],[QPAY],[TRI],[TPRCNT],[TPAY]) VALUES ('$model', $m, $t, $totalRaces, $firstsCorrect, $firstsPrcnt, $firstsPay, $placesCorrect, $placesPrcnt, $placesPay, $quinsCorrect, $quinsPrcnt, $quinsPay, $trisCorrect, $trisPrcnt, $trisPay)" 
                RunSQL($statQuery)
            }
        }
        $tCount++

    }



    $mCount++


}
