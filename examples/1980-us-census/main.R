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

test_jb(mod, dat)

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

mods[[4]] <- lm(wage_log ~ educ + I(educ^2), data = dat)
mods[[4]] %>% summary()

mods[[5]] <- 
  dat %>%
  dplyr::filter(uhrswork != 0) %>%
  mutate(uhrswork_log = log(uhrswork)) %>%
  mutate(wage_log = LwageW) %>%
  {lm(wage_log ~ educ + I(educ^2) + uhrswork_log, data = ., na.action = na.pass)}

mods[[5]] %>% summary()

