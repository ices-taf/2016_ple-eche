## Prepare plots for report

## Before: summary.csv (output)
## After:  biomass.png, catches.png, f_mortality.png, recruitment.png (report)

library(icesTAF)
library(areaplot)

mkdir("report")

## Change unit
summary <- read.taf("output/summary.csv")
x <- div(summary, c("Rec","SSB","Catch","Landings","Discards","Biomass",
                    "Rec_lo","Rec_hi","SSB_lo","SSB_hi"))

## Plots
tafpng("f_mortality")
confplot(x[c("Year","Fbar_lo","Fbar_hi")], ylim=lim(x$Fbar_hi,1.3), yaxs="i",
         ylab="Fbar (3-6)", main="Fishing mortality")
lines(x$Year, x$Fbar)
dev.off()

tafpng("biomass")
confplot(x[c("Year","SSB_lo","SSB_hi")], ylim=lim(x$SSB_hi), yaxs="i",
         ylab="SSB (1000 t)", main="Biomass")
lines(x$Year, x$SSB)
dev.off()
