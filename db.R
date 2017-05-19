## Download and preprocess data, write TAF input tables

## Before: stockobject.Rdata (ftp)
## After:  latage.csv, wcatch.csv, datage.csv, wdiscards.csv, wstock.csv,
##         survey_uk.csv, survey_fr.csv (db)

suppressMessages(require(FLCore, quietly=TRUE))
require(methods, quietly=TRUE)
require(icesTAF, quietly=TRUE)

ftp <- "https://raw.githubusercontent.com/ices-taf/ftp/master/wgnssk/2016/ple-eche/"

mkdir("db")

## Get stock data
download.file(paste0(ftp,"db/stockobject.Rdata"), "db/stockobject.Rdata", quiet=TRUE)
load("db/stockobject.Rdata")
range(stock)["minfbar"] <- 3
range(stock)["maxfbar"] <- 6
stock <- trim(stock, age=1:10)
stock@catch.n <- stock@landings.n  # temporary, to setPlusGroup weights
stock <- setPlusGroup(stock, 7)

## Get survey data
download.file(paste0(ftp,"db/PLE7DFleet_2016.txt"), "db/PLE7DFleet_2016.txt", quiet=TRUE)
indices <- readFLIndices("db/PLE7DFleet_2016.txt", na.strings="-1")
indices[[2]] <- trim(indices[[2]], age=1:6)

## Extract tables
landings.n <- flr2taf(stock@landings.n)
landings.wt <- flr2taf(stock@landings.wt); landings.wt[landings.wt==0] <- NA
discards.n <- flr2taf(stock@discards.n)
discards.wt <- flr2taf(stock@discards.wt); discards.wt[discards.wt==0] <- NA
stock.wt <- flr2taf(stock@stock.wt); stock.wt[stock.wt==0] <- NA
survey.uk <- flr2taf(indices[[1]]@index)
survey.fr <- flr2taf(indices[[2]]@index)

## Write TAF tables to db directory
write.taf(landings.n, "db/latage.csv")
write.taf(landings.wt, "db/wcatch.csv")
write.taf(discards.n, "db/datage.csv")
write.taf(discards.wt, "db/wdiscards.csv")
write.taf(stock.wt, "db/wstock.csv")
write.taf(survey.uk, "db/survey_uk.csv")
write.taf(survey.fr, "db/survey_fr.csv")
