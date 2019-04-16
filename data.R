## Preprocess data, write TAF data tables

## Before: PLE7DFleet_2016.txt, stockobject.RData (bootstrap/data)
## After:  assess.dat, datage.csv, input.RData, latage.csv, survey_fr.csv,
##         survey_uk.csv, wdiscards.csv, wlandings.csv, wstock.csv (data)

library(icesTAF)
suppressMessages(library(FLAssess))
library(splines)
suppressMessages(library(mgcv))
library(methods)
source("utilities.R")

mkdir("data")

## Get stock data
load("bootstrap/data/stockobject.RData")
range(stock)["minfbar"] <- 3
range(stock)["maxfbar"] <- 6
stock <- trim(stock, age=1:10)
stock@catch.n <- stock@landings.n  # temporary, to setPlusGroup weights
stock <- setPlusGroup(stock, 7)

## Get survey data
indices <- readFLIndices("bootstrap/data/PLE7DFleet_2016.txt", na.strings="-1")
indices <- FLIndices(indices[[1]], trim(indices[[2]], age=1:6))

## Extract tables
latage <- flr2taf(stock@landings.n)
wlandings <- flr2taf(stock@landings.wt); wlandings[wlandings==0] <- NA
datage <- flr2taf(stock@discards.n)
wdiscards <- flr2taf(stock@discards.wt); wdiscards[wdiscards==0] <- NA
wstock <- flr2taf(stock@stock.wt); wstock[wstock==0] <- NA
survey.uk <- flr2taf(indices[[1]]@index)
survey.fr <- flr2taf(indices[[2]]@index)

## Rename plus group
latage <- plus(latage)
wlandings <- plus(wlandings)
datage <- plus(datage)
wdiscards <- plus(wdiscards)
wstock <- plus(wstock)

## Write tables to data directory
setwd("data")
write.taf(latage)     # 2.3.1
write.taf(wlandings)  # 2.3.2
write.taf(datage)     # 2.3.3
write.taf(wdiscards)  # 2.3.4
write.taf(wstock)     # 2.3.5
write.taf(survey.uk)  # 2.6.1a
write.taf(survey.fr)  # 2.6.1b
setwd("..")

## Write model input files
control <- FLAAP.control(pGrp=1, qplat.surveys=5, qplat.Fmatrix=6, Fage.knots=4,
                         Ftime.knots=14, Wtime.knots=5, mcmc=FALSE)
path <- "data"  # required inside assessment() function
suppressWarnings(assessment(stock, indices, control, input=TRUE, model=FALSE))
save(control, indices, stock, file="data/input.RData")
