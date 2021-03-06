library(RODBC)
library(nnet)
library(neuralnet)

scaleTANH <- function(nnid, x) { 
	
	cNames = colnames(x)
	racingConn = odbcConnect("racingTest")
	
	for(c in 1:ncol(x))
	{
		cMax = max(x[,c])
		cMax = as.numeric(cMax)
		cMin = min(x[,c])
		cMin = as.numeric(cMin)
		
		x[,c] = (x[,c] - cMin) / (cMax - cMin)
		x[,c] = (2* x[,c]) - 1
	
		fMaxQuery = paste("EXEC SetFeature @NNID = '", nnid, "', @FEATURE = '", cNames[c], "', @DESCRIPTION = 'MAX', @VALUE = ", cMax, sep = "")
		fMinQuery = paste("EXEC SetFeature @NNID = '", nnid, "', @FEATURE = '", cNames[c], "', @DESCRIPTION = 'MIN', @VALUE = ", cMin, sep = "")
		sqlQuery(racingConn, fMaxQuery)
		sqlQuery(racingConn, fMinQuery)
	}
	
	return(x)
}


normalize <- function(nnid, x) { 
    
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
		
		fMeanQuery = paste("EXEC SetFeature @NNID = '", nnid, "', @FEATURE = '", cNames[c], "', @DESCRIPTION = 'MEAN', @VALUE = ", cMean, sep = "")
		fStdDevQuery = paste("EXEC SetFeature @NNID = '", nnid, "', @FEATURE = '", cNames[c], "', @DESCRIPTION = 'STDDEV', @VALUE = ", cStdDev, sep = "")
		sqlQuery(racingConn, fMeanQuery)
		sqlQuery(racingConn, fStdDevQuery)
	}
	
	return(x)
}

scaleTANH2 <- function(nnid, x) { 
	
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


normalize2 <- function(nnid, x) { 
    
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


cleanData <- function(x)
{
	cNames = colnames(x)
	for(c in 1:ncol(x))
	{
		cNames[,is.na(cNames[,c])] = -1
	}
	
	return(x)
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
	#neurons[1] = 2
	neurons[1] = 4
	neurons[2] = 8
	#neurons$four = 10
	neurons[3] = 15
	
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
	#scales[1] = "NO"
	scales[1] = "TANH"
	
	normalise = dim(1)
	#normalise[1] = "NO"
	#normalise[2] = "MAX_MIN"
	normalise[1] = "MEAN_STDDEV"
	
	racingConn = odbcConnect("racingTest")
	trackMonthQuery = "select TRACKID, month(starttime) as MONTH from races group by trackid, month(starttime) having count(*) > 100 ORDER BY trackid, month(starttime)"
	trackMonth = sqlQuery(racingConn, trackMonthQuery)
	tracks = unique(trackMonth[,1])
	trackMonth = as.data.frame(trackMonth)
	
	iterationQuery = "SELECT CONFIGVALUE FROM CONFIG WHERE CONFIGITEM = 'TRAININGITERATION'"
	iteration = sqlQuery(racingConn, iterationQuery)
	iteration = iteration[,1] + 1
	
	for (iter in iteration:(iteration))
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
									for(t in tracks)
									{
										months = trackMonth[trackMonth$TRACKID == t,]
										months = months[,2]
										for(m in months)
										{
											print(paste("Query", query, iter, errors[error], neurons[n], algs[alg], actFunc[act], scales[sc], normalise[norms], t, m, sep="_"))
											
											finalQuery = paste("SELECT RACEID, DOGID,", queries[query], ", RESULT FROM TRAININGDATA WHERE DATATYPE = 'TRAINING' AND RACEID IN (SELECT RACEID FROM RACES WHERE TRACKID =", t, "AND MONTH(STARTTIME) =", m,") ORDER BY newid()", sep = " ")
											print(finalQuery)
											queryData = sqlQuery(racingConn, finalQuery)
											queryData = queryData[,3:ncol(queryData)]
											queryData = queryData[sample(nrow(queryData)),]
											queryData$RESULT[queryData$RESULT > 4] = 10
											
											NNID = paste("Q", query, "E", errors[error], nrow(queryData), iter, "N", neurons[n], algs[alg], actFunc[act], normalise[norms], scales[sc], t, m, sep="_")
											
											if(normalise[norms] == "MEAN_STDDEV") { queryData = normalize(NNID, queryData) }
											else if (normalise[norms] == "MAX_MIN") { queryData = normalize2(queryData) }
											if(scales[sc] == "TANH") { queryData = scaleTANH(NNID, queryData) }
											
											queryData = data.matrix(queryData)
											
											vars = colnames(queryData[,1:(ncol(queryData)-1)])
											formula = as.formula(paste("RESULT ~ ", paste(vars, collapse= "+")))
											
											net = as.null()
											
											if(algs[alg] == "backprop")
											{ net = neuralnet(formula, queryData, hidden = c(neurons[n]), threshold = errors[error], stepmax = 5000000, lifesign = "full", lifesign.step = 10000, act.fct = actFunc[act]) }
											else { net = neuralnet(formula, queryData, hidden = c(neurons[n]), threshold = errors[error], stepmax = 5000000, lifesign = "full", lifesign.step = 10000, act.fct = actFunc[act], algorithm = algs[alg]) }
											
											if(!is.null(net$net))
											{
												netDetails = matrix(nrow=1,ncol=13)
												colnames(netDetails) = c("query", "error", "traininglines", "neurons", "nnfilename", "id", "PredictionType", "ActivationFunction", "NNAlgorithm", "Normalised", "Scaled", "Track", "Month")
												netDetails[1,1] = queries[query]
												netDetails[1,2] = errors[error]
												netDetails[1,3] = nrow(queryData)
												netDetails[1,4] = neurons[n]
												fileName = paste(fileRoot, "Q", query, "E", errors[error], nrow(queryData), iter, "N", neurons[n], algs[alg], actFunc[act], normalise[norms], scales[sc], t, m, ".r", sep="_")
												netDetails[1,5] = fileName
												netDetails[1,6] = NNID
												netDetails[1,7] = "ORDER"
												netDetails[1,8] = actFunc[act]
												netDetails[1,9] = algs[alg]
												netDetails[1,10] = normalise[norms]
												netDetails[1,11] = scales[sc]
												netDetails[1,12] = t
												netDetails[1,13] = m
												
												netDetails = as.data.frame(netDetails)
												
												net$data = NULL
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
				
		}
				
	}
	
	close(racingConn)
	return(netDetails)
		
}
	

	




BatchPredict <- function()
{
	
	racingConn = odbcConnect("racingTest")
	networkQuery = "SELECT id, nnfilename, query, Normalised, Scaled, Track, Month from NETWORKDETAILS WHERE ID NOT IN (SELECT DISTINCT NNID FROM PREDICTEDRESULTS) AND TRACK IS NOT NULL"
	networks = sqlQuery(racingConn, networkQuery)
	print(networks)
	
	count = 0
	
	pb = winProgressBar(title = "Batch Predictions", min = 0, max = nrow(networks), width = 300)
	for(network in 1:nrow(networks))
	{
		count = count + 1
		percent = round((count/nrow(networks))*100,0)
		setWinProgressBar(pb, count, title=paste( percent, "% done"))
		nnid = data.frame(networks[network, 1])
		nnfilename = data.frame(networks[network, 2])
		nnid = data.frame(lapply(nnid, as.character), stringsAsFactors=FALSE)
		nnfilename = data.frame(lapply(nnfilename, as.character), stringsAsFactors=FALSE)
		nnfilename = as.character(nnfilename)
		query = data.frame(networks[network, 3])
		query = data.frame(lapply(query, as.character), stringsAsFactors=FALSE)
		load(nnfilename)
		colnames(nnid) = c("nnid")
		trackID = networks[network, 6]
		month = networks[network, 7]

		print(nnid)
		query = paste("SELECT RACEID, DOGID,", query, "FROM TRAININGDATA WHERE DATATYPE = 'TESTING'", "AND RACEID IN (SELECT RACEID FROM RACES WHERE TRACKID =", trackID,"AND MONTH(STARTTIME) =", month, ") ORDER BY newID()", sep = " ")
		dataSet = sqlQuery(racingConn, query)
		dataSet = dataSet[sample(nrow(dataSet)),]
		inputData = dataSet[,3:ncol(dataSet)]
		if(networks[network, 4] == "MEAN_STDDEV") { inputData = normalize2(nnid, inputData) }
		
		if(networks[network, 5] == "TANH") { inputData = scaleTANH2(nnid, inputData) }
		
		results = compute(net, inputData)
		results = results$net.result
		PredictedResults = results
		
		output = cbind(nnid, dataSet[,1:2], PredictedResults)
		sqlSave(racingConn, output, tablename = "PREDICTEDRESULTS", append = TRUE)
	}
	
	close(pb)
	close(racingConn)

}