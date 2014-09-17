library(RODBC)
library(nnet)
library(neuralnet)

scaleTANH <- function(x) { 
    x <- sweep(x, 2, apply(x, 2, min)) 
    x <- sweep(x, 2, apply(x, 2, max), "/") 
    2*x - 1
}

scaleLOGICAL <- function(x) { 
    x <- sweep(x, 2, apply(x, 2, min)) 
    x <- sweep(x, 2, apply(x, 2, max), "/") 
}


normalize <- function(x) { 
    
	cNames = colnames(x)
	
	for(c in 1:ncol(x))
	{
		queryMean = paste("SELECT AVG(", cNames[c], ") FROM TRAININGDATA", sep = "")
		cMean = sqlQuery(racingConn, queryMean)
		cMean = as.numeric(cMean)
		querySD = paste("SELECT STDEV(", cNames[c], ") FROM TRAININGDATA", sep = "")
		cStdDev = sqlQuery(racingConn, querySD)
		cStdDev = as.numeric(cStdDev)
		
		x[,c] = (x[,c] - cMean) / cStdDev
	}
	
	return(x)
}

PredictResults <- function(net)
{
	racingConn = odbcConnect("racing")
	queries = "EXEC GetTrainingData @NUMnumbers = 300000"
	tableData = sqlQuery(racingConn, queries)
	tableData = tableData[sample(nrow(tableData)),]
	inputData = tableData[,3:(ncol(tableData)-1)]
	
	results = compute(net, inputData)
	results = results$net.result
	PredictedResults = results
	
	output = cbind(tableData[,1:2], PredictedResults)
	sqlSave(racingConn, output, tablename = "PREDICTEDRESULTS")
	close(racingConn)

}

BatchTrainOrder <-function()
{
	fileRoot = "C:/Projects/Racing/Networks/Testing/"
	
	queries = dim(1)
	queries[1] = "[D_1_M],[D_2_M],[D_3_M],[D_1_6M],[D_2_6M],[D_3_6M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_A],[D_P_M],[D_PT_A],[D_PB_A],[D_PWC_A],[D_PTC_A],[D_1MBREAK],[D_6MBREAK],[AD_AVGPP_M],[AD_AVGPP_A],[AD_AVGFP_M],[AD_AVGFP_A]"
	
	errors = dim(1)
	errors[1] = 0.05
	errors[2] = 0.01
	
	neurons = dim(2)
	neurons[1] = 2
	neurons[2] = 3
	
	racingConn = odbcConnect("racingTest")
	iterationQuery = "SELECT CONFIGVALUE FROM CONFIG WHERE CONFIGITEM = 'TRAININGITERATION'"
	iteration = sqlQuery(racingConn, iterationQuery)
	iteration = iteration[,1] + 1
	
	for (iter in iteration:(iteration + 10))
	{
		updateIteration = paste("UPDATE CONFIG SET CONFIGVALUE =", iter, "WHERE CONFIGITEM = 'TRAININGITERATION'", sep = " ")
		update = sqlQuery(racingConn, updateIteration)
		for(query in 1:length(queries))
		{
			for(error in 1:length(errors))
			{
				print(paste("Query", query, iter, errors[error], sep="_"))
				finalQuery = paste("SELECT TOP 5000 RACEID, DOGID,", queries[query], ", RESULT FROM TRAININGDATA WHERE DATATYPE = 'TRAINING'", sep = " ")
				queryData = sqlQuery(racingConn, finalQuery)
				queryData = queryData[,3:ncol(queryData)]
				queryData = queryData[sample(nrow(queryData)),]
				queryData$RESULT[queryData$RESULT > 4] = 10
				queryData = normalize(queryData)
				queryData = scaleTANH(queryData)
				queryData = data.matrix(queryData)
				
				vars = colnames(queryData[,1:ncol(queryData)-1])
				formula = as.formula(paste("RESULT ~ ", paste(vars, collapse= "+")))
				net = neuralnet(formula, queryData, hidden = c(2), threshold = errors[error], stepmax = 5000000, lifesign = "full", lifesign.step = 10000, act.fct = "tanh")
				
				if(!is.null(net$net))
				{
					netDetails = matrix(nrow=1,ncol=8)
					colnames(netDetails) = c("query", "error", "traininglines", "neurons", "nnfilename", "id", "PredictionType", "ActivationFunction")
					netDetails[1,1] = queries[query]
					netDetails[1,2] = errors[error]
					netDetails[1,3] = 5000
					netDetails[1,4] = "2"
					fileName = paste(fileRoot, "Q", query, "E", errors[error], 5000, iter, "N_2.r", sep="_")
					netDetails[1,5] = fileName
					NNID = paste("Q", query, "E", errors[error], 5000, iter, "N_2", sep="_")
					netDetails[1,6] = NNID
					netDetails[1,7] = "ORDER"
					netDetails[1,8] = "TANH"
					
					netDetails = as.data.frame(netDetails)

					save(net, file = fileName)
					sqlSave(racingConn, netDetails, tablename = "NETWORKDETAILS", append=TRUE)
					
				
				}
				
				net = neuralnet(formula, queryData, hidden = c(1), threshold = errors[error], stepmax = 5000000, lifesign = "full", lifesign.step = 10000, act.fct ="tanh")
				
				if(!is.null(net$net))
				{
					netDetails = matrix(nrow=1,ncol=8)
					colnames(netDetails) = c("query", "error", "traininglines", "neurons", "nnfilename", "id", "PredictionType","ActivationFunction")
					netDetails[1,1] = queries[query]
					netDetails[1,2] = errors[error]
					netDetails[1,3] = 5000
					netDetails[1,4] = "1"
					fileName = paste(fileRoot, "Q", query, "E", errors[error], 5000, iter, "N_1.r", sep="_")
					netDetails[1,5] = fileName
					NNID = paste("Q", query, "E", errors[error], 5000, iter, "N_1", sep="_")
					netDetails[1,6] = NNID
					netDetails[1,7] = "ORDER"
					netDetails[1,8] = "TANH"
					
					netDetails = as.data.frame(netDetails)

					save(net, file = fileName)
					sqlSave(racingConn, netDetails, tablename = "NETWORKDETAILS", append=TRUE)
					
					
					
				}
				

				
			}
		}
	
	}
	
	close(racingConn)
	return(netDetails)
}


BatchPredict <- function()
{
	
	racingConn = odbcConnect("racingTest")
	networkQuery = "SELECT id, nnfilename, query from NETWORKDETAILS WHERE ID NOT IN (SELECT DISTINCT NNID FROM PREDICTEDRESULTS)"
	networks = sqlQuery(racingConn, networkQuery)
	print(networks)
	
	
	for(network in 1:nrow(networks))
	{
		nnid = data.frame(networks[network, 1])
		nnfilename = data.frame(networks[network, 2])
		nnid = data.frame(lapply(nnid, as.character), stringsAsFactors=FALSE)
		nnfilename = data.frame(lapply(nnfilename, as.character), stringsAsFactors=FALSE)
		nnfilename = as.character(nnfilename)
		query = data.frame(networks[network, 3])
		query = data.frame(lapply(query, as.character), stringsAsFactors=FALSE)
		load(nnfilename)
		colnames(nnid) = c("nnid")

		print(nnid)
		query = paste("SELECT RACEID, DOGID,", query, "FROM TRAININGDATA WHERE DATATYPE = 'TESTING' ORDER BY newID()", sep = " ")
		dataSet = sqlQuery(racingConn, query)
		dataSet = dataSet[sample(nrow(dataSet)),]
		inputData = dataSet[,3:ncol(dataSet)]
		inputData = normalize(inputData)	
		
		results = compute(net, inputData)
		results = results$net.result
		PredictedResults = results
		
		output = cbind(nnid, dataSet[,1:2], PredictedResults)
		sqlSave(racingConn, output, tablename = "PREDICTEDRESULTS", append = TRUE)
	}
	

}

BatchTrainPlacing <-function()
{
	fileRoot = "C:/Projects/Racing/Networks/Testing/"
	
	queries = dim(1)
	queries[1] = "[D_1_M],[D_2_M],[D_3_M],[D_1_6M],[D_2_6M],[D_3_6M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_A],[D_P_M],[D_PT_A],[D_PB_A],[D_PWC_A],[D_PTC_A],[D_1MBREAK],[D_6MBREAK],[AD_AVGPP_M],[AD_AVGPP_A],[AD_AVGFP_M],[AD_AVGFP_A]"
	
	errors = dim(1)
	errors[1] = 0.05
	errors[2] = 0.01
	
	racingConn = odbcConnect("racingTest")
	iterationQuery = "SELECT CONFIGVALUE FROM CONFIG WHERE CONFIGITEM = 'TRAININGITERATION'"
	iteration = sqlQuery(racingConn, iterationQuery)
	iteration = iteration[,1] + 1
	
	for (iter in iteration:(iteration + 10))
	{
		updateIteration = paste("UPDATE CONFIG SET CONFIGVALUE =", iter, "WHERE CONFIGITEM = 'TRAININGITERATION'", sep = " ")
		update = sqlQuery(racingConn, updateIteration)
		for(query in 1:length(queries))
		{
			for(error in 1:length(errors))
			{
				print(paste("Query", query, iter, errors[error], sep="_"))
				finalQuery = paste("SELECT TOP 5000 RACEID, DOGID,", queries[query], ", RESULT FROM TRAININGDATA WHERE DATATYPE = 'TRAINING'", sep = " ")
				queryData = sqlQuery(racingConn, finalQuery)
				queryData = queryData[,3:ncol(queryData)]
				queryData = queryData[sample(nrow(queryData)),]
				queryData$RESULT[queryData$RESULT < 4] = 1
				queryData$RESULT[queryData$RESULT > 3] = -1
				queryData = normalize(queryData)
				queryData = data.matrix(queryData)
				
				vars = colnames(queryData[,1:ncol(queryData)-1])
				formula = as.formula(paste("RESULT ~ ", paste(vars, collapse= "+")))
				net = neuralnet(formula, queryData, hidden = c(2), threshold = errors[error], stepmax = 5000000, lifesign = "full", lifesign.step = 10000, act.fct = "tanh")
				
				if(!is.null(net$net))
				{
					netDetails = matrix(nrow=1,ncol=8)
					colnames(netDetails) = c("query", "error", "traininglines", "neurons", "nnfilename", "id", "PredictionType", "ActivationFunction")
					netDetails[1,1] = queries[query]
					netDetails[1,2] = errors[error]
					netDetails[1,3] = 5000
					netDetails[1,4] = "2"
					fileName = paste(fileRoot, "Q", query, "E", errors[error], 5000, iter, "N_2.r", sep="_")
					netDetails[1,5] = fileName
					NNID = paste("Q", query, "E", errors[error], 5000, iter, "N_2", sep="_")
					netDetails[1,6] = NNID
					netDetails[1,7] = "PLACING"
					netDetails[1,8] = "tanh"
					
					netDetails = as.data.frame(netDetails)

					save(net, file = fileName)
					sqlSave(racingConn, netDetails, tablename = "NETWORKDETAILS", append=TRUE)
					
				
				}
				
				net = neuralnet(formula, queryData, hidden = c(1), threshold = errors[error], stepmax = 5000000, lifesign = "full", lifesign.step = 10000, act.fct ="tanh")
				
				if(!is.null(net$net))
				{
					netDetails = matrix(nrow=1,ncol=8)
					colnames(netDetails) = c("query", "error", "traininglines", "neurons", "nnfilename", "id", "PredictionType", "ActivationFunction")
					netDetails[1,1] = queries[query]
					netDetails[1,2] = errors[error]
					netDetails[1,3] = 5000
					netDetails[1,4] = "1"
					fileName = paste(fileRoot, "Q", query, "E", errors[error], 5000, iter, "N_1.r", sep="_")
					netDetails[1,5] = fileName
					NNID = paste("Q", query, "E", errors[error], 5000, iter, "N_1", sep="_")
					netDetails[1,6] = NNID
					netDetails[1,7] = "PLACING"
					netDetails[1,8] = "tanh"
					
					netDetails = as.data.frame(netDetails)

					save(net, file = fileName)
					sqlSave(racingConn, netDetails, tablename = "NETWORKDETAILS", append=TRUE)
					
					
					
				}
				

				
			}
		}
	
	}
	
	close(racingConn)
	return(netDetails)
}
