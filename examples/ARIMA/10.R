# R code for the examples in L10
# dev.off() # deletes all plots
# cat("\014");
rm(list=ls());
options(digits=4)
setwd("~/GitHub/TidySimStat/examples/ARIMA")
#needed libraries:
library(stats);

# Fulton fish data from HN 12
dat.fulton<-read.csv("../../data/Fulton_nfmo.csv",sep = ';', header = T)
# Transform to time-series object for AR() estimation below
dat.fulton.ts<-ts(dat.fulton) # We do not need to specify frequency

# log price
plot(dat.fulton.ts[,"LogPrice"])
abline(h=mean(dat.fulton.ts[,"LogPrice"]),col="red",lw=3)
# consistent with mean reversion but also some persistence (dependence)


# plot the sample ACF
acf(dat.fulton.ts[,"LogPrice"],lag.max = 12)


# plot the sample PACF
pacf(dat.fulton.ts[,"LogPrice"],lag.max = 12)
# consistent with AR(1)

# Fitting AR(1) based on arx() (can be used when augmenting with indicators later)
y<-dat.fulton.ts[,"LogPrice"]
library(gets)
m1<-arx(y, mc=T, ar=1, mxreg=NULL,qstat.options=c(1,1)); m1; # This replicate HNs AR(1) model estimates (Table 12.1)

# LR test in p 187: autregressive coeff =0
m0<-arx(y[2:length(y)], mc=T, ar=NULL, mxreg=NULL,qstat.options=c(1,1)); m0;
# note the y[2:length(y)] so the m0 has the same # obs as m1
(LR<-2*(m1$logl-m0$logl))
