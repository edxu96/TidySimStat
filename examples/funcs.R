
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
