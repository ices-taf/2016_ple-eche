## Create model input file in 'input' working directory

## Before: stockobject.Rdata, PLE7DFleet_2016.txt
## After:  assess.dat, input.RData

suppressMessages(require(FLAssess, quietly=TRUE))
require(splines, quietly=TRUE)
suppressMessages(require(mgcv, quietly=TRUE))
require(methods, quietly=TRUE)

source("utilities.R")

ftp <- "https://raw.githubusercontent.com/ices-taf/ftp/master/wgnssk/2016/ple-eche/"

dir.create("input", showWarnings=FALSE)

## Get stock data
download.file(paste0(ftp,"db/stockobject.Rdata"), "input/stockobject.Rdata", quiet=TRUE)
load("input/stockobject.Rdata")
range(stock)["minfbar"] <- 3
range(stock)["maxfbar"] <- 6
stock <- trim(stock, age=1:10)
stock@catch.n <- stock@landings.n  # temporary, to setPlusGroup weights
stock <- setPlusGroup(stock, 7)

## Get survey data
indices <- readFLIndices(paste0(ftp,"db/PLE7DFleet_2016.txt"), na.strings="-1")
indices <- FLIndices(indices[[1]], trim(indices[[2]], age=1:6))

## Write model input files
control <- FLAAP.control(pGrp=1, qplat.surveys=5, qplat.Fmatrix=6,
                         Fage.knots=4, Ftime.knots=14, Wtime.knots=5, mcmc=FALSE)
path <- "input"
suppressWarnings(assessment(stock, indices, control, input=TRUE, model=FALSE))
save(stock, indices, control, file="input/input.RData")
