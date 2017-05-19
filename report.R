## Prepare tables for report

## Before: catage.csv, smh.csv, wstock.csv, wcatch.csv,
##         maturity.csv, summary.csv, natage.csv,
##         fatage.csv (upload)
## After:  catage_rep.csv, smh_rep.csv, wstock_rep.csv, wcatch_rep.csv,
##         maturity_rep.csv, summary_rep.csv, natage_rep.csv,
##         fatage_rep.csv (upload)

require(icesTAF, quietly=TRUE)

mkdir("upload/report")

## latage (round)
latage <- read.taf("upload/input/latage.csv")
latage <- round(latage)
write.taf(latage, "upload/report/latage_rep.csv")

## wlandings (round)
wlandings <- read.taf("upload/input/wlandings.csv")
wlandings <- round(wlandings, 3)
write.taf(wlandings, "upload/report/wlandings_rep.csv")

## datage (trim year, round)
datage <- read.taf("upload/input/datage.csv")
datage <- na.omit(datage)
datage <- round(datage)
write.taf(datage, "upload/report/datage_rep.csv")

## wdiscards (trim year, round)
wdiscards <- read.taf("upload/input/wdiscards.csv")
wdiscards <- wdiscards[rowSums(wdiscards[-1],na.rm=TRUE) > 0,]
wdiscards <- round(wdiscards, 3)
write.taf(wdiscards, "upload/report/wdiscards_rep.csv")

## wstock (round)
wstock <- read.taf("upload/input/wstock.csv")
wstock <- round(wstock, 3)
write.taf(wstock, "upload/report/wstock_rep.csv")

## survey_uk (round)
survey_uk <- read.taf("upload/input/survey_uk.csv")
survey_uk <- round(survey_uk, 1)
write.taf(survey_uk, "upload/report/survey_uk_rep.csv")

## survey_fr (round)
survey_fr <- read.taf("upload/input/survey_fr.csv")
survey_fr <- round(survey_fr, 1)
write.taf(survey_fr, "upload/report/survey_fr_rep.csv")

## res_discards (trim year)
res_discards <- read.taf("upload/output/res_discards.csv")
res_discards <- na.omit(res_discards)
write.taf(res_discards, "upload/report/res_discards_rep.csv")

## summary (round)
summary <- read.taf("upload/output/summary.csv")
summary <- as.data.frame(mapply(round, summary, digits=c(0,0,0,0,0,0,5)))
write.taf(summary, "upload/report/summary_rep.csv")
