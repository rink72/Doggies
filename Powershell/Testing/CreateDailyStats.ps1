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

$dateQuery = "SELECT DISTINCT DATE FROM ARCHIVERACES"
$dates = ReadSQL($dateQuery)
$dates = $dates.DATE

foreach($date in $dates)
{
    $trackQuery = "SELECT DISTINCT TRACKID FROM ARCHIVERACES WHERE DATE = '$date'"
    $tracks = ReadSQL($trackQuery)
    $tracks = $tracks.TRACKID

    foreach($track in $tracks)
    {
        $statQuery = "EXEC GenerateTrackStats @DATE = '$date', @TRACKID = $track"
        RunSQL($statQuery)
    }

}