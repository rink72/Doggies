Import-Module sqlps
$SQLLOCATION = "SQLSERVER:\SQL\localhost\SQLEXPRESS\databases\Racing"

Push-Location

$RaceQuery = "SELECT [DOGID], [RACEID] FROM FUTURERESULTS"
$RaceData = Invoke-Sqlcmd $RaceQuery -SuppressProviderContextWarning

$count = 0

foreach($entry in $RaceData)
{
    $DogID = $entry.DOGID
    $RaceID = $entry.RACEID
    $entryQuery = "EXEC GenerateFutureLine $DogID, $RaceID"
    Invoke-Sqlcmd $entryQuery -SuppressProviderContextWarning

    if($count % 1000 -eq 0)
    {
        $percent = $percent = [math]::round((($count/$RaceData.Count) * 100), 0)
        Write-Progress -Activity:"Processing Data... ($percent%)" -PercentComplete:$percent
    }
    $count++

}




Pop-Location
