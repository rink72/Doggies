DROP TABLE racing.dbo.tracks
select * into racing.dbo.TRACKS FROM racingrestore.dbo.tracks
DROP TABLE racing.dbo.races
select * into racing.dbo.RACES FROM racingrestore.dbo.RACES
DROP TABLE racing.dbo.MEETS
select * into racing.dbo.MEETS FROM racingrestore.dbo.MEETS
DROP TABLE racing.dbo.DOGS
select * into racing.dbo.DOGS FROM racingrestore.dbo.DOGS
DROP TABLE racing.dbo.NETWORKRESULTS
select * into racing.dbo.NETWORKRESULTS FROM racingrestore.dbo.NETWORKRESULTS
DROP TABLE racing.dbo.NETWORKDETAILS
select * into racing.dbo.NETWORKDETAILS FROM racingrestore.dbo.NETWORKDETAILS
DROP TABLE racing.dbo.RESULTS
select * into racing.dbo.RESULTS FROM racingrestore.dbo.RESULTS
update racing.dbo.NETWORKDETAILS SET nnfilename = REPLACE(nnfilename, 'Testing', 'FinalVersions')


