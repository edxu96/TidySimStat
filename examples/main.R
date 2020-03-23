## Assign: Ecnometrics
## Edward J. Xu
## Mar 22, 2020
setwd("~/GitHub/TidySimStat/examples")
library(tidyverse)
library(magrittr)
library(lmtest)

#### Data ####
dat <- read_csv("./data/EEHA.csv")

set.seed(6)
sample_size <- 1200
dat <- dat %>%
  slice(sample(nrow(dat), sample_size))

dat %>%
  select(respondent_ID, age, know_el)

#### Conditional Frequency ####
cal_freq_con <- function(x, dat, y){
  x_n <- dat %>%
    filter(age == x) %>%
    nrow()
  
  xy_n <- dat %>%
    filter(age == x) %>%
    filter(know_el == 1) %>%
    nrow()
  
  return(xy_n / x_n)
}

## Note that the age group starts from 0
dist_know_el <- 
  tibble(age = seq(5)) %>%
  mutate(freq = map_dbl(.$age, cal_freq_con, dat = dat)) %>%
  mutate(freq_0 = 1 - freq) %>%
  mutate(odd = freq / freq_0) %>%
  mutate(log_odd = log(odd)) %>%
  mutate(age_new = age - 1)  # new age group index is used
  # so that it is easier to interpret the meaning of two parameters

dist_know_el %>%
  ggplot() +
    geom_point(aes(age, odd)) 

dist_know_el %>%
  ggplot() +
    geom_point(aes(age, log_odd))

#### Logit Model ####

dat %<>%
  mutate(age_new = age - 1)

mod_1 <- 
  dat %>%
  as.data.frame() %>%
  {glm(know_el ~ age_new, data = ., family = "binomial")}

dist_know_el %>%
  mutate(pred = predict(mod_1, 
    newdata = tibble(age_new = seq(5) - 1))) %>%
  ggplot() +
    geom_point(aes(age_new, log_odd)) +
    geom_line(aes(age_new, pred), color = "red")

#### Mis-Specification Analysis ####

dat %<>%
  mutate(age_new_1 = ifelse(age_new == 1, 1, 0)) %>%
  mutate(age_new_2 = ifelse(age_new == 2, 1, 0)) %>%
  mutate(age_new_3 = ifelse(age_new == 3, 1, 0)) %>%
  mutate(age_new_4 = ifelse(age_new == 4, 1, 0))

mod_2 <-
  dat %>%
  as.data.frame() %>%
  {glm(know_el ~ age_new_1 + age_new_2 + age_new_3 + age_new_4,
    data = ., family = "binomial")}

summary(mod_2)

result_lmtest <- 
  lmtest::lrtest(mod_1, mod_2)  # mod_1 is nested in mod_2

## Log likelihood ratio test by hand
(lr <- 2 * (result_lmtest$LogLik[2] - result_lmtest$LogLik[1]))
(critical_value <- qchisq(0.95, 3, lower.tail = TRUE, log.p = FALSE))
(p_val <- pchisq(lr, 3, lower.tail = F, log.p = F))
(lr <= critical_value)
