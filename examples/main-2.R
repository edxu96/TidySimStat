## Assign: Ecnometrics
## Edward J. Xu
## Mar 22, 2020
rm(list = ls())
setwd("~/GitHub/TidySimStat/examples")
library(tidyverse)
library(magrittr)
library(lmtest)
library(corrr)
library(broom)
library(tseries)

#### Data ####
set.seed(6)
dat <- 
  read_csv("./data/recs.csv") %>%
  slice(sample(nrow(.), 300)) %>%
  mutate(y = log(KWH / NHSLDMEM)) %>%
  select(y, x2 = NHSLDMEM, x3 = EDUCATION, x4 = MONEYPY, x5 = HHSEX, 
    x6 = HHAGE, x7 = ATHOME) %>%
  mutate_at(seq(2, 7), as.integer)  # make continuous variables discrete

#### Correlation ####

dat %>%
  cor() %>%
  as_cordf() %>%
  stretch() %>%
  filter(y == "y" & x != "y")

dat %>%
  ggplot(aes(x2, y, group = cut_width(x2, 1))) +
  geom_boxplot()

dat %>%
  ggplot(aes(x6, y, group = cut_width(x6, 5))) +
  geom_boxplot()

#### Regression Model using X2 ####

mod_1 <- 
  dat %>% as.data.frame() %>%
  {lm(y ~ x2, data = .)}

mod_1 %>% summary()

mod_2 <- 
  dat %>%
  mutate(x1 = 1, x21 = x2 - mean(.$x2)) %>%
  select(y, x1, x21)  %>%
  as.data.frame() %>%
  {lm(y ~ x1 + x21, data = .)}

mod_2 %>% summary()
mean(dat$y)

####

mod_3 <-
  dat %>%
  as.data.frame() %>%
  {lm(y ~ 1, data = .)}

mod_3 %>% summary()

anova(mod_3, mod_1)

#### JB-Test ####

mod_1$residuals %>% 
  tseries::jarque.bera.test()%>%  
  {(.$p.value <= qchisq(0.95, 2, lower.tail = TRUE, log.p = FALSE))}

dat %>%
  filter(x2 == 1 | x2 == 3 | x2 == 5 | x2 == 7) %>%
  ggplot() + 
    geom_freqpoly(aes(y)) +
    facet_grid(rows = vars(x2))

mod_1$residuals %>% 
  qqPlot()

par(mfrow = c(2, 2), oma = c(0, 0, 0, 0))
par(mfrow = c(1, 1))
plot(mod_1)

#### White's Test

mod_resi2 <-
  dat %>%
  mutate(resi2 = mod_1$residuals^2) %>%
  {lm(resi2 ~ x2, data = .)}  #    + I(x2^2)

mod_resi2 %>% summary()
r.squared <- summary(mod_resi2)$r.squared

( (r.squared / 1) / (1 - r.squared) / 299 )

mod_1 %>% 
  bptest(data = dat) %>%  # White's Test  ~ x2 + I(x2^2), 
  glance() %>%
  {(.$p.value <= qchisq(0.95, 2, lower.tail = TRUE, log.p = FALSE))}

#### ####

mod_1 %>%
  reset(data = dat) %>%  
  {(.$p.value <= qchisq(0.95, 2, lower.tail = TRUE, log.p = FALSE))}



# library(moments)
# library(nortest)
# library(e1071)
library(car)
x <- rnorm(250,10,1)
qqnorm(x)
qqline(x)
probplot(x, qdist=qnorm)
qqPlot(x)
