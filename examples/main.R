## Assign: Ecnometrics
## Edward J. Xu
## Mar 22, 2020
setwd("~/GitHub/TidySimStat/examples")
library(tidyverse)

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
  mutate(log_odd = log(odd))

dist_know_el %>%
  ggplot() +
    geom_point(aes(age, odd)) 

dist_know_el %>%
  ggplot() +
    geom_point(aes(age, log_odd))

mod_1 <- 
  lm(log_odd ~ age, data = dist_know_el)

dist_know_el %>%
  mutate(pred = predict(mod_1, newdata = tibble(age = seq(5)))) %>%
  gather(log_odd, pred, key = whe_pred, value = log_odd) %>%
  ggplot() +
    geom_line(aes(age, log_odd, color = whe_pred))


