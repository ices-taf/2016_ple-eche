## Extract model results of interest, write TAF output tables

## Before: input.RData, results.RData, sole.rep, sole.std (model)
## After:  res_landings.csv, res_discards.csv, res_survey_uk.csv,
##         res_survey_fr.csv, fatage.csv, natage.csv, summary.csv (output)

require(icesTAF, quietly=TRUE)
suppressMessages(require(FLCore, quietly=TRUE))

mkdir("output")

load("input/input.RData")
load("model/results.RData")

minyear <- range(stock)[["minyear"]]
maxyear <- range(stock)[["maxyear"]]

## Update stock object
stock.orig <- stock
harvest(stock) <- results@harvest
stock.n(stock) <- results@stock.n
stock.wt(stock) <- results@stock.wt
stock(stock) <- apply(stock.n(stock) * stock.wt(stock), 2, sum)
discards.n(stock) <- results@discards.n
stock@discards.wt[,ac(minyear:2005)] <-
  apply(stock@discards.wt[,ac(2006:maxyear)], 1, mean, na.rm=TRUE)
stock@discards.wt[7, ac(c(2006,2007,2008,2012))] <- mean(stock@discards.wt[7,], na.rm=TRUE)
landings.n(stock) <- results@landings.n
landings.wt(stock) <- results@landings.wt
landings(stock) <- apply(landings.n(stock) * landings.wt(stock), 2, sum)
discards(stock) <- apply(discards.n(stock) * discards.wt(stock), 2, sum)
catch(stock) <- discards(stock) + landings(stock)
catch.n(stock) <- landings.n(stock) + discards.n(stock)
catch.wt(stock) <- (landings.wt(stock)*landings.n(stock) + discards.wt(stock)*discards.n(stock)) /
                   (landings.n(stock)+discards.n(stock))

## Residuals
res_landings <- flr2taf(log1p(landings.n(stock.orig)) - log(results@landings.n))
res_discards <- flr2taf(log1p(discards.n(stock.orig)) - log(results@discards.n))
res_survey_uk <- flr2taf(trim(results@index.res[[1]], age=1:6, year=1989:maxyear))
res_survey_fr <- flr2taf(trim(results@index.res[[2]], age=1:6, year=1993:maxyear))

## Fishing mortality and numbers at age
fatage <- flr2taf(results@harvest)
natage <- flr2taf(results@stock.n)

## Summary by year
year <- minyear:maxyear
rec <- stock.n(stock)[1, drop=TRUE]
ssb <- apply(stock.n(stock) * stock.wt(stock) * mat(stock), 2, sum)[drop=TRUE]
catch <- catch(stock)[drop=TRUE]
landings <- landings(stock)[drop=TRUE]
bio <- stock(stock)[drop=TRUE]
fbar <- apply(results@harvest[3:6], 2, mean)[drop=TRUE]
summary <- data.frame(Year=year, Rec=rec, SSB=ssb, Catch=catch,
                      Landings=landings, Biomass=bio, Fbar=fbar)

## Write tables to output directory
write.taf(res_landings, "output/res_landings.csv")
write.taf(res_discards, "output/res_discards.csv")
write.taf(res_survey_uk, "output/res_survey_uk.csv")
write.taf(res_survey_fr, "output/res_survey_fr.csv")
write.taf(fatage, "output/fatage.csv")
write.taf(natage, "output/natage.csv")
write.taf(summary, "output/summary.csv")
