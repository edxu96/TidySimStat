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

#### Data ####
set.seed(6)
dat <- 
  read_csv("./data/recs.csv") %>%
  slice(sample(nrow(.), 300)) %>%
  mutate(y = log(KWH / NHSLDMEM)) %>%
  dplyr::select(y, x2 = NHSLDMEM, x3 = EDUCATION, x4 = MONEYPY, x5 = HHSEX, 
    x6 = HHAGE, x7 = ATHOME) %>%
  mutate_at(seq(2, 7), as.integer)  # make continuous variables discrete

#### Correlation ####

dat %>%
  cor() %>%
  as_cordf() %>%
  stretch() %>%
  dplyr::filter(y == "y" & x != "y")

dat %>%
  ggplot(aes(x2, y, group = cut_width(x2, 1))) +
  geom_boxplot()

dat %>%
  ggplot(aes(x6, y, group = cut_width(x6, 5))) +
  geom_boxplot()

#### Regression Model using X2 ####

mods <- list()

mods[[1]] <- lm(y ~ x2, data = dat)

mods[[1]] %>% summary()

par_orginal <- par()
par(mfrow = c(2, 2), mai = c(0.3, 0.3, 0.3, 0.3))
plot(mods[[1]])
par(par_orginal)

mods[[4]] <-
  dat %>%
  dplyr::filter(row_number() != 241 & row_number() != 163 & 
    row_number() != 36) %>%
  {lm(y ~ x2, data = .)}

mods[[4]] %>% summary()

mods[[4]]$residuals %>% 
  qqPlot()

mods[[2]] <- 
  dat %>%
  mutate(x1 = 1, x21 = x2 - mean(.$x2)) %>%
  dplyr::select(y, x1, x21) %>%
  {lm(y ~ x1 + x21, data = .)}

mods[[2]] %>% summary()


####

mods[[3]] <-
  dat %>%
  as.data.frame() %>%
  {lm(y ~ 1, data = .)}

mods[[3]] %>% summary()

anova(mods[[3]], mods[[1]])

#### JB-Test ####

mods[[1]]$residuals %>% 
  tseries::jarque.bera.test()%>%  
  {(.$p.value <= qchisq(0.95, summary(mods[[1]])$df[1], lower.tail = TRUE, 
    log.p = FALSE))}

dat %>%
  dplyr::filter(x2 == 1 | x2 == 3 | x2 == 5 | x2 == 7 | x2 == 9) %>%
  ggplot() + 
    geom_freqpoly(aes(y)) +
    facet_grid(rows = vars(x2))

#### White's Test

dat %>%
  mutate(resi2 = mods[[1]]$residuals^2) %>%
  {lm(resi2 ~ x2 + I(x2^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. * nrow(dat) <= qchisq(0.95, 2, lower.tail = TRUE, log.p = FALSE)}

mods[[1]] %>% 
  bptest() %>%
  {(.$p.value <= qchisq(0.95, 2, lower.tail = TRUE, log.p = FALSE))}

#### RESET Test ####

dat %>%
  mutate(y_hat = fitted(mods[[1]])) %>%
  {lm(y ~ x2 + I(y_hat^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. * nrow(dat) <= qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)}

#### Other Regressor ####


