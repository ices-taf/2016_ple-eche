## Run analysis, write model results

## Before: sole (bootstrap/software), assess.dat, input.RData (data)
## After:  input.RData, results.RData, sole.rep, sole.std (model)

library(icesTAF)
suppressMessages(library(FLAssess))
library(splines)
suppressMessages(library(mgcv))
library(methods)
source("utilities.R")

mkdir("model")

## Get model executable
exefile <- if(os.linux()) "sole" else "sole.exe"
cp(file.path("bootstrap/software/sole", exefile), "model")

## Get model input files
cp("data/assess.dat", "model")  # required by executable
load("data/input.RData")

## Run model
path <- "model"  # required inside assessment() function
suppressWarnings(results <-
                   assessment(stock, indices, control, input=FALSE, model=TRUE))
save(results, file="model/results.RData")
