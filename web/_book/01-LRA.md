---
editor_options:
  chunk_output_type: console
---

# (PART) Statistics {-}

# Linear Regression Analysis {#LRA}



Following packages and functions are used in this project.


```r
## basic packages
library(knitr)
library(kableExtra)
library(tidyverse)
library(conflicted)
library(magrittr)
library(broom)
## paticular packages for this project
library(lmtest)
library(corrr)
library(tseries)
library(corrplot)
source("../src/funcs.R")
source("../src/tests.R")
```

The data set is defined as follows based on file `recs.csv`:


```r
set.seed(6)
dat <-
  read_csv("../data/recs.csv") %>%
  dplyr::slice(sample(nrow(.), 300)) %>%
  mutate(y = log(KWH / NHSLDMEM)) %>%
  mutate(x8 = TOTROOMS + NCOMBATH + NHAFBATH) %>%
  dplyr::select(y, x2 = NHSLDMEM, x3 = EDUCATION, x4 = MONEYPY, x5 = HHSEX,
    x6 = HHAGE, x7 = ATHOME, x8) %>%
  mutate_at(seq(2, 8), as.integer) %>%  # make continuous variables discrete
  mutate(x5 = - x5 + 2)
```



## Visualization

The first 5 rows of the data set used can be visualized:

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> y </th>
   <th style="text-align:left;"> x2 </th>
   <th style="text-align:left;"> x3 </th>
   <th style="text-align:left;"> x4 </th>
   <th style="text-align:left;"> x5 </th>
   <th style="text-align:left;"> x6 </th>
   <th style="text-align:left;"> x7 </th>
   <th style="text-align:left;"> x8 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 7.540 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 39 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 8.193 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 85 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 8.678 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 71 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 7.846 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 39 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 9.755 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 57 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 10 </td>
  </tr>
</tbody>
</table>

### Covariance Matrix

****

It can be seen that `y` is highly correlated to `x2` and `x6` according to the following table.

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> x </th>
   <th style="text-align:left;"> y </th>
   <th style="text-align:left;"> r </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> -0.51098 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x3 </td>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> 0.03410 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x4 </td>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> 0.04098 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x5 </td>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> -0.04260 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> 0.35346 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x7 </td>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> 0.03966 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x8 </td>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> 0.21329 </td>
  </tr>
</tbody>
</table>

It can be seen from the following covariance matrix that `y` is highly correlated to `x2`, `x6` and `x8`. Besides, `x3`-`x4`, `x2`-`x6`, `x4`-`x8` are high correlated, which will be discussed in section 9.

<img src="01-LRA_files/figure-html/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />

****

### Box Plot 

For each level of `x2` a box indicating three quantiles (25%, 50%, 75%) of `y` is given. It shows that there is a tendency for `y` to decrease with `x2` by looking at the median. The sizes of different boxes seem to vary with different values of `x2`. Besides, there are many observations when `x2` is small. But it is assumed for now that the conditional variance is constant, which will be tested section 4. Three data points with extreme values `36`, `241` and `163` is discussed in sections 3 and 5. 

<img src="01-LRA_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

The box plot of `y` by `x6` is given. It can be seen that the tendency is not strictly linear and the condition variance is not stable. So we will regress `y` on `x2` first and use `x6` as the second regressor in section 6.

<img src="01-LRA_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />





## Mis-Specification Analyis (MSA)



### Normality and Jarque-Bera Test of `mods[[1]]`

The following four plots can be used to check the plausibility of normality assumptions:

- The upper left plot shows residuals against fitted values of `mods[[1]]`. It is hard to trust indication the flat trending line because there are few data points with low fitted values. The variance seems to be stable when fitted values are high. The assumption of homoskedasticity is tested formally in section 4.
- Data points `36`, `241` and `163` are mentioned in all but the lower right plots. They are examined in section 6.
- The assumption of conditional normality looks reasonable according to the upper right Q-Q plot. A formal Jarque-Bera test is performed later this section to examine this assumption in a quantitative manner.

<img src="01-LRA_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />

The assumption of conditional normality is justified by JB test.

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> whi </th>
   <th style="text-align:left;"> stat </th>
   <th style="text-align:left;"> df1 </th>
   <th style="text-align:left;"> df2 </th>
   <th style="text-align:left;"> p_value </th>
   <th style="text-align:left;"> prob </th>
   <th style="text-align:left;"> if_reject </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Jarque-Bera </td>
   <td style="text-align:left;"> 4.326 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.115 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

### Homoskedasticity and White's Test of `mods[[1]]`

`mods[[1]]` cannot pass the White's test, which means the variances of residuals do vary with different values of `y`.


```r
mods[[1]] %>% test_white(dat, resi2 ~ x2 + I(x2^2), 2) %>% tab_ti(F)
```

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> whi </th>
   <th style="text-align:left;"> stat </th>
   <th style="text-align:left;"> df1 </th>
   <th style="text-align:left;"> df2 </th>
   <th style="text-align:left;"> p_value </th>
   <th style="text-align:left;"> prob </th>
   <th style="text-align:left;"> if_reject </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 6.028 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.04909 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> TRUE </td>
  </tr>
</tbody>
</table>

### Functional Form and RESET Test of `mods[[1]]`

`mods[[1]]` can pass RESET test.


```
#> Registered S3 methods overwritten by 'lme4':
#>   method                          from
#>   cooks.distance.influence.merMod car 
#>   influence.merMod                car 
#>   dfbeta.influence.merMod         car 
#>   dfbetas.influence.merMod        car
```

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> whi </th>
   <th style="text-align:left;"> stat </th>
   <th style="text-align:left;"> df1 </th>
   <th style="text-align:left;"> df2 </th>
   <th style="text-align:left;"> p_value </th>
   <th style="text-align:left;"> prob </th>
   <th style="text-align:left;"> if_reject </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 1.128 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 299 </td>
   <td style="text-align:left;"> 0.2883 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>




## Orthogonalization

### Regress `y` on `x2`, Assumptions and Orthogonalization

`mods[[1]]` is obtained by regressing `y` on `x2`.


```
#> lm(formula = y ~ x2, data = dat)
```

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> term </th>
   <th style="text-align:left;"> estimate </th>
   <th style="text-align:left;"> std.error </th>
   <th style="text-align:left;"> statistic </th>
   <th style="text-align:left;"> p.value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:left;"> 9.036 </td>
   <td style="text-align:left;"> 0.07526 </td>
   <td style="text-align:left;"> 120.06 </td>
   <td style="text-align:left;"> 2.214e-254 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.270 </td>
   <td style="text-align:left;"> 0.02631 </td>
   <td style="text-align:left;"> -10.26 </td>
   <td style="text-align:left;"> 2.352e-21 </td>
  </tr>
</tbody>
</table>

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> r.squared </th>
   <th style="text-align:left;"> adj.r.squared </th>
   <th style="text-align:left;"> sigma </th>
   <th style="text-align:left;"> statistic </th>
   <th style="text-align:left;"> p.value </th>
   <th style="text-align:left;"> df </th>
   <th style="text-align:left;"> logLik </th>
   <th style="text-align:left;"> AIC </th>
   <th style="text-align:left;"> BIC </th>
   <th style="text-align:left;"> deviance </th>
   <th style="text-align:left;"> df.residual </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 0.2611 </td>
   <td style="text-align:left;"> 0.2586 </td>
   <td style="text-align:left;"> 0.6309 </td>
   <td style="text-align:left;"> 105.3 </td>
   <td style="text-align:left;"> 2.352e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -286.5 </td>
   <td style="text-align:left;"> 579 </td>
   <td style="text-align:left;"> 590.1 </td>
   <td style="text-align:left;"> 118.6 </td>
   <td style="text-align:left;"> 298 </td>
  </tr>
</tbody>
</table>

By orthogonalizing `x2` with respect to constant 1. the following reparameterized model can be obtained.


```r
mods[[2]] <- 
  dat %>%
  mutate(x1 = 1, x21 = x2 - mean(.$x2)) %>%
  dplyr::select(y, x1, x21) %>%
  {lm(y ~ x1 + x21, data = .)}
```


```
#> lm(formula = y ~ x1 + x21, data = .)
```

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> term </th>
   <th style="text-align:left;"> estimate </th>
   <th style="text-align:left;"> std.error </th>
   <th style="text-align:left;"> statistic </th>
   <th style="text-align:left;"> p.value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:left;"> 8.36 </td>
   <td style="text-align:left;"> 0.03642 </td>
   <td style="text-align:left;"> 229.52 </td>
   <td style="text-align:left;"> 0.000e+00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x21 </td>
   <td style="text-align:left;"> -0.27 </td>
   <td style="text-align:left;"> 0.02631 </td>
   <td style="text-align:left;"> -10.26 </td>
   <td style="text-align:left;"> 2.352e-21 </td>
  </tr>
</tbody>
</table>

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> r.squared </th>
   <th style="text-align:left;"> adj.r.squared </th>
   <th style="text-align:left;"> sigma </th>
   <th style="text-align:left;"> statistic </th>
   <th style="text-align:left;"> p.value </th>
   <th style="text-align:left;"> df </th>
   <th style="text-align:left;"> logLik </th>
   <th style="text-align:left;"> AIC </th>
   <th style="text-align:left;"> BIC </th>
   <th style="text-align:left;"> deviance </th>
   <th style="text-align:left;"> df.residual </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 0.2611 </td>
   <td style="text-align:left;"> 0.2586 </td>
   <td style="text-align:left;"> 0.6309 </td>
   <td style="text-align:left;"> 105.3 </td>
   <td style="text-align:left;"> 2.352e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -286.5 </td>
   <td style="text-align:left;"> 579 </td>
   <td style="text-align:left;"> 590.1 </td>
   <td style="text-align:left;"> 118.6 </td>
   <td style="text-align:left;"> 298 </td>
  </tr>
</tbody>
</table>

The estimated regression coefficient for `x2` in `mods[[1]]` equals that for `x21` in `mods[[2]]`. That is, slopes in these two models are the same. The standard error of the intercept is reduced by 51.60 %.
