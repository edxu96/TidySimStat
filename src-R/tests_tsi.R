
#' Perform Jarque-Bera test for `tsibble` objects
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis is rejected. Then
#'   the assumption is not justified.
test_jb_tsi <- function(mod, prob){
  if(missing(prob)){prob = 0.05}

  n <- mod %>% fitted() %>% nrow()

  stat_skew <- mod %>%
    residuals() %>%
    {.$.resid} %>%
    propagate::skewness() %>%
    {.^2 * n / 6}

  stat_kurt <- mod %>%
    residuals() %>%
    {.$.resid} %>%
    propagate::kurtosis() %>%
    {.^2 * n / 24}

  stat <- stat_skew + stat_kurt

  df1 <- 2
  p_value <-
    stat %>%
    {1 - pchisq(., df1)}

  results <- tibble(
    whi = "Jarque-Bera", stat = stat, df1 = df1, df2 = n - df1,
    p_value = p_value,prob = prob, # if_accept = {p_value <= prob},
    if_reject = {p_value <= prob}
  )

  return(results)
}


#' Perform Likelihood Test
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis of restricted model is
#'   rejected. So the restricted model cannot be kept.
test_llr_tsi <- function(origin, restrict, prob){
  n <- origin %>% stats::fitted() %>% nrow()  # number of observations
  n_check <- restrict %>% stats::fitted() %>% nrow()
  if(n != n_check){
    warning("The numbers of observations in two models are not the same.")
  }

  stat <- 2 * (glance(mods_fulton[[1]])$log_lik -
    glance(mods_fulton[[2]])$log_lik)

  df1 <- nrow(tidy(origin)) - nrow(tidy(restrict))
  if(df1 <= 0){
    warning("origin and restrict are wrong")
    df1 = - df1
    stat = - stat
  }

  results <- stat %>%
    test_stat("logLik", df1, n - df1)

  return(results)
}
