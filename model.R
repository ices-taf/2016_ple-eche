## Run FLAAP model

## Before: sole(.exe), assess.dat, input.RData
## After:  results.RData, sole.rep, sole.std

suppressMessages(require(FLAssess, quietly=TRUE))
require(splines, quietly=TRUE)
suppressMessages(require(mgcv, quietly=TRUE))
require(methods, quietly=TRUE)

source("utilities.R")

ftp <- "https://raw.githubusercontent.com/ices-taf/ftp/master/wgnssk/2016/ple-eche/"

dir.create("model", showWarnings=FALSE)

## Get model executable
sole <- if(.Platform$OS.type == "unix") "sole" else "sole.exe"
download.file(paste0(ftp,"/model/",sole), paste0("model/",sole), quiet=TRUE)
Sys.chmod(paste0("model/", sole))

## Get model input files
invisible(file.copy("input/assess.dat", "model"))
load("input/input.RData")

## Run model
path <- "model"
suppressWarnings(results <- assessment(stock, indices, control, input=FALSE, model=TRUE))
save(results, file="model/results.RData")
