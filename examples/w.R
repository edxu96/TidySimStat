### Econometrics Mid-term Assignment, part 2 ###
# PART 2:

rm(list = ls())
setwd("~/GitHub/TidySimStat/examples")
cat("\014");rm(list=ls());options(digits=7)
RECS<-read.csv("./data/RECS.csv", sep = ',', header=T)

set.seed(6);
sample.size<-300;
df<-RECS[sample(nrow(RECS), sample.size), ]

library(ggplot2)
library(ggpubr)
library(stats)
library(lmtest)
library(vars)
library(tseries)
library(het.test)

# 1. Briey describe the variables in Table 1. You can use tabulation, histograms, plots, cross-plots.
# DO MORE DESCRIPTIVE STATISTICS HERE.
df$KWHNHSLDMEM=df$KWH/df$NHSLDMEM
df$LKWH.pers=log(df$KWHNHSLDMEM)
hist(df$LKWH.pers)
hist(df$KWHNHSLDMEM)
hist(df$NHSLDMEM)

d <- density(df$LKWH.pers)
plot(d, main="Kernel Density of Energy consumption per household capita")
polygon(d, col="red", border="blue")

plot(df$NHSLDMEM, df$LKWH.pers)

# 2. Estimate a regression model of the log of KWH per person, i.e. Y; on a constant and the number of household members, X2.
# [Hint: See HN5 and note that you can use the lm() function in R to estimate regressions]. Call this model M2.a 

M2.a <- lm(LKWH.pers ~ NHSLDMEM, data=df)
summary(M2.a)

# 3. Show, by running the necessary auxiliary regression, how you may obtain your slope estimate Beta2 from Q2 based
# on the orthogonal reparameterization in HN ?5.2.3. (Hint: See LS6) 

M2.O <- lm(LKWH.pers ~ 1, data=df)
summary(M2.O)
lm(NHSLDMEM ~ 1, data=df)$residuals -> z1
lm(LKWH.pers ~ z1, data=df)

# 4. In the report

# 5. Checking for normality
plot(df$NHSLDMEM, df$LKWH.pers)
boxplot(df$LKWH.pers ~ df$NHSLDMEM)
abline(a=9.03574, b=-0.26998, col="green")
abline(a=8.35, b=-0.27, col="blue")
layout(matrix(1:1,1,1,byrow=TRUE))


# Different histograms
layout(matrix(1:6,2,3,byrow=TRUE))
par(mar=c(2,1,2,1))
df2 = df[df$NHSLDMEM==2,]
hist(df2$LKWH.pers)
df3 = df[df$NHSLDMEM==3,]
hist(df3$LKWH.pers)
df4 = df[df$NHSLDMEM==4,]
hist(df4$LKWH.pers)
df5 = df[df$NHSLDMEM==5,]
hist(df5$LKWH.pers)
df6 = df[df$NHSLDMEM==6,]
hist(df6$LKWH.pers)
df7 = df[df$NHSLDMEM==7,]
hist(df7$LKWH.pers)

# Jarque-bera test
jarque.bera.test(M2.a$residuals)
shapiro.test(M2.a$residuals)

# 6. White's test for heteroskedasticity: we find p=0.049 which means the model is marginally heteroskedastic.
m <- M2.a
data <- df
u2 <- m$residuals^2
y <- fitted(m)
Ru2<- summary(lm(u2 ~ y + I(y^2)))$r.squared
LM <- nrow(data)*Ru2
p.value <- 1-pchisq(LM, 2)
p.value

qqplot(df$NHSLDMEM, df$LKWH.pers)

# 7.  Check for the presence of any extreme residuals (i.e. outliers), or small groups thereof.
# If present, try to assess the inuence of these outliers on the two mis-specication tests above.
# Try to identify the outliers and investigate whether they are special/extraordinary with respect
# to the other variables in Table 1 (or more generally other variables in the dat2). Comment.

# 8. Augment the model with the remaining variables in Table 1. Call the augmented model, M2.b.
# Estimate M2.b and perform the JB and Whites test again. What are your conclusions now?
# If your model, M2.b, is still mis-specied, you may consider adding other variables in dat2, and/or adding
# transformations of some of the variables in Table 1, e.g. polynomial (say, squares and/or cubic) terms.

M2.b <- lm(LKWH.pers ~ NHSLDMEM + EDUCATION + MONEYPY + HHSEX + HHAGE + ATHOME, data=df)
summary(M2.b)

layout(matrix(1:1,1,1,byrow=TRUE))
plot(df$MONEYPY, df$LKWH.pers)
df$MONEYPY

plot(df$HHAGE, df$LKWH.pers)

# White's test for heteroskedasticity: we find p=0.08507566 which means the model is marginally homoskedastic.
m2 <- M2.b
data <- df
u22 <- m2$residuals^2
y <- fitted(m2)
Ru2<- summary(lm(u22 ~ y + I(y^2)))$r.squared
LM <- nrow(data)*Ru2
p.value <- 1-pchisq(LM, 2)
p.value > 0.05


m2 <- M2.b
data <- df
u22 <- m2$residuals^2
y <- fitted(m2)
x1 <- df$NHSLDMEM
x2 <- df$EDUCATION
x3 <- df$MONEYPY
x4 <- df$HHSEX
x5 <- df$HHAGE
x6 <- df$ATHOME
Ru2<- summary(lm(u22 ~ x1 + x2 + x3 + x4 + x5 + x6+ I(x1^2) + I(x2^2) + I(x3^2) +
                    I(x4^2) + I(x6^2)+ I(x5^2) +
                   I(x1 * x2) + I(x1 * x3) + I(x1 * x3) + I(x1 * x5) + I(x1 * x6) + 
                   I(x2 * x3) + I(x2 * x4) + I(x2 * x5) + I(x2 * x6) + I(x4 * x3) + I(x5 * x3) + 
                   I(x3 * x6) + I(x4 * x5) + I(x4 * x6) + I(x5 * x6) 
                 ))$r.squared
LM <- nrow(data)*Ru2
p.value <- 1-pchisq(LM, 21)
p.value > 0.05



# Jarque-bera test
jarque.bera.test(m2$residuals)
shapiro.test(m2$residuals)

# Let's give Ramsey's RESET-test a shot as well:
resettest(M2.b, power = 2:3, type = c("fitted", "regressor", "princomp"), data = list())

# 9. When your augmented model, M2.b. seems well-specied based on the two mis-specication tests above (at least
# approximately), we are ready to conduct inference. Start by interpreting the estimates in your R output
# corresponding to M2.b, with respect to the signs, magnitudes and signicance. Are the estimates sensitive towards
# exclusion of any single regressor? Comment.

# In the report

# 10. Conducta(one-sided)t-test, at10%levelofsignicance, ofthenullhypothesisthattheslopecoe? cient, 2; on X2
# (NHSLDMEM): Choose the alternative hypothesis (2 > 0 or 2 < 0) and argue why this is a reasonable alternative.
# One-sided t-test
m2$coefficients[2]
t.test(df$NHSLDMEM, mu = 0, alternative = "greater")
res <- summary(M2.b)
pt(coef(res)[, 3], M2.b$df, lower = FALSE)

# Or,
Z <- print(-0.259971/0.029144)

# M2.r: M2.b without its least significant regressor, HHSEX:
M2.r <- lm(LKWH.pers ~ NHSLDMEM + EDUCATION + MONEYPY + HHAGE + ATHOME, data=df)
summary(M2.r)

# 11. Perform an LR test for the exclusion of one of your regressors. Do this "manually" based on comparing
# the maximized log-likelihood functions.[Hint: compute the maxima, LR statistic and critical value in R as usual].
lrtest(M2.r,M2.b)

# We cannot reject the hypothesis that gender does not matter for participation.
# In other words, there is no support for gender as an explanatory variable at the 0.05 level.

# 12. Suppose that you have more than one insignicant regressor. How could you reduce the model,
# i.e. remove these insignicant regressors? [Hint: see ?7.6]

# In the report

# 13. Present your nal model where you have added your favorite regressors and removed insignicant ones cf. the above.
# Discuss whether a structural interpretation of the estimated parameters seems reasonable and how this could be
# assessed (see LS6 and HN ?5.3).