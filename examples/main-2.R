## Assign: Ecnometrics
## Edward J. Xu
## Mar 22, 2020
rm(list = ls())
setwd("~/GitHub/TidySimStat/examples")
library(tidyverse)
library(magrittr)
library(lmtest)

#### Data ####
set.seed(6)
dat <- 
  read_csv("./data/recs.csv") %>%
  slice(sample(nrow(.), 300)) %>%
  mutate(y = log(KWH / NHSLDMEM)) %>%
  select(y, x2 = NHSLDMEM, x3 = EDUCATION, x4 = MONEYPY, x5 = HHSEX, 
    x6 = HHAGE, x7 = ATHOME) %>%
  mutate_at(seq(2, 7), as.integer)  # make continuous variables discrete

dat %>%
  ggplot(aes(x2, y, group = cut_width(x2, 1))) +
    geom_boxplot()

dat %>%
  ggplot()

#### Regression Model using X2 ####

mod_1 <- 
  dat %>%
  as.data.frame() %>%
  {lm(y ~ x2, data = .)}

