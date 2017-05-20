## Gather TAF input and output tables to be uploaded

## Before: datage.csv, latage.csv, survey_fr.csv, survey_uk.csv, wlandings.csv,
##         wdiscards.csv, wstock.csv, fatage.csv, natage.csv, res_discards.csv,
##         res_landings.csv, res_survey_fr.csv, res_survey_uk.csv,
##         summary.csv (db, output)
## After:  datage.csv, latage.csv, survey_fr.csv, survey_uk.csv, wlandings.csv,
##         wdiscards.csv, wstock.csv, fatage.csv, natage.csv, res_discards.csv,
##         res_landings.csv, res_survey_fr.csv, res_survey_uk.csv,
##         summary.csv (upload)

library(icesTAF)

mkdir("upload/input")
mkdir("upload/output")

cp("db/*.csv", "upload/input")
cp("output/*.csv", "upload/output")
