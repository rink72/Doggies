Import-Module sqlps -DisableNameChecking
$SQLLOCATION = "SQLSERVER:\SQL\localhost\SQLEXPRESS\databases\Racing"
Set-Location $SQLLOCATION

$standardRecNumQuery = "SELECT count(*) FROM ARCHIVERESULTS WHERE PLACE = 1"
$standardRecNum = (Invoke-Sqlcmd $standardRecNumQuery -SuppressProviderContextWarning).column1
$standardRecFirstQuery = "SELECT RACEID FROM ARCHIVERESULTS WHERE PLACE = 1 AND ACTUALRESULT = 1"
$standardRecFirst = Invoke-Sqlcmd $standardRecFirstQuery -SuppressProviderContextWarning
$standardRecFirstNum = $standardRecFirst.count
$STAND_First_Percentage = ($standardRecFirstNum/$standardRecNum)*100

$standardPlacingQuery = "SELECT RACEID, DOGID, ACTUALRESULT FROM ARCHIVERESULTS WHERE PLACE = 1 AND ACTUALRESULT < 4"
$standardPlacing = Invoke-Sqlcmd $standardPlacingQuery -SuppressProviderContextWarning

$STAND_Placing_Percentage = ($standardPlacing.count/$standardRecNum)*100

$STAND_First_Payout = -$standardRecNum
$STAND_Placing_Payout = -$standardRecNum

foreach($first in $standardRecFirst)
{
    $raceid = $first.RACEID
    $payoutQuery = "SELECT WINPAYING AS PAYOUT FROM RACES WHERE RACEID = $raceid"
    $STAND_first_Payout += [float](Invoke-Sqlcmd $payoutQuery -SuppressProviderContextWarning).payout
}

foreach($placing in $standardPlacing)
{
    $raceid = $placing.RACEID
    if($placing.ACTUALRESULT -eq 1) { $payoutQuery = "SELECT PLACEPAYING AS PAYOUT FROM RACES WHERE RACEID = $raceid AND PLACEPAYING is not NULL" }
    elseif($placing.ACTUALRESULT -eq 2) { $payoutQuery = "SELECT TWOPLACE AS PAYOUT FROM RACES WHERE RACEID = $raceid AND TWOPLACE is not NULL" }
    elseif($placing.ACTUALRESULT -eq 3) { $payoutQuery = "SELECT THREEPLACE AS PAYOUT FROM RACES WHERE RACEID = $raceid AND THREEPLACE is not NULL" }
    $STAND_Placing_Payout += [float](Invoke-Sqlcmd $payoutQuery -SuppressProviderContextWarning).payout

}


Write-Host "--------------------------------------------------------"
Write-Host "STANDARD Total Races: $standardRecNum"
Write-Host "--------------------------------------------------------"
Write-Host "STANDARD Correct Firsts: $standardRecFirstNum"
Write-Host "STANDARD Percentage First %: $STAND_First_Percentage"
Write-Host "STANDARD First Payout: $STAND_First_Payout"
Write-Host "--------------------------------------------------------"
Write-Host "STANDARD Correct Places: $($standardPlacing.count)"
Write-Host "STANDARD Percentage Place %: $STAND_Placing_Percentage"
Write-Host "STANDARD Placing Payout: $STAND_Placing_Payout"
Write-Host "--------------------------------------------------------"


$placingRecNumQuery = "SELECT count(*) FROM ARCHIVERESULTS WHERE PLACEREC = 1"
$placingRecNum = (Invoke-Sqlcmd $placingRecNumQuery -SuppressProviderContextWarning).column1
$placingRecFirstQuery = "SELECT RACEID FROM ARCHIVERESULTS WHERE PLACEREC = 1 AND ACTUALRESULT = 1"
$placingRecFirst = Invoke-Sqlcmd $placingRecFirstQuery -SuppressProviderContextWarning
$placingRecFirstNum = $placingRecFirst.count 
$PLACE_First_Percentage = ($placingRecFirstNum/$placingRecNum)*100

$placingPlacingQuery = "SELECT RACEID, DOGID, ACTUALRESULT FROM ARCHIVERESULTS WHERE PLACEREC = 1 AND ACTUALRESULT < 4"
$placingPlacing = Invoke-Sqlcmd $placingPlacingQuery -SuppressProviderContextWarning

$PLACE_Placing_Percentage = ($placingPlacing.count/$placingRecNum)*100

$PLACE_First_Payout = -$placingRecNum
$PLACE_Placing_Payout = -$placingRecNum

foreach($first in $placingRecFirst)
{
    $raceid = $first.RACEID
    $payoutQuery = "SELECT WINPAYING AS PAYOUT FROM RACES WHERE RACEID = $raceid"
    $PLACE_first_Payout += [float](Invoke-Sqlcmd $payoutQuery -SuppressProviderContextWarning).payout
}

foreach($placing in $placingPlacing)
{
    $raceid = $placing.RACEID
    if($placing.ACTUALRESULT -eq 1) { $payoutQuery = "SELECT PLACEPAYING AS PAYOUT FROM RACES WHERE RACEID = $raceid AND PLACEPAYING is not NULL" }
    elseif($placing.ACTUALRESULT -eq 2) { $payoutQuery = "SELECT TWOPLACE AS PAYOUT FROM RACES WHERE RACEID = $raceid AND TWOPLACE is not NULL" }
    elseif($placing.ACTUALRESULT -eq 3) { $payoutQuery = "SELECT THREEPLACE AS PAYOUT FROM RACES WHERE RACEID = $raceid AND THREEPLACE is not NULL" }
    $PLACE_Placing_Payout += [float](Invoke-Sqlcmd $payoutQuery -SuppressProviderContextWarning).payout

}



Write-Host "PLACE Total Races: $placingRecNum"
Write-Host "--------------------------------------------------------"
Write-Host "PLACE Correct Firsts: $placingRecFirstNum"
Write-Host "PLACE Percentage First %: $PLACE_First_Percentage"
Write-Host "PLACE First Payout: $PLACE_First_Payout"
Write-Host "--------------------------------------------------------"
Write-Host "PLACE Correct Places: $($placingPlacing.count)"
Write-Host "PLACE Percentage Place %: $PLACE_Placing_Percentage"
Write-Host "PLACE Placing Payout: $PLACE_Placing_Payout"
Write-Host "--------------------------------------------------------"




