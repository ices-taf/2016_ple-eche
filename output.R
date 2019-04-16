## Extract results of interest, write TAF output tables

## Before: input.RData (data), results.RData, sole.rep, sole.std (model)
## After:  fatage.csv, natage.csv, output.RData, res_discards.csv,
##         res_landings.csv, res_survey_fr.csv, res_survey_uk.csv,
##         summary.csv (output)

library(icesTAF)
suppressMessages(library(FLCore))

mkdir("output")

load("data/input.RData")     # obs -> stock.orig
load("model/results.RData")  # fit -> stock

minyear <- range(stock)[["minyear"]]
maxyear <- range(stock)[["maxyear"]]

## Update stock object, save output.RData
stock.orig <- stock
harvest(stock) <- results@harvest
stock.n(stock) <- results@stock.n
stock.wt(stock) <- results@stock.wt
stock(stock) <- apply(stock.n(stock) * stock.wt(stock), 2, sum)
discards.n(stock) <- results@discards.n
stock@discards.wt[,ac(minyear:2005)] <-
  apply(stock@discards.wt[,ac(2006:maxyear)], 1, mean, na.rm=TRUE)
stock@discards.wt[7, ac(c(2006,2007,2008,2012))] <-
  mean(stock@discards.wt[7,], na.rm=TRUE)
landings.n(stock) <- results@landings.n
landings.wt(stock) <- results@landings.wt
landings(stock) <- apply(landings.n(stock) * landings.wt(stock), 2, sum)
discards(stock) <- apply(discards.n(stock) * discards.wt(stock), 2, sum)
catch(stock) <- discards(stock) + landings(stock)
catch.n(stock) <- landings.n(stock) + discards.n(stock)
catch.wt(stock) <- (landings.wt(stock)*landings.n(stock) +
                    discards.wt(stock)*discards.n(stock)) /
                   (landings.n(stock)+discards.n(stock))
save(control, indices, results, stock, stock.orig, file="output/output.RData")

## Residuals
res.landings <- flr2taf(log1p(landings.n(stock.orig)) - log(results@landings.n))
res.discards <- flr2taf(log1p(discards.n(stock.orig)) - log(results@discards.n))
res.survey_uk <- flr2taf(trim(results@index.res[[1]],
                              age=1:6, year=1989:maxyear))
res.survey_fr <- flr2taf(trim(results@index.res[[2]],
                              age=1:6, year=1993:maxyear))

## Fishing mortality and numbers at age
fatage <- flr2taf(results@harvest)
natage <- flr2taf(results@stock.n)

## Summary by year
Year <- minyear:maxyear
Rec <- stock.n(stock)[1,][drop=TRUE]
SSB <- apply(stock.n(stock) * stock.wt(stock) * mat(stock), 2, sum)[drop=TRUE]
Catch <- catch(stock)[drop=TRUE]
Landings <- landings(stock)[drop=TRUE]
Discards <- Catch - Landings
Biomass <- stock(stock)[drop=TRUE]
Fbar <- apply(results@harvest[3:6], 2, mean)[drop=TRUE]
ci <- function(x) data.frame(lo=x$mean-2*x$stddev, hi=x$mean+2*x$stddev)
Rec_lo <- exp(ci(results@stdfile[results@stdfile$name=="log_initpop",]
                 [1:length(Year),]))$lo
Rec_hi <- exp(ci(results@stdfile[results@stdfile$name=="log_initpop",]
                 [1:length(Year),]))$hi
SSB_lo <- ci(results@stdfile[results@stdfile$name=="SSB",])$lo
SSB_hi <- ci(results@stdfile[results@stdfile$name=="SSB",])$hi
Fbar_lo <- ci(results@stdfile[results@stdfile$name=="Fbar",])$lo
Fbar_hi <- ci(results@stdfile[results@stdfile$name=="Fbar",])$hi
summary <- data.frame(Year, Rec, Rec_lo, Rec_hi, SSB, SSB_lo, SSB_hi, Catch,
                      Landings, Discards, Biomass, Fbar, Fbar_lo, Fbar_hi)

## Rename plus group
res.landings <- plus(res.landings)
res.discards <- plus(res.discards)
fatage <- plus(fatage)
natage <- plus(natage)

## Write tables to output directory
setwd("output")
write.taf(res.landings)   # 3.1.2a
write.taf(res.discards)   # 3.1.2b
write.taf(res.survey_uk)  # 3.1.3a
write.taf(res.survey_fr)  # 3.1.3b
write.taf(fatage)         # 3.1.4a
write.taf(natage)         # 3.1.4b
write.taf(summary)        # 3.1.6
setwd("..")
