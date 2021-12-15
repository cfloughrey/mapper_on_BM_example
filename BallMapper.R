#####################################################
# BALL MAPPER
# TO USE BEFORE graph_coloring.ipynb
#####################################################

setwd("~/GitHub/mapper_on_BM_example/")

library(data.table) # to read csv faster

#source('R/BallMapper.R')
library(Rcpp)
sourceCpp('R/BallMapper.cpp')

source('R/BallMapper_utils.R')


#####################################################
#For standard, not symmetric data:
#This is the fucntion to create the standard BM
BallMapperCpp <- function( points , values , epsilon )
{
  output <- SimplifiedBallMapperCppInterface( points , values , epsilon )
  colnames(output$vertices) = c('id','size')
  return_list <- output
}#BallMapperCpp



# load the dataset
digits_X <- fread('data/digits_X.csv', sep=',', header = TRUE)
digits_X_PCA <- fread('data/digits_X_PCA3.csv', sep=',', header = TRUE)

sapply(digits_X[, 1:10], class)

# load the labels
digits_y <- fread('data/digits_y.csv', sep=',', header = TRUE)


############################
# BM with full dataset
# create a bm of radius epsilon, and color by the signature 
epsilon <- 50

print("COMPUTING BM")
start <- Sys.time()
BM <- BallMapperCpp(digits_X, digits_y$label, epsilon)
print("DONE")
print(Sys.time() - start)
print("SAVING")
# save BM to file
# WARNING to not run more than once, it will corrupt the output files
storeBallMapperGraphInFile(BM, filename = paste0("BM_graphs/digits_X/", epsilon))
print("THE END")

# plot the BM
ColorIgraphPlot(BM, seed=42)




############################
# BM with PCA data
# create a bm of radius epsilon, and color by the signature 
epsilon <- 20

print("COMPUTING BM")
start <- Sys.time()
BM_PCA <- BallMapperCpp(digits_X_PCA, digits_y$label, epsilon)
print("DONE")
print(Sys.time() - start)
print("SAVING")
# save BM to file
# WARNING to not run more than once, it will corrupt the output files
storeBallMapperGraphInFile(BM_PCA, filename = paste0("BM_graphs/digits_X_PCA/", epsilon))
print("THE END")

# plot the BM
ColorIgraphPlot(BM_PCA, seed=42)

