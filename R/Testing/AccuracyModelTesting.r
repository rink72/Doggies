IdentifyAccuracyVars <- function()
{
	query = "SELECT * FROM ACCURACYTRAINDATA WHERE DATATYPE = 'TRAINING' AND NNID = 'Q_1_E_0.01_5000_7_N_3'"
	racingConn = odbcConnect("racingTest")
	trainingData = sqlQuery(racingConn, query)
	
	inputData = trainingData[,3:(ncol(trainingData)-1)]
	inputData = inputData[,-27]
	vars = colnames(inputData[,1:ncol(inputData)-1])
	formula <- as.formula(paste("PLACECORRECT ~ ", paste(vars, collapse= "+")))
	
	null = lm(PLACECORRECT~1, data = inputData)
	full = lm(PLACECORRECT~., data = inputData)
	
	fStep = step(null,scope=list(lower=null,upper=full), direction = "forward", steps = 100000000, trace = 0)
	bStep = step(null,scope=list(lower=null,upper=full), direction = "backward", steps = 100000000, trace = 0)
	bothStep = step(null,scope=list(lower=null,upper=full), direction = "both", steps = 100000000, trace = 0)
	
	
	result = list()
	result$fStep = fStep
	result$bStep = bStep
	result$bothStep = bothStep
	
	return(result)



}