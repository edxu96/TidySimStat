

library(stats);
setwd("~/Desktop/test")
dat.RECS<-read.csv("./recs.csv",sep = ',', header = T)
dat.RECS$KWH.pers<-dat.RECS$KWH/dat.RECS$NHSLDMEM
dat.RECS$LKWH.pers<-log(dat.RECS$KWH.pers)
seed<-8;
set.seed(seed)
sample.size<-305;
dat.RECS.s<-dat.RECS[sample(nrow(dat.RECS), sample.size), ]
M1.s<-lm(LKWH.pers ~  NHSLDMEM + EDUCATION + MONEYPY + HHSEX + HHAGE + ATHOME, data = dat.RECS.s)
(sum.m1<-summary(M1.s))



# residuals needed for next question
res.M1.s<-M1.s$residuals


M2<-lm(LKWH.pers ~  NHSLDMEM + EDUCATION + MONEYPY + HHAGE + ATHOME, data = dat.RECS.s)

2 * (as.numeric(logLik(M1.s)) - as.numeric(logLik(M2))) <= qchisq(0.90, 1, lower.tail = TRUE, log.p = FALSE)
