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

IdentifyBestVars <- function()
{
	query = "SELECT * FROM TRAININGDATA WHERE DATATYPE = 'TRAINING'"
	racingConn = odbcConnect("racingTest")
	trainingData = sqlQuery(racingConn, query)
	
	inputData = trainingData[,3:(ncol(trainingData)-1)]
	inputData = normalize(inputData)
	vars = colnames(inputData[,1:ncol(inputData)-1])
	formula <- as.formula(paste("RESULT ~ ", paste(vars, collapse= "+")))
	
	null = lm(RESULT~1, data = inputData)
	full = lm(RESULT~., data = inputData)
	
	fStep = step(null,scope=list(lower=null,upper=full), direction = "forward", steps = 100000000, trace = 0)
	bStep = step(null,scope=list(lower=null,upper=full), direction = "backward", steps = 100000000, trace = 0)
	bothStep = step(null,scope=list(lower=null,upper=full), direction = "both", steps = 100000000, trace = 0)
	
	
	result = list()
	result$fStep = fStep
	result$bStep = bStep
	result$bothStep = bothStep
	
	return(result)

}

PCA <- function()
{
	query = "SELECT * FROM TRAININGDATA WHERE DATATYPE = 'TRAINING'"
	racingConn = odbcConnect("racingTest")
	trainingData = sqlQuery(racingConn, query)
	
	data = trainingData[,-1]
	data = data[,-1]
	data = data[,-15]
	data = data[,-14]
	
	data[,11] = (data[,11] - min(data[,11])) / (max(data[,11]) - min(data[,11]))	
	model = princomp(data)
	
	print(summary(model))
	print(model$loadings)
	
	return(model)
	
	
	
}