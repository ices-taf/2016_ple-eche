# Preprocess data, write TAF data tables

# Before: PLE7DFleet_2016.txt, stockobject.RData (boot/data)
# After:  assess.dat, datage.csv, input.RData, latage.csv, survey_fr.csv,
#         survey_uk.csv, wdiscards.csv, wlandings.csv, wstock.csv (data)

library(icesTAF)
taf.library(FLAssess)
library(splines)
suppressMessages(library(mgcv))
library(methods)
source("utilities.R")

mkdir("data")

# Get stock data
load("boot/data/stockobject.RData")
range(stock)["minfbar"] <- 3
range(stock)["maxfbar"] <- 6
stock <- trim(stock, age=1:10)
stock@catch.n <- stock@landings.n  # temporary, to setPlusGroup weights
stock <- setPlusGroup(stock, 7)

# Get survey data
indices <- readFLIndices("boot/data/PLE7DFleet_2016.txt", na.strings="-1")
indices <- FLIndices(indices[[1]], trim(indices[[2]], age=1:6))

# Extract tables
datage <- flr2taf(stock@discards.n)
latage <- flr2taf(stock@landings.n)
survey.fr <- flr2taf(indices[[2]]@index)
survey.uk <- flr2taf(indices[[1]]@index)
wdiscards <- flr2taf(stock@discards.wt); wdiscards[wdiscards==0] <- NA
wlandings <- flr2taf(stock@landings.wt); wlandings[wlandings==0] <- NA
wstock <- flr2taf(stock@stock.wt); wstock[wstock==0] <- NA

# Rename plus group
datage <- plus(datage)
latage <- plus(latage)
wdiscards <- plus(wdiscards)
wlandings <- plus(wlandings)
wstock <- plus(wstock)

# Write tables to data directory
write.taf(datage, dir="data")
write.taf(latage, dir="data")
write.taf(survey.fr, dir="data")
write.taf(survey.uk, dir="data")
write.taf(wdiscards, dir="data")
write.taf(wlandings, dir="data")
write.taf(wstock, dir="data")

# Write model input files
control <- FLAAP.control(pGrp=1, qplat.surveys=5, qplat.Fmatrix=6, Fage.knots=4,
                         Ftime.knots=14, Wtime.knots=5, mcmc=FALSE)
path <- "data"  # required inside assessment() function
suppressWarnings(assessment(stock, indices, control, input=TRUE, model=FALSE))
save(control, indices, stock, file="data/input.RData")
