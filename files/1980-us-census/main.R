## Regression Model for 1980 US Census Data
## according to hendry2007econometric
## Edward J. Xu
## Mar 27, 2020
rm(list = ls())
setwd("~/GitHub/TidySimStat/examples/1980-us-census")
library(tidyverse)
library(magrittr)
library(lmtest)
library(corrr)
library(broom)
library(tseries)
library(readxl)
library(propagate)
library(het.test)

dat <-
  read_csv("./data.csv") %>%
  mutate(wage_log = LwageW) %>%
  dplyr::select(educ, wage_log)

dat %>%
  ggplot(aes(educ, wage_log, group = cut_width(educ, 1))) +
  geom_boxplot()

mod <- lm(wage_log ~ educ, data = dat)

mod %>%
  residuals() %>%
  tseries::jarque.bera.test()

mod %>%  
  resettest(power = 2:3, type = c("fitted", "regressor",  "princomp"),
                data = dat)

qqPlot(mod$residuals)

mods[[2]] <-
  dat %>%
  mutate(x1 = 1, x21 = educ - mean(.$educ)) %>%
  {lm(wage_log ~ x1 + x21, data = .)}

mods[[2]] %>% summary()

mods[[3]] <-
  dat %>%
  {lm(wage_log ~ 1, data = .)}

mods[[3]] %>% summary()

anova(mods[[3]], mods[[1]])
( - 3877 * log(summary(mods[[1]])$sigma / summary(mods[[3]])$sigma) )

#### One-Sided Test ####

mods[[1]] %>%
  summary() %>%
  {pt(coef(.)[2, 3], mods[[1]]$df, lower = FALSE)} %>%
  {. <= qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)}

####

mod_1 <- lm(wage_log ~ educ + I(educ^2), data = dat)
mod_1 %>% summary()

mod_2 <- lm(wage_log ~ educ, data = dat)

lrtest(mod_1, mod_2)

test_lik(mod_1, mod_2)

mods[[5]] <- 
  dat %>%
  dplyr::filter(uhrswork != 0) %>%
  mutate(uhrswork_log = log(uhrswork)) %>%
  mutate(wage_log = LwageW) %>%
  {lm(wage_log ~ educ + I(educ^2) + uhrswork_log, data = ., na.action = na.pass)}

mods[[5]] %>% summary()

####

library(matlib)
data(class)
class$male <- as.numeric(class$sex=="M")
class <- transform(class, IQ = round(20 + height + 3*age -.1*weight -3*male + 
  10*rnorm(nrow(class))))
head(class)
X <- as.matrix(class[,c(3,4,2,5)])
head(X)

Z <- cbind(X[,1], 0, 0, 0)
Z[,2] <- X[,2] - Proj(X[,2], Z[,1])
Z[,3] <- X[,3] - Proj(X[,3], Z[,1]) - Proj(X[,3], Z[,2]) 
Z[,4] <- X[,4] - Proj(X[,4], Z[,1]) - Proj(X[,4], Z[,2]) - Proj(X[,4], Z[,3])
colnames(Z) <- colnames(X)
Z

class2 <- data.frame(Z, IQ=class$IQ)
mod1 <- lm(IQ ~ height + weight + age + male, data=class)
mod1 %>% summary()
mod2 <- lm(IQ ~ height + weight + age + male, data=class2)
mod2 %>% summary()

####

# generating random x1 x2 x3 in (0,1) (10 values each)
x1 <- runif(10)
x2 <- runif(10)
x3 <- runif(10)

# generating y
y <- x1 + 2 * x2 + 3 * x3 + rnorm(10)

# classical regression
model <- lm(y ~ x1 + x2 + x3) 

# orthogonalize regressors on a unit vector
lm(x1 ~ 1)$residuals -> z1
lm(x2 ~ 1 + x1)$residuals -> z2
lm(x3 ~ 1 + x1 + x2)$residuals -> z3

lm(y ~ z1 + z2 + z3) %>% summary()

