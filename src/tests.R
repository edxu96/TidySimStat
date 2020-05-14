
test_stat <- function(stat, whi, df1, df2, prob){
  if(missing(prob)){prob = 0.05}

  p_value <- 1 - pchisq(stat, df1)

  results <- tibble(
    whi = whi, stat = stat, df1 = df1, df2 = df2,
    p_value = p_value, prob = prob, if_reject = (p_value <= prob)
  )
  return(results)
}


#' Perform Likelihood Test
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis of restricted model is
#'   rejected. So the restricted model cannot be kept.
test_llr <- function(origin, restrict, prob){
  n <- origin %>% stats::fitted() %>% length()  # number of observations
  n_check <- restrict %>% stats::fitted() %>% length()
  if(n != n_check){
    warning("The numbers of observations in two models are not the same.")
  }

  stat <- 2 * ( logLik(origin)[1] - logLik(restrict)[1] )

  df1 <- summary(origin)$df[1] - summary(restrict)$df[1]
  if(df1 <= 0){
    warning("origin and restrict are wrong")
    df1 = - df1
    stat = - stat
  }

  results <- stat %>%
    test_stat("logLik", df1, n - df1)

  return(results)
}


#' Perform Signed Likelihood Test
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis of restricted model is
#'   rejected. So the restricted model cannot be kept.
test_llr_sign <- function(origin, restrict, posi, prob){
  n <- origin %>% stats::fitted() %>% length()  # number of observations
  n_check <- restrict %>% stats::fitted() %>% length()
  if(n != n_check){
    warning("The numbers of observations in two models are not the same.")
  }

  posi = if_else(posi, 1, -1)

  results <- test_llr(origin, restrict) %>%
    {posi * sqrt(.$stat)} %>%
    test_stat("logLik-sign", 1, nrow(dat_part) - 1)

  return(results)
}


#' Perform Jarque-Bera test
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis is rejected. Then
#'   the assumption is not justified.
test_jb <- function(mod, dat, prob){
  if(missing(prob)){prob = 0.05}

  n <- mod %>% stats::fitted() %>% length()  # number of observations

  stat_skew <- mod %>%
    residuals() %>%
    propagate::skewness() %>%
    {.^2 * n / 6}

  stat_kurt <- mod %>%
    residuals() %>%
    propagate::kurtosis() %>%
    {.^2 * n / 24}

  stat <- stat_skew + stat_kurt

  df1 <- 2
  p_value <- 1 - pchisq(stat, df1)

  results <- tibble(
    whi = "Jarque-Bera", stat = stat, df1 = df1, df2 = n - df1,
    p_value = p_value,prob = prob, # if_accept = {p_value <= prob},
    if_reject = {p_value <= prob}
  )

  return(results)
}


#' Perform White's test
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis is rejected. Then
#'   the assumption is not justified.
test_white <- function(mod, dat, f, df1, prob){
  if(missing(prob)){prob = 0.05}

  dat %<>%
    mutate(resi2 = mod$residuals^2)

  stat <-
    lm(f, data = dat) %>%
    {summary(.)$r.squared} %>%
    {. * nrow(dat)}

  p_value <-
    stat %>%
    {1 - pchisq(., df1)}

  results <- tibble(
    whi = "White", stat = stat, df1 = df1, df2 = nrow(dat) - df1,
    p_value = p_value,prob = prob, # if_accept = {p_value <= prob},
    if_reject = {p_value <= prob}
  )

  return(results)
}


#' Perform RESET test
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis is rejected. Then
#'   the assumption is not justified.
test_reset <- function(mod, dat, prob){
  if(missing(prob)){prob = 0.05}

  f <-
    mod %>%
    formula() %>%
    update.formula(. ~ . + I(y_hat^2))

  mod_test <-
    dat %>%
    mutate(y_hat = fitted(mod)) %>%
    {lm(f, data = .)}

  stat <-
    mod_test %>%
    {quiet(lmSupport::modelEffectSizes(.))} %>%
    {.$Effects} %>%
    {.[nrow(.), 3] * (nrow(dat) - 1)}

  df1 <- 1
  p_value <-
    stat %>%
    {1 - pchisq(., df1)}

  results <- tibble(
    whi = "RESET", stat = stat, df1 = df1, df2 = nrow(dat) - df1,
    p_value = p_value,prob = prob, # if_accept = {p_value <= prob},
    if_reject = {p_value <= prob}
  )

  return(results)
}
