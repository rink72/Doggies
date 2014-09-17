Import-Module sqlps

$TIMEPERIOD = 2
$STARTDATE = (Get-Date).AddDays(-1)
$FINISHDATE = $STARTDATE.AddDays(-$TIMEPERIOD)
$SQLLOCATION = "SQLSERVER:\SQL\localhost\SQLEXPRESS\databases\Racing"
$TABURL = "https://ebet.tab.co.nz"


$racecount = 0

Push-Location
Set-Location $SQLLOCATION

for($currentdate = $STARTDATE; $currentdate -ge $FINISHDATE; $currentdate = $currentdate.AddDays(-1))
{
    $d = $currentdate.Day
    $m = $currentdate.Month
    $y = $currentdate.Year
    
    $URL = "https://ebet.tab.co.nz/ebet/ResultsArchive?day=$d&month=$m&year=$y"    

    $page = Invoke-WebRequest -Uri $URL
    $races = $page.Links | where {$_.innerHTML -like '*GREYHOUND*'}

    $racecount = $racecount + $races.Count

    foreach($race in $races)
    {
        $meetNo = $race.innerText.split(' ')
        $meetNo = $meetNo[0]
        $meetNo = $meetNo.trim('M')

        $URL = $TABURL + $race.href

        $SQLCmd = "exec AddRacingDownload @MEET_NO = $meetNo, @URL = '$URL', @RACEDATE = '$currentdate'"
        Invoke-Sqlcmd $SQLCmd -SuppressProviderContextWarning
           

    }



}

Write-Host "Found $racecount meets."

Pop-Location