

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


#' To mute the output of operation `x`
#' @author Hadley Wickham
quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 
