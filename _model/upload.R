## Upload model executables to TAF database

## Before: sole, sole.exe (user dir)
## After:  sole, sole.exe (TAF database)

library(icesTAF)

owd <- setwd("d:/projects/ices-taf/ftp/wgnssk/2016/ple-eche/model")
upload("2016_ple-eche", "model", "sole.exe")
upload("2016_ple-eche", "model", "sole")
setwd(owd)
