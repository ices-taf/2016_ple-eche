## Run analysis, write model results

## Before: sole (TAF database), assess.dat, input.RData (input)
## After:  input.RData, results.RData, sole.rep, sole.std (model)

library(icesTAF)
suppressMessages(library(FLAssess))
library(splines)
suppressMessages(library(mgcv))
library(methods)
source("utilities.R")

url <- "https://raw.githubusercontent.com/ices-taf/ftp/master/wgnssk/2016/ple-eche/model/"

mkdir("model")

## Get model executable
sole <- if(.Platform$OS.type == "unix") "sole" else "sole.exe"
download(paste0(url,sole), "model")

## Get model input files
cp("input/assess.dat", "model") # required by executable
load("input/input.RData")
cp("input/input.RData", "model") # required by output.R

## Run model
path <- "model"  # required inside assessment() function
suppressWarnings(results <-
                   assessment(stock, indices, control, input=FALSE, model=TRUE))
save(results, file="model/results.RData")
