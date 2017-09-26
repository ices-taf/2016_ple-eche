## Preprocess data, write TAF input tables

## Before: stockobject.Rdata (TAF database)
## After:  latage.csv, wlandings.csv, datage.csv, wdiscards.csv, wstock.csv,
##         survey_uk.csv, survey_fr.csv (data)

suppressMessages(library(FLCore))
library(methods)
library(icesTAF)

url <- "https://raw.githubusercontent.com/ices-taf/ftp/master/wgnssk/2016/ple-eche/raw/"

mkdir("data")

## Get stock data
download(paste0(url,"stockobject.Rdata"), "data")
load("data/stockobject.Rdata")
range(stock)["minfbar"] <- 3
range(stock)["maxfbar"] <- 6
stock <- trim(stock, age=1:10)
stock@catch.n <- stock@landings.n  # temporary, to setPlusGroup weights
stock <- setPlusGroup(stock, 7)

## Get survey data
download(paste0(url,"PLE7DFleet_2016.txt"), "data")
indices <- readFLIndices("data/PLE7DFleet_2016.txt", na.strings="-1")
indices[[2]] <- trim(indices[[2]], age=1:6)

## Extract tables
landings.n <- flr2taf(stock@landings.n)
landings.wt <- flr2taf(stock@landings.wt); landings.wt[landings.wt==0] <- NA
discards.n <- flr2taf(stock@discards.n)
discards.wt <- flr2taf(stock@discards.wt); discards.wt[discards.wt==0] <- NA
stock.wt <- flr2taf(stock@stock.wt); stock.wt[stock.wt==0] <- NA
survey.uk <- flr2taf(indices[[1]]@index)
survey.fr <- flr2taf(indices[[2]]@index)

## Write tables to data directory
write.taf(landings.n, "data/latage.csv")     # 2.3.1
write.taf(landings.wt, "data/wlandings.csv") # 2.3.2
write.taf(discards.n, "data/datage.csv")     # 2.3.3
write.taf(discards.wt, "data/wdiscards.csv") # 2.3.4
write.taf(stock.wt, "data/wstock.csv")       # 2.3.5
write.taf(survey.uk, "data/survey_uk.csv")   # 2.6.1a
write.taf(survey.fr, "data/survey_fr.csv")   # 2.6.1b
