
#' Perform Likelihood Test
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis of restricted model is
#'   rejected. So the restricted model cannot be kept.
test_lik <- function(origin, restrict, prob){
  if(missing(prob)){prob = 0.05}
  
  stat <- 2 * ( logLik(origin)[1] - logLik(restrict)[1] )
  
  df1 <- summary(origin)$df[1] - summary(restrict)$df[1]
  if(df1 <= 0){
    warning("origin and restrict are wrong")
    df1 = - df1
    stat = - stat
  }
  
  p_value <- (1 - pchisq(stat, 1))
  
  results <- tibble(
    whi = "logLik", stat = stat, df1 = df1, df2 = nrow(dat) - df1,  
    p_value = p_value, prob = prob, # if_accept = {p_value <= prob}, 
    if_reject = {p_value <= prob}
  )
  return(results)
}


#' Perform Jarque-Bera test
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis is rejected. Then
#'   the assumption is not justified.
test_jb <- function(mod, dat, prob){
  if(missing(prob)){prob = 0.05}
  
  n <- mod %>% fitted() %>% nrow()  # number of observations
  
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