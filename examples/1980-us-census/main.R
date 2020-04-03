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

mods <- list()
mods[[1]] <- lm(wage_log ~ educ, data = dat)
mods[[1]] %>% summary()

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

#### Jarque-Bera Test ####

qchisq(0.95, summary(mods[[1]])$df[1], lower.tail = TRUE, log.p = FALSE)
qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)
1 - pchisq(3.841459, 1)

mods[[1]] %>%
  residuals() %>%
  tseries::jarque.bera.test() %>%
  glance()

mods[[1]] %>%
  residuals() %>%
  propagate::skewness() %>%
  {.^2 * nrow(mods[[1]]) / 6}

mods[[1]] %>%
  residuals() %>%
  propagate::kurtosis() %>%
  {.^2 * nrow(mods[[1]]) / 24}

#### White's Test ####

dat %>%
  mutate(resi2 = mods[[1]]$residuals^2) %>%
  {lm(resi2 ~ educ + I(educ^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. / 2 / (1 - .) * (nrow(dat) - 2)} 

dat %>%
  mutate(resi2 = mods[[1]]$residuals^2) %>%
  {lm(resi2 ~ educ + I(educ^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. * nrow(dat) <= qchisq(0.95, 2, lower.tail = TRUE, log.p = FALSE)}

dat %>%
  mutate(resi2 = mods[[1]]$residuals^2) %>%
  {lm(resi2 ~ educ + I(educ^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {1 - pchisq(. * nrow(dat), 2)}

mods[[1]] %>%
  bptest(~ educ + I(educ^2), data = dat)

mods[[1]] %>%
  whites.htest()

#### RESET Test ####

mods[[1]] %>%
  reset()

dat %>%
  mutate(y_hat = fitted(mods[[1]])) %>%
  {lm(wage_log ~ educ + I(y_hat^2), data = .)} %>%
  modelEffectSizes() %>%
  {.$Effects} %>%
  {.[3, nrow(.)] * 3873} %>%
  {1 - pchisq(., 1)} %>%
  {. >= 0.05}

%>%
  {. <= qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)}



mod %>%
  {tidy(.)$p.value[3] * 3874}


%>%
  {tidy(.)$p.value[3]} %>%
  {. * (nrow(dat) - 1)} %>%
  {1 - pchisq(. * (nrow(dat) - 1), 1)}
    
    

dat %>%
  mutate(y_hat = fitted(mods[[1]])) %>%
  {lm(wage_log ~ educ + I(y_hat^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {1 - pchisq(. * nrow(dat), 1)}
  
dat %>%
  mutate(y_hat = fitted(mods[[1]])) %>%
  {lm(wage_log ~ educ + I(y_hat^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. * nrow(dat) <= qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)}

mods[[4]] <- 
  lm(wage_log ~ educ + I(educ^2), data = dat)

dat %>%
  mutate(y_hat = fitted(mods[[4]])) %>%
  {lm(wage_log ~ educ + I(educ^2) + I(y_hat^2), data = .)} %>%
  modelEffectSizes() %>%
  {.$Effects[3, 4] * 3873} %>%
  {. <= qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)}

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

