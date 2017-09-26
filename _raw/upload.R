## Upload raw data to TAF database

## Before: catageysa.dat (user dir)
## After:  catageysa.dat (TAF database)

library(icesTAF)

owd <- setwd("d:/projects/ices-taf/ftp/wgnssk/2016/ple-eche/raw")
upload("2016_ple-eche", "raw", "stockobject.Rdata")
upload("2016_ple-eche", "raw", "PLE7DFleet_2016.txt")
setwd(owd)
