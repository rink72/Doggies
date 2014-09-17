Import-Module sqlps


$RACEDISTANCEPOS = 6
$WEATHERPOS = 8
$TRACKCONDPOS = 6

$FIRSTBOXPOS = 15
$FIRSTDOGPOS = 16
$FIRSTPAYOUTPOS = 18
$FIRSTPLACINGPOS = 19

$SECONDBOXPOS = 21
$SECONDDOGPOS = 22
$SECONDPLACINGPOS = 25

$THIRDBOXPOS = 27
$THIRDDOGPOS = 28
$THIRDPLACINGPOS = 31

$QUINELLAPOS = 13
$TRIFECTAPOS = 17
$FIRST4POS = 21
$TVOFFSET = 2
$SQLLOCATION = "SQLSERVER:\SQL\localhost\SQLEXPRESS\databases\Racing"

function RemoveTags($tagString)
{
    $pos1 = $tagString.indexof(">")
    $pos2 = $tagString.indexof("<", $pos1)
    $result = $tagString.substring($pos1+1, $pos2-$pos1-1)
    
    Return $result
}

function ProcessOtherDogs($dogString)
{
    $dogString = $dogString.substring(51)
    $dogString = $dogString.trimend("</DIV>")
    $dogString = $dogString -split ","

    $position = 4

    $OtherDogs = @()

    foreach($line in $dogString)
    {
        $line = $line.trimStart("<BR>")
        $line = $line -split "-"
        $box = $line[0]
        $dog = $line[1]
        $OtherDogs += CreateDogEntry $dog $box $position
        $position++
    }
    
    Return $OtherDogs
}

function ProcessScratchDogs($dogString)
{
    $dogString = $dogString.substring(51)
    $dogString = $dogString.trimend("<BR></DIV>")
    $dogString = $dogString -replace "\.", ""
    $dogString = $dogString -split ","
    

    $position = 'S'

    $ScratchDogs = @()

    foreach($line in $dogString)
    {
        $line = $line -split "-"
        $box = $line[0]
        $dog = $line[1]
        $ScratchDogs += CreateDogEntry $dog $box $position
    }
    
    Return $ScratchDogs
}

function GetTrackID($TrackCode)
{
    $TrackQuery = "EXEC GetTrackID @TRACKCODE = '$TRACKCODE'"
    $TrackID = Invoke-Sqlcmd $TrackQuery -SuppressProviderContextWarning
    Return $TrackID.TrackID
}

function GetDogID($DogName)
{
    $DogQuery = "EXEC GetDogID @DOGNAME = '$DOGNAME'"
    $DogID = Invoke-Sqlcmd $DogQuery -SuppressProviderContextWarning
    Return $DogID.DogID
}

function CreateDogEntry($dogname, $box, $position)
{
    $dogname = $dogname -replace ",",""
    $dogname = $dogname -replace "\'",""
    $dogname = $dogname -replace ";",""
    $dogname = $dogname.toupper()
    $dogname = $dogname.trim()
    $Dog = New-Object System.Object
    $Dog | Add-Member -MemberType NoteProperty -Name "dogname" -Value $dogname -Force
    $Dog | Add-Member -MemberType NoteProperty -Name "Box" -Value $box -Force
    $Dog | Add-Member -MemberType NoteProperty -Name "FinalPosition" -Value $position -Force
    
    Return $Dog
}

function ProcessMeet($URL)
{
    $page = Invoke-WebRequest $URL.URL
    $RaceDate = $URL.RACEDATE
    
    $TrackCode = $URL.URL.split('/')
    $TrackCode = $TrackCode[4].Substring(0,4)
    $TrackID = GetTrackID($TrackCode)
   
    $races = $page.AllElements | where { $_.class -like "infoPanelContainer" }

    $SQLQueries = @()
    $raceNum = 1

    foreach($race in $races)
    {
        $raceText = $race.innerHTML -split "`r`n"
        
        $raceDistance = (RemoveTags($raceText[$RACEDISTANCEPOS])).trim()
        $raceDistance = $raceDistance.substring($raceDistance.length-5, 3)
        
        $conditionsPos = $raceText.IndexOf("<TABLE class=""autowidth raceResultsTrackInfo"">")
        $weather = (RemoveTags($raceText[$conditionsPos+$WEATHERPOS])).trim()
        $trackcond = (RemoveTags($raceText[$conditionsPos+$TRACKCONDPOS])).trim()
                
        $tablePos = $raceText.IndexOf("<TABLE class=""raceResults greyborder"">")
        $Dogs = @()
        if($tablePos -eq -1) 
        { 
            $raceNum++
            Continue 
        }
        
        $box = RemoveTags($racetext[$tablePos+$FIRSTBOXPOS])
        $dog = RemoveTags($racetext[$tablePos+$FIRSTDOGPOS])
        $position = 1
        $Dogs += CreateDogEntry $dog $box $position

        $box = RemoveTags($racetext[$tablePos+$SECONDBOXPOS])
        $dog = RemoveTags($racetext[$tablePos+$SECONDDOGPOS])
        $position = 2
        $Dogs += CreateDogEntry $dog $box $position

        $box = RemoveTags($racetext[$tablePos+$THIRDBOXPOS])
        $dog = RemoveTags($racetext[$tablePos+$THIRDDOGPOS])
        $position = 3
        $Dogs += CreateDogEntry $dog $box $position
        

        $WinReturn = RemoveTags($raceText[$tablePos+$FIRSTPAYOUTPOS])
        $Place1Return = RemoveTags($raceText[$tablePos+$FIRSTPLACINGPOS])
        $Place2Return = RemoveTags($raceText[$tablePos+$SECONDPLACINGPOS])
        $Place3Return = RemoveTags($raceText[$tablePos+$THIRDPLACINGPOS])
        

        $PayoutsPos = $raceText.IndexOf("<TABLE class=greyborder>")
        $Quinella = RemoveTags($raceText[$PayoutsPos+$QUINELLAPOS])
        $Trifecta = RemoveTags($raceText[$PayoutsPos+$TRIFECTAPOS])
        $First4 = RemoveTags($raceText[$PayoutsPos+$FIRST4POS])
        

        $OtherDogs = $raceText -like "*ALSO RAN:*"
        $Dogs += ProcessOtherDogs $OtherDogs
        
        $ScratchDogs = $raceText -like "*SCRATCHED:*"
        if($ScratchDogs -notlike "*All Start*") { $Dogs += ProcessScratchDogs $ScratchDogs }
                
        $RaceQuery = "EXEC AddRaceDetails @TRACKID = $trackid,@DATE = '$RaceDate',@DISTANCE = $raceDistance,@WINPAYING = $WinReturn,@PLACEPAYING = $Place1Return,@QUINELLAPAYING = $Quinella,@TRIFECTAPAYING = $Trifecta,@FIRST4PAYING = $First4,@TRACKCONDITION = '$trackcond',@WEATHER = '$weather',@RACENUMBER = $RaceNum"
        Invoke-Sqlcmd $RaceQuery -SuppressProviderContextWarning
        $RaceIDQuery =  "SELECT [RACEID] FROM [RACES] WHERE [TRACKID] = $TRACKID AND [DATE] = '$RaceDate' AND [RACENUMBER] = $RaceNum"
        $RaceID = Invoke-Sqlcmd $RaceIDQuery -SuppressProviderContextWarning
        $RaceID = $RaceID.RACEID
        
        foreach($dog in $Dogs)
        {
        
            $DogID = GetDogID($dog.DogName)
            $box = $dog.Box
            $position = $dog.FinalPosition
            $SQLQueries += "EXEC AddRaceResult @RACEID=$RaceID,@TRACKID=$TrackID,@DOGID=$DogID,@BOX=$box,@RESULT='$position'"
        }
        
        $raceNum++
       

    }
    
    if($Error.Count -eq 0) { foreach($query in $SQLQueries) { Invoke-Sqlcmd $query -SuppressProviderContextWarning } }
    

}


Push-Location
Set-Location $SQLLOCATION
$downloadQuery = "EXEC GetUnprocessedRaces"
$URLs = Invoke-Sqlcmd $downloadQuery -SuppressProviderContextWarning
$count = 0
$TotalPages = $URLs.Count

foreach($URL in $URLs) 
{ 
    $Error.Clear()
    $URLID = $URL.DOWNLOADID
    ProcessMeet($URL) 
    
    If($Error.Count -gt 0) { $downloadQuery = "EXEC UpdateDownloadDetails @DOWNLOADID = $URLID, @STATE = 3" }
    else { $downloadQuery = "EXEC UpdateDownloadDetails @DOWNLOADID = $URLID, @STATE = 1" }
    
    Invoke-Sqlcmd $downloadQuery -SuppressProviderContextWarning

    $count++
    Write-Host "Processed $count of $TotalPages..."
    
}

Pop-Location