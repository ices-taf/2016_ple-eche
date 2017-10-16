## Prepare plots for report

## Before: summary.csv (output)
## After:  biomass.png, catches.png, f_mortality.png, recruitment.png (report)

library(icesTAF)
library(areaplot)
suppressMessages(library(gplots))

mkdir("report")

## Change unit
summary <- read.taf("output/summary.csv")
x <- div(summary, c("Rec","SSB","Catch","Landings","Discards","Biomass",
                    "Rec_lo","Rec_hi","SSB_lo","SSB_hi"))

## Plots
tafpng("catches")
col <- c(taf.green, taf.orange)
barplot(t(x[c("Landings","Discards")]), names=x$Year, ylim=lim(x$Catch),
        col=col, ylab="Catches (1000 t)", main="Catches")
legend("topright", c("Discards","Landings"), fill=rev(col), bty="n", inset=0.04)
box()
dev.off()

tafpng("f_mortality")
confplot(x[c("Year","Fbar_lo","Fbar_hi")], ylim=lim(x$Fbar_hi,1.3), yaxs="i",
         col=taf.green, xlab="", ylab="Fbar (3-6)", main="Fishing mortality")
lines(x$Year, x$Fbar)
abline(h=0.50, lty=2, lwd=3)
abline(h=0.36, lty=3, lwd=3)
abline(h=0.25, col=taf.orange, lwd=3)
legend("topright", c("Flim","Fpa","Fmsy"), lty=c(2,3,1),
       col=c("black","black",taf.orange), lwd=3, bty="n", inset=0.04)
dev.off()

tafpng("biomass")
confplot(x[c("Year","SSB_lo","SSB_hi")], ylim=lim(x$SSB_hi), yaxs="i",
         col=taf.green, xlab="", ylab="SSB (1000 t)",
         main="Spawning stock biomass")
lines(x$Year, x$SSB)
abline(h=25.826, col=taf.orange, lwd=3)
abline(h=25.826, lty=3, lwd=3)
abline(h=18.448, lty=2, lwd=3)
legend("topleft", c("Btrigger","Bpa","Blim"), lty=c(1,3,2),
       col=c(taf.orange,"black","black"), lwd=3, bty="n", inset=0.04)
dev.off()

tafpng("recruitment.png")
mid <- barplot(x$Rec, names=x$Year, ylim=lim(x$Rec_hi),
               ylab="Recruitment (thousands)", main="Recruitment (age 1)",
               col=taf.dark)
plotCI(mid, x$Rec, li=x$Rec_lo, ui=x$Rec_hi, gap=0, pch=NA, sfrac=0.005,
       lwd=2, col=taf.light, add=TRUE)
box()
dev.off()
