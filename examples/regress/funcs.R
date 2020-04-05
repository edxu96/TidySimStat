

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


kable_latex <- function(ti){
  ti %>%
    mutate_if(is.numeric, format, digits = 2) %>%
    kable("latex", booktabs = T, linesep = "") %>%
    kable_styling(full_width = F)
}


kable_inline <- function(ti){
  ti %>%
    mutate_if(is.numeric, format, digits = 4) %>%
    # mutate_if(is.numeric, round, 4) %>%
    kable() %>%
    kable_styling(full_width = F, 
      bootstrap_options = c("condensed", "responsive"))
}


tab_tidy <- function(model, whe_latex){
  if(missing(whe_latex)){whe_latex <- F}
  
  ti <-
    model %>% 
    tidy() %>%
    mutate(p.r.squared = quiet(lmSupport::modelEffectSizes(model))$
      Effects[,3])
    
  if(whe_latex){
    kable_latex(ti)
  } else {
    kable_inline(ti)
  }
}


tab_ti <- function(ti, whe_latex){
  if(missing(whe_latex)){whe_latex = F}
  
  if(whe_latex){
    kable_latex(ti)
  } else {
    kable_inline(ti)
  }
}


#' Perform Likelihood Test
#' @author Edward J. Xu
#' @description If `if_reject` is true, the hypothesis of restricted model is
#'   rejected. So the restricted model cannot be kept.
test_lik <- function(origin, restrict, prob){
  if(missing(prob)){prob = 0.05}
  
  stat <- - 2 * (logLik(restrict)[1] - logLik(origin)[1])
  
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
    whi = "Jarque-Bera", stat = stat, df1 = df1, df2 = nrow(dat) - df1,  
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


#' To mute the output of operation `x`
#' @author Hadley Wickham
quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 
