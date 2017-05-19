## Gather TAF input and output tables to be uploaded

## Before: catch.csv, survey.csv, dls.txt (db, output)
## After:  catch.csv, survey.csv, dls.txt (upload)

dir.create("upload/input", showWarnings=FALSE, recursive=TRUE)
dir.create("upload/output", showWarnings=FALSE)

## Input
invisible(file.copy("db/datage.csv", "upload/input/datage.csv", overwrite=TRUE))
invisible(file.copy("db/latage.csv", "upload/input/latage.csv", overwrite=TRUE))
invisible(file.copy("db/survey_fr.csv", "upload/input/survey_fr.csv", overwrite=TRUE))
invisible(file.copy("db/wcatch.csv", "upload/input/wcatch.csv", overwrite=TRUE))
invisible(file.copy("db/wdiscards.csv", "upload/input/wdiscards.csv", overwrite=TRUE))
invisible(file.copy("db/wstock.csv", "upload/input/wstock.csv", overwrite=TRUE))

## Output
invisible(file.copy("output/fatage.csv", "upload/output/fatage.csv", overwrite=TRUE))
invisible(file.copy("output/natage.csv", "upload/output/natage.csv", overwrite=TRUE))
invisible(file.copy("output/res_discards.csv", "upload/output/res_discards.csv", overwrite=TRUE))
invisible(file.copy("output/res_landings.csv", "upload/output/res_landings.csv", overwrite=TRUE))
invisible(file.copy("output/res_survey_fr.csv", "upload/output/res_survey_fr.csv", overwrite=TRUE))
invisible(file.copy("output/res_survey_uk.csv", "upload/output/res_survey_uk.csv", overwrite=TRUE))
invisible(file.copy("output/summary.csv", "upload/output/summary.csv", overwrite=TRUE))
