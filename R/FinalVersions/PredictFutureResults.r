library(RODBC)
library(nnet)
library(neuralnet)

	args = commandArgs(trailingOnly = TRUE)
	trackID = args[1]
	month = args[2]

	racingConn = odbcConnect("racing")
	modelQuery = paste("SELECT TOP 1 ID FROM NETWORKDETAILS a INNER JOIN NETWORKRESULTS b on a.ID = b.NNID WHERE a.TRACK =", trackID, "AND a.MONTH =", month, "ORDER BY b.PLACEPRCNT DESC", sep = " ")
	model = sqlQuery(racingConn, modelQuery)
	
	nnID = data.frame(model[, 1])
	nnID = data.frame(lapply(nnID, as.character), stringsAsFactors=FALSE)
	nnID = nnID[,1]
	
	networkQuery = paste("SELECT id, nnfilename, query from NETWORKDETAILS WHERE ID = '", nnID, "'", sep = "")
	network = sqlQuery(racingConn, networkQuery)
	
	query = data.frame(network[, 3])
	query = data.frame(lapply(query, as.character), stringsAsFactors=FALSE)
	query = query[,1]
	query = paste("SELECT RACEID, DOGID,", query, "FROM FUTUREDATA WHERE RACEID IN (SELECT RACEID FROM RACES WHERE TRACKID =", trackID, "AND MEETID in (SELECT MEETID FROM MEETS WHERE DATE = convert(date, getdate()))) ORDER by newID()", sep = " ")
	queryData = sqlQuery(racingConn, query)

	nnfilename = data.frame(network[, 2])
	nnfilename = data.frame(lapply(nnfilename, as.character), stringsAsFactors=FALSE)
	nnfilename = as.character(nnfilename)
	
	load(nnfilename)
	inputData = queryData[,3:(ncol(queryData))]
	results = compute(net, inputData)
	results = results$net.result
	PredictedResults = results
	output = cbind(queryData[,1:2], nnID, PredictedResults)
	sqlSave(racingConn, output, tablename = "FUTUREPREDICTIONS", append = TRUE)
	
	
	close(racingConn)