        $con = New-Object System.Data.SqlClient.SqlConnection
        $con.ConnectionString = "Server=localhost;database=RacingRestore;Integrated Security=true"
        $con.Open()

function RunSQL($query)
{
    $cmd = New-Object System.Data.SqlClient.SqlCommand($query,$con)
    $cmd.CommandTimeout = 120
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


function TrainingSecondPass
{
    $trainLinesQuery = "SELECT RACEID, DOGID FROM TRAININGDATA WHERE DATATYPE is not NULL"
    $trainLinesData = ReadSQL($trainLinesQuery)

    $totalLines = $trainLinesData.Count
    $lineCount = 0
    foreach($line in $trainLinesData)
    {
        $dogID = $line.DOGID
        $raceID = $line.RACEID
        $otherDogsQuery = "SELECT TOP 3 [D_1_M],[D_2_M],[D_3_M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_A],[D_P_M],[D_PT_A],[D_PB_A],[D_PWC_A],[D_PTC_A] FROM TRAININGDATA WHERE RACEID = $raceID and DOGID <> $dogID ORDER BY [D_P_M] DESC"
        $otherDogs = ReadSQL($otherDogsQuery)

        
        
        if($otherDogs.Count -lt 3) { $updateQuery = "UPDATE TRAININGDATA SET DATATYPE = NULL WHERE RACEID = $raceID" }
        else
        {
            $updateQuery = "UPDATE TRAININGDATA SET "
            $vars = ($otherDogs[0] | Get-Member) | where { $_.MemberType -eq "Property" }
            $count = 1
            foreach($dog in $otherDogs)
            {
            
                foreach($var in $vars)
                {
                    $varName = $var.Name
                    $data = $dog.$varName
                    $updateQuery = $updateQuery + "$varName$count = $data,"
                }

                $count++
            }

            $updateQuery = $updateQuery.trim(",")
            $updateQuery = $updateQuery + " WHERE RACEID = $raceID AND DOGID = $dogID"
        
        }

        RunSQL($updateQuery)

        $lineCount++
        if($lineCount % 100 -eq 0)
        {
            $percent = $percent = [math]::round((($lineCount/$totalLines) * 100), 0)
            Write-Progress -Activity:"Processing Second Pass... ($percent%)" -PercentComplete:$percent
        }

       
    }

}


function ClassifyTestingData
{
    $tracksQuery = "SELECT DISTINCT TRACKID FROM TRACKS"
    $tracks = (ReadSQL($tracksQuery)).TRACKID
    $months = 12

    foreach($t in $tracks)
    {
        for($m = 1; $m -le $months; $m++)
        {
            $testDataQuery = "UPDATE TRAININGDATA SET DATATYPE = 'TESTING' WHERE RACEID IN (SELECT TOP 20 PERCENT RACEID FROM RACES WHERE RACEID in (SELECT DISTINCT RACEID FROM TRAININGDATA WHERE DATATYPE is not NULL) AND TRACKID = $t and MONTH(STARTTIME) = $m ORDER BY newid())"
            RunSQL($testDataQuery)
        }

    }

}


$RaceQuery = "SELECT [DOGID], [RACEID] FROM RESULTS"
$RaceData = ReadSQL($RaceQuery)

$truncQuery = "TRUNCATE TABLE TRAININGDATA"
RunSQL($truncQuery)

$raceDataQuery = "EXEC CreateTempRaceData"
RunSQL($raceDataQuery)

$count = 0

foreach($entry in $RaceData)
{ 
    $DogID = $entry.DOGID
    $RaceID = $entry.RACEID
    $entryQuery = "EXEC GenerateTrainingLine $DogID, $RaceID"
    RunSQL($entryQuery)

    if($count % 1000 -eq 0)
    {
        $percent = $percent = [math]::round((($count/$RaceData.Count) * 100), 0)
        Write-Progress -Activity:"Processing Data... ($percent%)" -PercentComplete:$percent
    }
    $count++

}

$nullDataQuery = "UPDATE TRAININGDATA SET DATATYPE = NULL WHERE RACEID IN (SELECT RACEID FROM RACES WHERE convert(date, STARTTIME) IN (SELECT DISTINCT TOP 180 convert(date, STARTTIME) FROM RACES))"

RunSQL($nullDataQuery)

ClassifyTestingData

TrainingSecondPass
