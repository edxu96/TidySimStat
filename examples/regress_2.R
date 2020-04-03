## Assign: Ecnometrics
## Edward J. Xu
## Mar 22, 2020
rm(list = ls())
setwd("~/GitHub/TidySimStat/examples")
library(tidyverse)
library(conflicted)
library(magrittr)
library(lmtest)
library(corrr)
library(broom)
library(tseries)
library(car)

## Data ####
set.seed(6)
dat_3 <- 
  read_csv("./data/recs.csv") %>%
  dplyr::slice(sample(nrow(.), 300)) %>%
  mutate(y = log(KWH / NHSLDMEM)) %>%
  dplyr::select(y, x2 = NHSLDMEM, x3 = EDUCATION, x4 = MONEYPY, x5 = HHSEX, 
                x6 = HHAGE, x7 = ATHOME) %>%
  mutate_at(seq(2, 7), as.integer) %>%  # make continuous variables discrete
  dplyr::filter(row_number() != 36) %>%
  mutate(x5 = - x5 + 2) 

mods2 <- list()

## x5 as Dummy Variable ####

mods2[[1]] <- lm(y ~ x2 + x3 + x4 + x5 + x6, data = dat_3)
mods2[[1]] %>% summary()

par_orginal <- par()
par(mfrow = c(2, 2), mai = c(0.3, 0.3, 0.3, 0.3))
plot(mods2[[1]])
par(par_orginal)

dat_3 %>%
  mutate(resi2 = mods2[[1]]$residuals^2) %>%
  {lm(resi2 ~ x2 + x3 + x4 + x6 + x5 + I(x2^2) + I(x3^2) + I(x4^2) + I(x5^2) +
    I(x6^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. * nrow(dat_3) <= qchisq(0.95, 6, lower.tail = TRUE, log.p = FALSE)}

## Standardize the data ####

dat_4 <- 
  dat_3 %>%
  mutate(x5 = as.factor(x5)) %>%
  mutate_at(c(2:4, 6:7), scale) %>%
  as.tibble()

mods2[[2]] <- lm(y ~ x2 + x3 + x4 + x5 + x6, data = dat_4)
mods2[[2]] %>% summary()
