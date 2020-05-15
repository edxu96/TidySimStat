## for: GitHub/edxu96/TidySimStat
## author: Edward J. Xu
## May 15, 2020

## Data
tsi_fulton <- read_csv("~/GitHub/TidySimStat/data/Fulton.csv") %>%
  # mutate(p = exp(LogPrice)) %>%
  mutate(t = ymd(Date)) %>%
  mutate(p.log = LogPrice) %>%
  mutate(i = row_number()) %>%
  select(i, t, p.log) %>%
  as_tsibble(index = i)

## PSMs
mods_fulton <- list()

mods_fulton[[1]] <-
  tsi_fulton %>%
  model(fable::ARIMA(p.log ~ 1 + pdq(1, 0, 0)))

mods_fulton[[2]] <-
  tsi_fulton %>%
  model(fable::ARIMA(p.log ~ 1 + pdq(0, 0, 0)))
