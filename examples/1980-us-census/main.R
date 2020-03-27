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
  select(educ, wage_log)

dat %>%
  ggplot(aes(educ, wage_log, group = cut_width(educ, 1))) +
  geom_boxplot()

mod_1 <-
  lm(wage_log ~ educ, data = dat)

mod_1 %>% summary()

mod_2 <-
  dat %>%
  mutate(x1 = 1, x21 = educ - mean(.$educ)) %>%
  {lm(wage_log ~ x1 + x21, data = .)}

mod_2 %>% summary()

mod_3 <-
  dat %>%
  {lm(wage_log ~ 1, data = .)}

mod_3 %>% summary()

anova(mod_3, mod_1)
( - 3877 * log(summary(mod_1)$sigma / summary(mod_3)$sigma) )

#### Jarque-Bera Test ####

qchisq(0.95, summary(mod_1)$df[1], lower.tail = TRUE, log.p = FALSE)

mod_1 %>%
  residuals() %>%
  tseries::jarque.bera.test() %>%
  glance()

mod_1 %>%
  residuals() %>%
  propagate::skewness() %>%
  {.^2 * nrow(mod_1) / 6}

mod_1 %>%
  residuals() %>%
  propagate::kurtosis() %>%
  {.^2 * nrow(mod_1) / 24}

#### White's Test ####

dat %>%
  mutate(resi2 = mod_1$residuals^2) %>%
  {lm(resi2 ~ educ + I(educ^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. / 2 / (1 - .) * (nrow(dat) - 2)} 

dat %>%
  mutate(resi2 = mod_1$residuals^2) %>%
  {lm(resi2 ~ educ + I(educ^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. * nrow(dat) <= qchisq(0.95, 2, lower.tail = TRUE, log.p = FALSE)}

dat %>%
  mutate(resi2 = mod_1$residuals^2) %>%
  {lm(resi2 ~ educ + I(educ^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {1 - pchisq(. * nrow(dat), 2)}

mod_1 %>%
  bptest(~ educ + I(educ^2), data = dat)

mod_1 %>%
  whites.htest()

#### RESET Test ####

mod_1 %>%
  reset()

dat %>%
  mutate(y_hat = fitted(mod_1)) %>%
  {lm(wage_log ~ educ + I(y_hat^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. / 1 / (1 - .) * 3874} 

dat %>%
  mutate(y_hat = fitted(mod_1)) %>%
  {lm(wage_log ~ educ + I(y_hat^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {1 - pchisq(. * nrow(dat), 1)}
  
dat %>%
  mutate(y_hat = fitted(mod_1)) %>%
  {lm(wage_log ~ educ + I(y_hat^2), data = .)} %>%
  {summary(.)$r.squared} %>%
  {. * nrow(dat) <= qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)}

#### 

# t.test(wage_log ~ educ, dat, mu=0, alternative = 'greater')
# 
# data = c(52.7, 53.9, 41.7, 71.5, 47.6, 55.1,
#          62.2, 56.5, 33.4, 61.8, 54.3, 50.0, 
#          45.3, 63.4, 53.9, 65.5, 66.6, 70.0,
#          52.4, 38.6, 46.1, 44.4, 60.7, 56.4)
# 
# t.test(data, mu=50, alternative = 'greater')
# 
# confint(mod_1)
# 
# 
# 
# linearHypothesis(mod_1, "educ = -1")
# 
# slope.test(wage_log, educ, test.value = 1, data = dat)


mod %>%
  summary() %>%
  {pt(coef(.)[2, 3], mod$df, lower = FALSE)} %>%
  {. <= qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)}

