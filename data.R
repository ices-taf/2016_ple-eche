## Preprocess data, write TAF data tables

## Before: PLE7DFleet_2016.txt, stockobject.Rdata (TAF database)
## After:  datage.csv, latage.csv, PLE7DFleet_2016.txt, stockobject.Rdata,
##         survey_fr.csv, survey_uk.csv, wdiscards.csv, wlandings.csv,
##         wstock.csv (data)

suppressMessages(library(FLCore))
library(methods)
library(icesTAF)

url <- "https://raw.githubusercontent.com/ices-taf/ftp/master/wgnssk/2016/ple-eche/raw/"

mkdir("data")

## Get stock data
setwd("data")
download(paste0(url,"stockobject.Rdata"))  # later removed by input.R
load("stockobject.Rdata")
range(stock)["minfbar"] <- 3
range(stock)["maxfbar"] <- 6
stock <- trim(stock, age=1:10)
stock@catch.n <- stock@landings.n  # temporary, to setPlusGroup weights
stock <- setPlusGroup(stock, 7)

## Get survey data
download(paste0(url,"PLE7DFleet_2016.txt"))  # later removed by input.R
indices <- readFLIndices("PLE7DFleet_2016.txt", na.strings="-1")
indices[[2]] <- trim(indices[[2]], age=1:6)

## Extract tables
landings.n <- flr2taf(stock@landings.n)
landings.wt <- flr2taf(stock@landings.wt); landings.wt[landings.wt==0] <- NA
discards.n <- flr2taf(stock@discards.n)
discards.wt <- flr2taf(stock@discards.wt); discards.wt[discards.wt==0] <- NA
stock.wt <- flr2taf(stock@stock.wt); stock.wt[stock.wt==0] <- NA
survey.uk <- flr2taf(indices[[1]]@index)
survey.fr <- flr2taf(indices[[2]]@index)

## Rename plus group
names(landings.n)[names(landings.n)=="7"] <- "7+"
names(landings.wt)[names(landings.wt)=="7"] <- "7+"
names(discards.n)[names(discards.n)=="7"] <- "7+"
names(discards.wt)[names(discards.wt)=="7"] <- "7+"
names(stock.wt)[names(stock.wt)=="7"] <- "7+"

## Write tables to data directory
write.taf(landings.n, "latage.csv")     # 2.3.1
write.taf(landings.wt, "wlandings.csv") # 2.3.2
write.taf(discards.n, "datage.csv")     # 2.3.3
write.taf(discards.wt, "wdiscards.csv") # 2.3.4
write.taf(stock.wt, "wstock.csv")       # 2.3.5
write.taf(survey.uk, "survey_uk.csv")   # 2.6.1a
write.taf(survey.fr, "survey_fr.csv")   # 2.6.1b
setwd("..")
