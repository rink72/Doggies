$PRODMODELFOLDER = "C:\Projects\Racing\Networks\FinalVersions\"
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

$trackQuery = "SELECT TRACKID FROM TRACKS"
$tracks = (ReadSQL($trackQuery)).TRACKID
$models = New-Object System.Collections.Generic.List[object]

foreach($t in $tracks)
{
    for($m=1;$m -le 12;$m++)
    {
        $modelQuery = "SELECT TOP 1 a.ID, b.PLACEPRCNT, a.NNFILENAME FROM NETWORKDETAILS a INNER JOIN NETWORKRESULTS b on a.ID = b.NNID WHERE TRACK = $t AND MONTH = $m  AND b.PLACEPRCNT > 60 ORDER BY b.PLACEPRCNT DESC"
        $mEntry = ReadSQL($modelQuery)
        $models.add($mEntry)

    }


}

$models.NNFILENAME.foreach({ Copy-Item $_ -Destination $PRODMODELFOLDER -Force })


