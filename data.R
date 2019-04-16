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
landings.n <- flr2taf(stock@landings.n)
landings.wt <- flr2taf(stock@landings.wt); landings.wt[landings.wt==0] <- NA
discards.n <- flr2taf(stock@discards.n)
discards.wt <- flr2taf(stock@discards.wt); discards.wt[discards.wt==0] <- NA
stock.wt <- flr2taf(stock@stock.wt); stock.wt[stock.wt==0] <- NA
survey.uk <- flr2taf(indices[[1]]@index)
survey.fr <- flr2taf(indices[[2]]@index)

## Rename plus group
landings.n <- plus(landings.n)
landings.wt <- plus(landings.wt)
discards.n <- plus(discards.n)
discards.wt <- plus(discards.wt)
stock.wt <- plus(stock.wt)

## Write tables to data directory
setwd("data")
write.taf(landings.n, "latage.csv")      # 2.3.1
write.taf(landings.wt, "wlandings.csv")  # 2.3.2
write.taf(discards.n, "datage.csv")      # 2.3.3
write.taf(discards.wt, "wdiscards.csv")  # 2.3.4
write.taf(stock.wt, "wstock.csv")        # 2.3.5
write.taf(survey.uk, "survey_uk.csv")    # 2.6.1a
write.taf(survey.fr, "survey_fr.csv")    # 2.6.1b
setwd("..")

## Write model input files
control <- FLAAP.control(pGrp=1, qplat.surveys=5, qplat.Fmatrix=6, Fage.knots=4,
                         Ftime.knots=14, Wtime.knots=5, mcmc=FALSE)
path <- "data"  # required inside assessment() function
suppressWarnings(assessment(stock, indices, control, input=TRUE, model=FALSE))
save(control, indices, stock, file="data/input.RData")
