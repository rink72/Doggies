library(RODBC)
library(nnet)
library(neuralnet)


PredictFutureResults <- function()
{
	racingConn = odbcConnect("racingtest")
	nnID1 = "Q_1_E_0.01_5000_N_13"
	nnID2 = "Q_1_E_0.025_5000_N_13"
	nnID3 = "Q_3_E_0.01_5000_N_13"
	nnID4 = "Q_3_E_0.025_5000_N_13"
	nnID5 = "Q_4_E_0.01_5000_N_13"
	query1 = "SELECT [RACEID],[DOGID],[D_1_M],[D_2_M],[D_3_M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_A],[D_P_M],[D_PT_A],[D_PB_A],[D_R_M],[D_PWC_A],[D_PTC_A] FROM [dbo].[FUTUREDATA] ORDER BY newID()"
	query2 = "SELECT [RACEID],[DOGID],[D_1_M],[D_2_M],[D_3_M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_A],[D_P_M],[D_PB_A],[D_R_M],[D_PWC_A],[D_PTC_A] FROM [dbo].[FUTUREDATA] ORDER BY newID()"
	query3 = "SELECT [RACEID],[DOGID],[D_1_M],[D_2_M],[D_3_M],[D_1D_A],[D_2D_A],[D_3D_A],[D_P_M],[D_PB_A],[D_R_M],[D_PWC_A],[D_PTC_A] FROM [dbo].[FUTUREDATA]ORDER BY newID()"
	Model1 = "SELECT nnfilename FROM NETWORKDETAILS WHERE id = 'Q_1_E_0.01_5000_N_13'"
	Model2 = "SELECT nnfilename FROM NETWORKDETAILS WHERE id = 'Q_1_E_0.025_5000_N_13'"
	Model3 = "SELECT nnfilename FROM NETWORKDETAILS WHERE id = 'Q_3_E_0.01_5000_N_13'"
	Model4 = "SELECT nnfilename FROM NETWORKDETAILS WHERE id = 'Q_3_E_0.025_5000_N_13'"
	Model5 = "SELECT nnfilename FROM NETWORKDETAILS WHERE id = 'Q_4_E_0.01_5000_N_13'"
	
	
	query1Data = sqlQuery(racingConn, query1)
	query2Data = sqlQuery(racingConn, query2)
	query3Data = sqlQuery(racingConn, query3)
	net1File = sqlQuery(racingConn, Model1)
	net2File = sqlQuery(racingConn, Model2)
	net3File = sqlQuery(racingConn, Model3)
	net4File = sqlQuery(racingConn, Model4)
	net5File = sqlQuery(racingConn, Model5)
	
	nnfile1 = data.frame(net1File)
	nnfile1 = data.frame(lapply(nnfile1, as.character), stringsAsFactors=FALSE)
	nnfile1 = as.character(nnfile1)
	nnfile2 = data.frame(net2File)
	nnfile2 = data.frame(lapply(nnfile2, as.character), stringsAsFactors=FALSE)
	nnfile2 = as.character(nnfile2)
	nnfile3 = data.frame(net3File)
	nnfile3 = data.frame(lapply(nnfile3, as.character), stringsAsFactors=FALSE)
	nnfile3 = as.character(nnfile3)
	nnfile4 = data.frame(net4File)
	nnfile4 = data.frame(lapply(nnfile4, as.character), stringsAsFactors=FALSE)
	nnfile4 = as.character(nnfile4)
	nnfile5 = data.frame(net5File)
	nnfile5 = data.frame(lapply(nnfile5, as.character), stringsAsFactors=FALSE)
	nnfile5 = as.character(nnfile5)
	
	
	load(nnfile1)
	inputData = query1Data[,3:(ncol(query1Data))]
	results = compute(net, inputData)
	results = results$net.result
	PredictedResults = results
	nnID = nnID1
	output = cbind(query1Data[,1:2], nnID, PredictedResults)
	sqlSave(racingConn, output, tablename = "FUTUREPREDICTIONS", append = TRUE)
	
	load(nnfile2)
	inputData = query1Data[,3:(ncol(query1Data))]
	results = compute(net, inputData)
	results = results$net.result
	PredictedResults = results
	nnID = nnID2
	output = cbind(query1Data[,1:2], nnID, PredictedResults)
	sqlSave(racingConn, output, tablename = "FUTUREPREDICTIONS", append = TRUE)
	
	load(nnfile3)
	inputData = query2Data[,3:(ncol(query2Data))]
	results = compute(net, inputData)
	results = results$net.result
	PredictedResults = results
	nnID = nnID3
	output = cbind(query2Data[,1:2], nnID, PredictedResults)
	sqlSave(racingConn, output, tablename = "FUTUREPREDICTIONS", append = TRUE)	
	
	load(nnfile4)
	inputData = query2Data[,3:(ncol(query2Data))]
	results = compute(net, inputData)
	results = results$net.result
	PredictedResults = results
	nnID = nnID4
	output = cbind(query2Data[,1:2], nnID, PredictedResults)
	sqlSave(racingConn, output, tablename = "FUTUREPREDICTIONS", append = TRUE)	
	
	
	load(nnfile5)
	inputData = query3Data[,3:(ncol(query3Data))]
	results = compute(net, inputData)
	results = results$net.result
	PredictedResults = results
	nnID = nnID5
	output = cbind(query3Data[,1:2], nnID, PredictedResults)
	sqlSave(racingConn, output, tablename = "FUTUREPREDICTIONS", append = TRUE)	
	

	close(racingConn)
}


PredictFutureResults()