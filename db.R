## Extract tables of main interest from original data source

## Before: stockobject.Rdata
## After:  latage.csv, wcatch.csv, datage.csv, wdiscards.csv, wstock.csv,
##         survey_uk.csv, survey_fr.csv

suppressMessages(require(FLCore, quietly=TRUE))
require(methods, quietly=TRUE)
require(icesTAF, quietly=TRUE)

ftp.remote <- "https://raw.githubusercontent.com/ices-taf/ftp/master/wgnssk/2016/ple-eche/"
ftp.local <- "../../../ftp/wgnssk/2016/ple-eche/"

dir.create("db", showWarnings=FALSE)
dir.create(paste0(ftp.local,"input"), showWarnings=FALSE, recursive=TRUE)

## Get stock data
download.file(paste0(ftp.remote,"db/stockobject.Rdata"), "db/stockobject.Rdata", quiet=TRUE)
load("db/stockobject.Rdata")
range(stock)["minfbar"] <- 3
range(stock)["maxfbar"] <- 6
stock <- trim(stock, age=1:10)
stock@catch.n <- stock@landings.n  # temporary, to setPlusGroup weights
stock <- setPlusGroup(stock, 7)

## Get survey data
indices <- readFLIndices(paste0(ftp.remote,"db/PLE7DFleet_2016.txt"), na.strings="-1")
indices[[2]] <- trim(indices[[2]], age=1:6)

## Extract tables
landings.n <- flr2taf(stock@landings.n)
landings.wt <- flr2taf(stock@landings.wt); landings.wt[landings.wt==0] <- NA
discards.n <- flr2taf(stock@discards.n)
discards.wt <- flr2taf(stock@discards.wt); discards.wt[discards.wt==0] <- NA
stock.wt <- flr2taf(stock@stock.wt); stock.wt[stock.wt==0] <- NA
survey.uk <- flr2taf(indices[[1]]@index)
survey.fr <- flr2taf(indices[[2]]@index)

## Write tables to local FTP directory
write.csv(landings.n, paste0(ftp.local,"input/latage.csv"), quote=FALSE, row.names=FALSE)
write.csv(landings.wt, paste0(ftp.local,"input/wcatch.csv"), quote=FALSE, row.names=FALSE)
write.csv(discards.n, paste0(ftp.local,"input/datage.csv"), quote=FALSE, row.names=FALSE)
write.csv(discards.wt, paste0(ftp.local,"input/wdiscards.csv"), quote=FALSE, row.names=FALSE)
write.csv(stock.wt, paste0(ftp.local,"input/wstock.csv"), quote=FALSE, row.names=FALSE)
write.csv(survey.uk, paste0(ftp.local,"input/survey_uk.csv"), quote=FALSE, row.names=FALSE)
write.csv(survey.fr, paste0(ftp.local,"input/survey_fr.csv"), quote=FALSE, row.names=FALSE)
