## Prepare tables for report

## Before: latage.csv, wlandings.csv, datage.csv, wdiscards.csv, wstock.csv,
##         survey_uk.csv, survey_fr.csv (data), res_discards.csv,
##         summary.csv (output)
## After:  latage.csv, wlandings.csv, datage.csv, wdiscards.csv, wstock.csv,
##         survey_uk.csv, survey_fr.csv (data), res_discards.csv,
##         summary.csv (report)

library(icesTAF)

mkdir("report")

## latage (round)
latage <- read.taf("data/latage.csv")
latage <- round(latage)
write.taf(latage, "report/latage.csv")

## wlandings (round)
wlandings <- read.taf("data/wlandings.csv")
wlandings <- round(wlandings, 3)
write.taf(wlandings, "report/wlandings.csv")

## datage (trim year, round)
datage <- read.taf("data/datage.csv")
datage <- na.omit(datage)
datage <- round(datage)
write.taf(datage, "report/datage.csv")

## wdiscards (trim year, round)
wdiscards <- read.taf("data/wdiscards.csv")
wdiscards <- wdiscards[rowSums(wdiscards[-1],na.rm=TRUE) > 0,]
wdiscards <- round(wdiscards, 3)
write.taf(wdiscards, "report/wdiscards.csv")

## wstock (round)
wstock <- read.taf("data/wstock.csv")
wstock <- round(wstock, 3)
write.taf(wstock, "report/wstock.csv")

## survey_uk (round)
survey_uk <- read.taf("data/survey_uk.csv")
survey_uk <- round(survey_uk, 1)
write.taf(survey_uk, "report/survey_uk.csv")

## survey_fr (round)
survey_fr <- read.taf("data/survey_fr.csv")
survey_fr <- round(survey_fr, 1)
write.taf(survey_fr, "report/survey_fr.csv")

## res_discards (trim year)
res_discards <- read.taf("output/res_discards.csv")
res_discards <- na.omit(res_discards)
write.taf(res_discards, "report/res_discards.csv")

## summary (round)
summary <- read.taf("output/summary.csv")
summary <- as.data.frame(mapply(round, summary, digits=c(0,0,0,0,0,0,5)))
write.taf(summary, "report/summary.csv")
