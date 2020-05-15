## for: GitHub/edxu96/TidySimStat
## author: Edward J. Xu
## May 15, 2020

## Data
dat_census <-
  read_csv("../data/census.csv") %>%
  mutate(wage_log = LwageW) %>%
  dplyr::select(educ, wage_log)

## PSMs
mods_census <- list()
mods_census[[1]] <- lm(wage_log ~ educ, data = dat_census)
mods_census[[2]] <- lm(wage_log ~ educ + I(educ^2), data = dat_census)
