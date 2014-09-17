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
	racingConn = odbcConnect("racingTest")
	
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


normalize2 <- function(x) { 
    
	cNames = colnames(x)
	racingConn = odbcConnect("racingTest")
	
	for(c in 1:ncol(x))
	{
		queryMax = paste("SELECT MAX(", cNames[c], ") FROM TRAININGDATA", sep = "")
		cMax = sqlQuery(racingConn, queryMax)
		cMax = as.numeric(cMax)
		queryMin = paste("SELECT MIN(", cNames[c], ") FROM TRAININGDATA", sep = "")
		cMin = sqlQuery(racingConn, queryMin)
		cMin = as.numeric(cMin)
		
		x[,c] = (x[,c] - cMin) / (cMax - cMin)
	}
	
	return(x)
}

cleanData <- function(x)
{
	cNames = colnames(x)
	for(c in 1:ncol(x))
	{
		cNames[,is.na(cNames[,c])] = -1
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
	LEARNINGRATE = 0.01
	
	queries = dim(1)
	queries[1] = "[D_1_M],[D_2_M],[D_3_M],[D_1_6M],[D_2_6M],[D_3_6M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_M],[D_PB_A],[D_PWC_A],[D_1MBREAK], [D_1_M1],[D_2_M1],[D_3_M1],[D_1D_A1],[D_2D_A1],[D_3D_A1],[D_P_A1],[D_P_M1],[D_PB_A1],[D_PWC_A1],[D_1_M2],[D_2_M2],[D_3_M2],[D_1D_A2],[D_2D_A2],[D_3D_A2],[D_P_A2],[D_P_M2],[D_PB_A2],[D_PWC_A2],[D_1_M3],[D_2_M3],[D_3_M3],[D_1D_A3],[D_2D_A3],[D_3D_A3],[D_P_A3],[D_P_M3],[D_PB_A3],[D_PWC_A3]"
	queries[2] = "[D_1_M],[D_2_M],[D_3_M],[D_1_6M],[D_2_6M],[D_3_6M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_M],[D_PB_A],[D_PWC_A],[D_1MBREAK], [D_1_M1],[D_2_M1],[D_3_M1],[D_1D_A1],[D_2D_A1],[D_3D_A1],[D_P_A1],[D_P_M1],[D_PT_A1],[D_PB_A1],[D_PWC_A1],[D_PTC_A1],[D_1_M2],[D_2_M2],[D_3_M2],[D_1D_A2],[D_2D_A2],[D_3D_A2],[D_P_A2],[D_P_M2],[D_PT_A2],[D_PB_A2],[D_PWC_A2],[D_PTC_A2],[D_1_M3],[D_2_M3],[D_3_M3],[D_1D_A3],[D_2D_A3],[D_3D_A3],[D_P_A3],[D_P_M3],[D_PT_A3],[D_PB_A3],[D_PWC_A3],[D_PTC_A3]"
	queries[3] = "[D_1_M],[D_2_M],[D_3_M],[D_1_6M],[D_2_6M],[D_3_6M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_M],[D_PB_A],[D_PWC_A],[D_1MBREAK],[D_1_M1],[D_2_M1],[D_3_M1],[D_1_M2],[D_2_M2],[D_3_M2],[D_1_M3],[D_2_M3],[D_3_M3]"
	#queries[4] = "[D_1_M],[D_2_M],[D_3_M],[D_1_6M],[D_2_6M],[D_3_6M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_M],[D_PB_A],[D_PTC_A],[D_1_M1],[D_2_M1],[D_3_M1],[D_1D_A1],[D_2D_A1],[D_3D_A1],[D_P_A1],[D_P_M1],[D_PT_A1],[D_PB_A1],[D_PWC_A1],[D_PTC_A1],[D_1_M2],[D_2_M2],[D_3_M2],[D_1D_A2],[D_2D_A2],[D_3D_A2],[D_P_A2],[D_P_M2],[D_PT_A2],[D_PB_A2],[D_PWC_A2],[D_PTC_A2],[D_1_M3],[D_2_M3],[D_3_M3],[D_1D_A3],[D_2D_A3],[D_3D_A3],[D_P_A3],[D_P_M3],[D_PT_A3],[D_PB_A3],[D_PWC_A3],[D_PTC_A3]"
	#queries[5] = "[D_1_M],[D_2_M],[D_3_M],[D_1_6M],[D_2_6M],[D_3_6M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_A],[D_P_M],[D_PT_A],[D_PB_A],[D_PWC_A],[D_PTC_A],[D_1_M1],[D_2_M1],[D_3_M1],[D_1D_A1],[D_2D_A1],[D_3D_A1],[D_P_A1],[D_P_M1],[D_PT_A1],[D_PB_A1],[D_PWC_A1],[D_PTC_A1],[D_1_M2],[D_2_M2],[D_3_M2],[D_1D_A2],[D_2D_A2],[D_3D_A2],[D_P_A2],[D_P_M2],[D_PT_A2],[D_PB_A2],[D_PWC_A2],[D_PTC_A2],[D_1_M3],[D_2_M3],[D_3_M3],[D_1D_A3],[D_2D_A3],[D_3D_A3],[D_P_A3],[D_P_M3],[D_PT_A3],[D_PB_A3],[D_PWC_A3],[D_PTC_A3]"
		
	errors = dim(1)
	errors[1] = 0.05
	errors[2] = 0.01
	
	neurons = dim(1)
	neurons[1] = 2
	neurons[2] = 4
	neurons[3] = 8
	#neurons$four = 10
	#neurons$five = 15
	
	algs = dim(1)
	algs[1] = "backprop"
	algs[2] = "rprop+"
	#algs[3] = "rprop-"
	#algs[4] = "sag"
	#algs[4] = "slr"
	
	actFunc = dim(1)
	#actFunc[1] = "linear"
	actFunc[1] = "tanh"
	#actFunc[2] = "logistic"
	
	scales = dim(1)
	scales[1] = "NO"
	scales[2] = "TANH"
	
	normalise = dim(1)
	normalise[1] = "NO"
	normalise[2] = "MAX_MIN"
	normalise[3] = "MEAN_STDDEV"
	
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
				
				
				for(n in 1:length(neurons))
				{
					for(alg in 1:length(algs))
					{
					
						for(act in 1:length(actFunc))
						{
							for(norms in 1:length(normalise))
							{
								for(sc in 1:length(scales))
								{
							
									print(paste("Query", query, iter, errors[error], neurons[n], algs[alg], actFunc[act], scales[sc], normalise[norms], sep="_"))
									
									finalQuery = paste("SELECT TOP 5000 RACEID, DOGID,", queries[query], ", RESULT FROM TRAININGDATA WHERE DATATYPE = 'TRAINING' ORDER BY newid()", sep = " ")
									queryData = sqlQuery(racingConn, finalQuery)
									queryData = queryData[,3:ncol(queryData)]
									queryData = queryData[sample(nrow(queryData)),]
									queryData$RESULT[queryData$RESULT > 4] = 10
									
									if(normalise[norms] == "MEAN_STDDEV") { queryData = normalize(queryData) }
									else if (normalise[norms] == "MAX_MIN") { queryData = normalize2(queryData) }
									if(scales[sc] == "TANH") { queryData = scaleTANH(queryData) }
									
									queryData = data.matrix(queryData)
									
									vars = colnames(queryData[,1:(ncol(queryData)-1)])
									formula = as.formula(paste("RESULT ~ ", paste(vars, collapse= "+")))
									
									net = as.null()
									
									if(algs[alg] == "backprop")
									{ net = neuralnet(formula, queryData, hidden = c(neurons[n]), threshold = errors[error], stepmax = 5000000, lifesign = "full", lifesign.step = 10000, act.fct = actFunc[act]) }
									else { net = neuralnet(formula, queryData, hidden = c(neurons[n]), threshold = errors[error], stepmax = 5000000, lifesign = "full", lifesign.step = 10000, act.fct = actFunc[act], algorithm = algs[alg]) }
									
									if(!is.null(net$net))
									{
										netDetails = matrix(nrow=1,ncol=11)
										colnames(netDetails) = c("query", "error", "traininglines", "neurons", "nnfilename", "id", "PredictionType", "ActivationFunction", "NNAlgorithm", "Normalised", "Scaled")
										netDetails[1,1] = queries[query]
										netDetails[1,2] = errors[error]
										netDetails[1,3] = 5000
										netDetails[1,4] = neurons[n]
										fileName = paste(fileRoot, "Q", query, "E", errors[error], 5000, iter, "N", neurons[n], algs[alg], actFunc[act], normalise[norms], scales[sc], ".r", sep="_")
										netDetails[1,5] = fileName
										NNID = paste("Q", query, "E", errors[error], 5000, iter, "N", neurons[n], algs[alg], actFunc[act], normalise[norms], scales[sc], sep="_")
										netDetails[1,6] = NNID
										netDetails[1,7] = "ORDER"
										netDetails[1,8] = actFunc[act]
										netDetails[1,9] = algs[alg]
										netDetails[1,10] = normalise[norms]
										netDetails[1,11] = scales[sc]
										
										netDetails = as.data.frame(netDetails)

										save(net, file = fileName)
										sqlSave(racingConn, netDetails, tablename = "NETWORKDETAILS", append=TRUE)
										
									
									}
								}
							}
						}
					}
				
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
	networkQuery = "SELECT id, nnfilename, query, Normalised, Scaled from NETWORKDETAILS WHERE ID NOT IN (SELECT DISTINCT NNID FROM PREDICTEDRESULTS)"
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
		if(networks[network, 4] == "MEAN_STDDEV") { inputData = normalize(inputData) }
		else if(networks[network, 4] == "MAX_MIN") { inputData = normalize2(inputData) }
		
		if(networks[network, 5] == "TANH") { inputData = scaleTANH(inputData) }
		
		results = compute(net, inputData)
		results = results$net.result
		PredictedResults = results
		
		output = cbind(nnid, dataSet[,1:2], PredictedResults)
		sqlSave(racingConn, output, tablename = "PREDICTEDRESULTS", append = TRUE)
	}
	
	close(racingConn)

}

BatchTrainPlacing <-function()
{
	fileRoot = "C:/Projects/Racing/Networks/Testing/"
	
	queries = dim(1)
	queries[1] = "[D_1_M],[D_2_M],[D_3_M],[D_1_6M],[D_2_6M],[D_3_6M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_A],[D_P_M],[D_PT_A],[D_PB_A],[D_PWC_A],[D_PTC_A],[D_1MBREAK],[D_6MBREAK],[AD_AVGPP_M],[AD_AVGPP_A],[AD_AVGFP_M],[AD_AVGFP_A]"
	
	errors = dim(1)
	errors[1] = 0.005
	errors[2] = 0.001
	
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
