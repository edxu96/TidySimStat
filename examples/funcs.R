

collect_glance <- function(results, model, idx){
  row_new <- 
    model %>%
    glance() %>%
    mutate(index = idx)
  
  results %<>%
    dplyr::filter(index != idx) %>%
    bind_rows(row_new)
  
  return(results)
}


new_results <- function(model, idx){
  results <- model %>%
    glance() %>%
    mutate(index = idx) %>%
    dplyr::select(index, r.squared, adj.r.squared, sigma, statistic, p.value, 
      df, logLik, AIC, BIC, deviance, df.residual)
  
  return(results)
}


#' Perform Jarque-Bera test
#' @author Edward J. Xu
#' @description If `if_accept` is true, the model is accepted.
test_jb <- function(mod, dat, prob){
  if(missing(prob)){prob = 0.05}
  
  stat_skew <- 
    mod %>%
    residuals() %>%
    propagate::skewness() %>%
    {.^2 * nrow(dat) / 6}
  
  stat_kurt <- 
    mod %>%
    residuals() %>%
    propagate::kurtosis() %>%
    {.^2 * nrow(dat) / 24}
  
  stat <- stat_skew + stat_kurt
    
  df1 <- 2
  p_value <- 
    stat %>%
    {1 - pchisq(., df1)}
  
  results <- tibble(
    method = "Jarque-Bera", stat = stat, df1 = df1, df2 = nrow(dat) - df1,  
    p_value = p_value,prob = prob, if_accept = {p_value <= prob}, 
    if_pass = {p_value >= prob}
  )
  
  return(results)
}


#' Perform White's test
#' @author Edward J. Xu
#' @description If `if_accept` is true, the null hypothesis is accepted.
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
    method = "White", stat = stat, df1 = df1, df2 = nrow(dat) - df1,  
    p_value = p_value,prob = prob, if_accept = {p_value <= prob}, 
    if_pass = {p_value >= prob}
  )

  return(results)
}


#' Perform RESET test
#' @author Edward J. Xu
#' @description If `if_accept` is true, the null hypothesis is accepted.
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
    method = "RESET", stat = stat, df1 = df1, df2 = nrow(dat) - df1,  
    p_value = p_value,prob = prob, if_accept = {p_value <= prob}, 
    if_pass = {p_value >= prob}
    )

  return(results)
}


#' To mute the output of operation `x`
#' @author Hadley Wickham
quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 
