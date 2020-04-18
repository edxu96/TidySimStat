## for: GitHub/edxu96/TidySimStat/examples/ARIMA
## Edward J. Xu
## April 16, 2020
rm(list = ls())
setwd("~/GitHub/TidySimStat/examples/ARIMA")
library(tidyverse)
library(magrittr)
library(tsibble)
library(lubridate)
library(forecast)

#### Time Domain ####

tsi <- read_csv("../../data/Fulton.csv") %>%
  # mutate(p = exp(LogPrice)) %>% 
  mutate(t = ymd(Date)) %>%
  mutate(p.log = LogPrice) %>%
  select(t, p.log) %>%
  as_tsibble(index = t)
  
tsi %>% ggplot() +
  geom_line(aes(t, p.log))

tsi %>% acf(na.action = na.pass) %>%
  autoplot()

tsi %>% pacf(na.action = na.pass) %>%
  autoplot()

mods <- list()

mods[[1]] <- tsi %>%
  ar.ols(aic = FALSE, order.max = 1, demean = F, intercept = T, 
    na.action = na.pass)
mods[[1]] %>% summary

mods[[1]] %>% plot()

mods[[1]] %>% logLik()

#### Frequency Domain ####

library(astsa)

x1 = 2*cos(2*pi*1:100*6/100) + 3*sin(2*pi*1:100*6/100) 
x2 = 4*cos(2*pi*1:100*10/100) + 5*sin(2*pi*1:100*10/100) 
x3 = 6*cos(2*pi*1:100*40/100) + 7*sin(2*pi*1:100*40/100) 
x =x1+x2+x3

par(mfrow=c(2,2))
plot.ts(x1, ylim=c(-10,10), main=expression(omega==6/100~~~A^2==13)) 
plot.ts(x2, ylim=c(-10,10), main=expression(omega==10/100~~~A^2==41)) 
plot.ts(x3, ylim=c(-10,10), main=expression(omega==40/100~~~A^2==85)) 
plot.ts(x, ylim=c(-16,16), main="sum")

P = Mod(2 * fft(x) / 100)^2;  
Fr = 0:99/100
plot(Fr, P, type="o", xlab="frequency", ylab="scaled periodogram")

set.seed(90210) # so you can reproduce these results 
x = 2*cos(2*pi*1:500/50 + .6*pi) + rnorm(500,0,5)
z1 = cos(2*pi*1:500/50)
z2 = sin(2*pi*1:500/50)
summary(fit <- lm(x~0+z1+z2)) # zero to exclude the intercept 
par(mfrow=c(2,1))
plot.ts(x)
plot.ts(x, col=8, ylab=expression(hat(x))) 
lines(fitted(fit), col=2)

