## for: GitHub/edxu96/TidySimStat
## author: Edward J. Xu
## May 15, 2020

## Data
set.seed(6)
dat_recs <-
  read_csv("../data/recs.csv") %>%
  dplyr::slice(sample(nrow(.), 300)) %>%
  mutate(y = log(KWH / NHSLDMEM)) %>%
  mutate(x8 = TOTROOMS + NCOMBATH + NHAFBATH) %>%
  dplyr::select(y, x2 = NHSLDMEM, x3 = EDUCATION, x4 = MONEYPY, x5 = HHSEX,
                x6 = HHAGE, x7 = ATHOME, x8) %>%
  mutate_at(seq(2, 8), as.integer) %>%  # make continuous variables discrete
  mutate(x5 = - x5 + 2)

## PSMs
mods_recs <- list()
mods_recs[[1]] <- lm(y ~ x2 + x3 + x4 + x5 + x6 + x7, data = dat_recs)
mods_recs[[2]] <- lm(y ~ x2 + x3 + x4 + x6 + x7, data = dat_recs)
mods_recs[[3]] <- lm(y ~ x2 + x4 + x6 + x7, data = dat_recs)

mods_recs[[4]] <- lm(y ~ x2 + I(x2^2) + x8, data = dat_recs)
mods_recs[[5]] <-
  dat_recs %>%
  mutate(z1 = lm(x2 ~ 1)$residuals) %>%
  mutate(z2 = lm(x8 ~ x2 + 1)$residuals) %>%
  mutate(x2.2 = x2^2) %>%
  mutate(z3 = lm(x2.2 ~ x2 + x8 + 1)$residuals) %>%
  {lm(y ~ z1 + z2 + z3, data = .)}

mods_recs[[6]] <- lm(y ~ x2, data = dat_recs)
mods_recs[[7]] <-
  dat_recs %>%
  mutate(x1 = 1, x21 = x2 - mean(.$x2)) %>%
  dplyr::select(y, x1, x21) %>%
  {lm(y ~ x1 + x21, data = .)}
