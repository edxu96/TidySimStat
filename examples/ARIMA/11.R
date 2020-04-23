# R code for the examples in L10
# dev.off() # deletes all plots
cat("\014");rm(list=ls());
options(digits=5)
#needed libraries:
library(stats);

# Fulton fish data from HN 12
dat.fulton <- read.csv("../../data/Fulton.csv", sep = ';', header = T)
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
y <- dat.fulton.ts[,1]
library(gets)
m1<-arx(y, mc=T, ar=1, mxreg=NULL,qstat.options=c(1,1)); m1; # This replicate HNs AR(1) model estimates (Table 12.1)


#independence
#graphical test
acf(res1)
pacf(res1)
# Check the Ljung-Box AR() test
m1<-arx(y, mc=T, ar=1, mxreg=NULL,qstat.options=c(1,1));
m1;
# qstat.options=c(1,1) controls order of AR and ARCH tests

#AR2 HN 13.3.3
m2<-arx(y, mc=T, ar=1:2, mxreg=NULL,qstat.options=c(1,1)); m2;
#look at "t-stat" in m2 (ok u. stationarity)
# try on your own to do LR testing for additional lag (§13.3.1)
# making sure same # obs when computing (LR<-2*(m2$logl-m1$logl))

# ARCH test §13.3.2 
m1; # see Ljung-Box ARCH()


# testing parameter constancy (recursive estimtion)
# Two first panels in Figur 13.1
rec<-recursive(m1, spec="mean", std.errors=TRUE, from=27, plot=TRUE, return=T)
# recursive graphs with "+-2se conf. bands":
# choose which param to look at
colnames(rec$estimates)
I<-which(colnames(rec$estimates)=="ar1")

g.min<-min(rec$estimates[,I]-2*rec$standard.errors[,I],na.rm = T)
g.max<-max(rec$estimates[,I]+2*rec$standard.errors[,I],na.rm = T)
plot(rec$estimates[,I],ylim = c(g.min,g.max))
lines(rec$estimates[,I]+2*rec$standard.errors[,I],col="red")
lines(rec$estimates[,I]-2*rec$standard.errors[,I],col="red")

###################################
################################

