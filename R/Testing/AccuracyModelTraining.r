library(RODBC)
library(nnet)
library(neuralnet)

TrainPlaceAccuracyModel <- function()
{
	racingConn = odbcConnect("racingTest")
	queries = "SELECT [P_PREDDIFF_1_5], [R_DOGCOUNT], [D_1COUNT_A], [P_MINPRED], [P_STDDEV], [D_3COUNT_M_D], [D_RESTCOUNT_A_D], [PLACECORRECT] FROM [dbo].[ACCURACYTRAINDATA] WHERE DATATYPE = 'TRAINING' AND NNID = 'Q_2_E_0.01_5000_8_N_3' ORDER BY newID()"
	tableData = sqlQuery(racingConn, queries)
	close(racingConn)

	trainingData = tableData[,1:ncol(tableData)]
	vars = colnames(trainingData[,1:ncol(trainingData)-1])
	formula <- as.formula(paste("PLACECORRECT ~ ", paste(vars, collapse= "+")))

	net = neuralnet(formula, trainingData, hidden = c(5), threshold = 0.01, stepmax = 2000000 , lifesign = "full", lifesign.step = 1000)

	
	return(net)
}


TestAccuracyModel <- function(net)
{
	racingConn = odbcConnect("racingTest")
	queries = "SELECT [P_PREDDIFF_1_5], [R_DOGCOUNT], [D_1COUNT_A], [P_MINPRED], [P_STDDEV], [D_3COUNT_M_D], [D_RESTCOUNT_A_D], [PLACECORRECT] FROM [dbo].[ACCURACYTRAINDATA] WHERE DATATYPE = 'TESTING' AND NNID = 'Q_2_E_0.01_5000_8_N_3' ORDER BY newID()"
	tableData = sqlQuery(racingConn, queries)
	close(racingConn)
	
	inputs = tableData[,1:ncol(tableData)-1]
	
	testResults = compute(net, inputs)
	results = testResults$net.result
	normResults = (results - min(results)) / ( max(results) - min(results) )

	roundTable = round(normResults)
	roundTable = cbind(roundTable, tableData[,ncol(tableData)])
	correct = roundTable[,1] == roundTable[,2]
	roundTable = cbind(roundTable, correct)
	
	roundingCorrect = sum(roundTable[,3]) / nrow(results)
	predictedAs1 = subset(roundTable, roundTable[,1] == 1)
	predictedAs1Correct = (predictedAs1[,1] == 1 & predictedAs1[,2] == 1)
	predictedAs1Correct = table(predictedAs1Correct)
	predictedAs1CorrectP = predictedAs1Correct[2] / (predictedAs1Correct[1] + predictedAs1Correct[2])
	
	print("-----------------")
	print("Rounding at 0.5")
	print("Count:")
	print(sum(roundTable[,1]))
	print("Correct:")
	print(roundingCorrect)
	print("Correct when predicting correct:")
	print(predictedAs1CorrectP)
	print("-----------------")
	
	roundPointEight = normResults
	roundPointEight[roundPointEight >= 0.3] = 1
	roundPointEight[roundPointEight < 0.3] = 0
	
	roundTable = cbind(roundPointEight, tableData[,ncol(tableData)])
	correct = roundTable[,1] == roundTable[,2]
	roundTable = cbind(roundTable, correct)
	
	roundingCorrect = sum(roundTable[,3]) / nrow(results)
	predictedAs1 = subset(roundTable, roundTable[,1] == 1)
	predictedAs1Correct = (predictedAs1[,1] == 1 & predictedAs1[,2] == 1)
	predictedAs1Correct = table(predictedAs1Correct)
	predictedAs1CorrectP = predictedAs1Correct[2] / (predictedAs1Correct[1] + predictedAs1Correct[2])
	
	print("-----------------")
	print("Rounding at 0.3")
	print("Count:")
	print(sum(roundTable[,1]))
	print("Correct:")
	print(roundingCorrect)
	print("Correct when predicting correct:")
	print(predictedAs1CorrectP)
	print("-----------------")


}