## Upload raw data to TAF database

## Before: PLE7DFleet_2016.txt, stockobject.RData (user dir)
## After:  PLE7DFleet_2016.txt, stockobject.RData (TAF database)

library(icesTAF)

owd <- setwd("d:/projects/ices-taf/ftp/wgnssk/2016/ple-eche/raw")
upload("2016_ple-eche", "raw", "stockobject.RData")
upload("2016_ple-eche", "raw", "PLE7DFleet_2016.txt")
setwd(owd)
