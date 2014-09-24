library(RODBC)
library(nnet)
library(neuralnet)

scaleTANH <- function(nnid, x) { 
	
	cNames = colnames(x)
	racingConn = odbcConnect("racingTest")
	
	for(c in 1:ncol(x))
	{
		qMax = paste("SELECT VALUE FROM FEATURES_DETAIL WHERE NNID = '", nnid, "' AND DESCRIPTION = 'MAX' AND FEATURE = '", cNames[c],"'", sep = "")
		cMax = sqlQuery(racingConn, qMax)
		cMax = as.numeric(cMax)
		qMin = paste("SELECT VALUE FROM FEATURES_DETAIL WHERE NNID = '", nnid, "' AND DESCRIPTION = 'MIN' AND FEATURE = '", cNames[c],"'", sep = "")
		cMin = sqlQuery(racingConn, qMin)
		cMin = as.numeric(cMin)
		
		x[,c] = (x[,c] - cMin) / (cMax - cMin)
		x[,c] = (2* x[,c]) - 1
	}
	
	return(x)
}


normalize <- function(nnid, x) { 
    
	cNames = colnames(x)
	racingConn = odbcConnect("racingTest")
	
	for(c in 1:ncol(x))
	{
		qMean = paste("SELECT VALUE FROM FEATURES_DETAIL WHERE NNID = '", nnid, "' AND DESCRIPTION = 'MEAN' AND FEATURE = '", cNames[c],"'", sep = "")
		cMean = sqlQuery(racingConn, qMean)
		cMean = as.numeric(cMean)
		qSD = paste("SELECT VALUE FROM FEATURES_DETAIL WHERE NNID = '", nnid, "' AND DESCRIPTION = 'STDDEV' AND FEATURE = '", cNames[c],"'", sep = "")
		cStdDev = sqlQuery(racingConn, qSD)
		cStdDev = as.numeric(cStdDev)
		
		x[,c] = (x[,c] - cMean) / cStdDev
	}
	
	return(x)
}
	args = commandArgs(trailingOnly = TRUE)
	trackID = args[1]
	month = args[2]

	racingConn = odbcConnect("racingTest")
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
	inputData = normalize(nnID, inputData)
	inputData = scaleTANH(nnID, inputData)
	
	results = compute(net, inputData)
	results = results$net.result
	PredictedResults = results
	output = cbind(queryData[,1:2], nnID, PredictedResults)
	sqlSave(racingConn, output, tablename = "FUTUREPREDICTIONS", append = TRUE)
	
	
	close(racingConn)