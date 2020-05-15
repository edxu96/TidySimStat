## for: GitHub/edxu96/TidySimStat
## author: Edward J. Xu
## May 15, 2020

## Data
dat_part <-
  read_csv("../data/part.csv") %>%
  dplyr::select(part = Part, educ = schooling)

## PSMs
mods_part <- list()
mods_part[[1]] <- dat_part %>%
  as.data.frame() %>%
  {glm(part ~ educ, data = ., family = "binomial")}
mods_part[[2]] <- dat_part %>%
  as.data.frame() %>%
  {glm(part ~ 1, data = ., family = "binomial")}
