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
write.taf(latage, dir="report")

## wlandings (round)
wlandings <- read.taf("data/wlandings.csv")
wlandings <- round(wlandings, 3)
write.taf(wlandings, dir="report")

## datage (trim year, round)
datage <- read.taf("data/datage.csv")
datage <- na.omit(datage)
datage <- round(datage)
write.taf(datage, dir="report")

## wdiscards (trim year, round)
wdiscards <- read.taf("data/wdiscards.csv")
wdiscards <- wdiscards[rowSums(wdiscards[-1],na.rm=TRUE) > 0,]
wdiscards <- round(wdiscards, 3)
write.taf(wdiscards, dir="report")

## wstock (round)
wstock <- read.taf("data/wstock.csv")
wstock <- round(wstock, 3)
write.taf(wstock, dir="report")

## survey.uk (round)
survey.uk <- read.taf("data/survey_uk.csv")
survey.uk <- round(survey.uk, 1)
write.taf(survey.uk, dir="report")

## survey.fr (round)
survey.fr <- read.taf("data/survey_fr.csv")
survey.fr <- round(survey.fr, 1)
write.taf(survey.fr, dir="report")

## res.discards (trim year)
res.discards <- read.taf("output/res_discards.csv")
res.discards <- na.omit(res.discards)
write.taf(res.discards, dir="report")

## summary (select columns, round)
summary <- read.taf("output/summary.csv")
summary <- summary[c("Year","SSB","Catch","Landings","Biomass","Fbar")]
summary <- rnd(summary, c("SSB","Catch","Landings","Biomass"))
summary <- rnd(summary, "Fbar", 5)
names(summary)[names(summary)=="Biomass"] <- "Total Biomass"
write.taf(summary, dir="report")
