## Convert data to model format, write model input files

## Before: stockobject.Rdata, PLE7DFleet_2016.txt (db)
## After:  assess.dat, input.RData (input)

library(icesTAF)
suppressMessages(library(FLAssess))
library(splines)
suppressMessages(library(mgcv))
library(methods)

source("utilities.R")

mkdir("input")

## Get stock data
load("db/stockobject.Rdata")
range(stock)["minfbar"] <- 3
range(stock)["maxfbar"] <- 6
stock <- trim(stock, age=1:10)
stock@catch.n <- stock@landings.n  # temporary, to setPlusGroup weights
stock <- setPlusGroup(stock, 7)

## Get survey data
indices <- readFLIndices("db/PLE7DFleet_2016.txt", na.strings="-1")
indices <- FLIndices(indices[[1]], trim(indices[[2]], age=1:6))

## Write model input files
control <- FLAAP.control(pGrp=1, qplat.surveys=5, qplat.Fmatrix=6,
                         Fage.knots=4, Ftime.knots=14, Wtime.knots=5, mcmc=FALSE)
path <- "input"
suppressWarnings(assessment(stock, indices, control, input=TRUE, model=FALSE))
save(stock, indices, control, file="input/input.RData")
