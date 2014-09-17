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


$networksQuery = "SELECT DISTINCT NNID FROM PREDICTEDRESULTS"
$networks =  ReadSQL($networksQuery)


$netcount = 1
$totalnets = $networks.count

foreach($nn in $networks)
{
    
    Write-Host "Processing $netcount of $totalnets"

    $nnid = $nn.NNID
    $racesQuery = "SELECT DISTINCT RACEID FROM PREDICTEDRESULTS WHERE NNID = '$nnid'"
    $races = ReadSQL($racesQuery)

    $clearQuery = "DELETE FROM ACCURACYTRAINDATA WHERE NNID = '$nnid'"
    RunSQL($clearQuery)
    
    $count = 0
    foreach($race in $races)
    {
        $raceID = $race.RACEID

        $accuracyQuery = "EXEC GenerateAccuracyLine @RACEID = $raceID, @NNID = '$nnid'"
        RunSQL($accuracyQuery)
    
        if($count % 10 -eq 0)
        {
            $percent = $percent = [math]::round((($count/$races.count) * 100), 0)
            Write-Progress -Activity:"Processing Data... ($percent%)" -PercentComplete:$percent
        }
        $count++
    
    }

    $testDataQuery = "UPDATE ACCURACYTRAINDATA SET DATATYPE = 'TESTING' WHERE NNID = '$nnid' AND RACEID in ( SELECT TOP 10 PERCENT RACEID FROM ACCURACYTRAINDATA WHERE NNID = '$nnid' ORDER BY newID() )"
    RunSQL($testDataQuery)
    $netcount++

}