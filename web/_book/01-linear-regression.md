# Linear Regression {#LR}


```r
rm(list = ls())
```

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



Different variables are summarized in the following table. `y`, the logarithm of averaged electricity consumption, is the variable that we are interested in. Specifically, The electricity consumption refers to the electricity usage of the house/studio where the respondent lives in 2015, measured in kilowatthours. The quantity is average by the number of household members in the house/studio. That way, it roughly represent the level of electricity consumption of the respondent. Other variables are discussion in the following table.

| Sym | Abbr       | Definition                              |
| --- | ---------- | --------------------------------------- |
| z   | KWH        | electricity consumption                 |
| y   | LKWH.pers  | logarithm of KWH/NHSLDMEM               |
| x2  | NHSLDMEM   | number of household members             |
| x3  | EDUCATION  | highest education completed             |
| x4  | MONEYPY    | annual gross household income last year |
| x5  | HHSEX      | gender                                  |
| x6  | HHAGE      | age                                     |
| x7  | ATHOME     | number of weekdays someone is at home   |
| x8  | TOTROOMS + | number of rooms (including bathrooms)   |

Note that `x8` is a variable indicating the number of rooms of the house/studio of the respondent. It equals the summation of `TOTROOMS`, `NCOMBATH` and `NHAFBATH` in the original data set. `x8` is not included in the initial analysis (sections 1 to 7). 

`x3`, the education level of the respondent, is considered as a continuous variable in this project for simplicity. The detailed definition of different levels is shown in the following table.

| Level | Definition                                  |
| ----- | ------------------------------------------- |
| 1     | Less than high school diploma or GED        |
| 2     | High school diploma or GED                  |
| 3     | Some college or Associate’s degree          |
| 4     | Bachelor’s degree (for example: BA, BS)     |
| 5     | Master’s, Professional, or Doctorate degree |

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

In this project, we want to develop a model associating the continuous variable, average electricity consumption, with other variables. We will start by visualizing correlations between variables. In particular, the two variables `x2` and `x6`, which highly correlate with `y` will be explored. The model regressing `y` on `x2` will be discussed in section 2. Four assumptions will be made, three of which will be tested in section 3-5 by Jarque-Bera test (normality), White’s test (homoskedasticity) and RESET test (functional form) respectively. According the test results and discussion in section 6, data point `36` is excluded. Then, in section 7, more regressors are introduced and three new models are established. The detail regarding how regressors interact with each other, namely causality, is discussed in section 8. Based on the understanding of the underlying mechanism, a nonlinear term and `x8` are included as new regressors. Two new models are estimated, based on the only model passing all tests in section 7. Finally, the model called `mods[[7]]` is chosen as the final for presentation and it is interpreted in section 10.


## 1. Data Visualization

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

<img src="01-linear-regression_files/figure-html/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />

For each level of `x2` a box indicating three quantiles (25%, 50%, 75%) of `y` is given. It shows that there is a tendency for `y` to decrease with `x2` by looking at the median. The sizes of different boxes seem to vary with different values of `x2`. Besides, there are many observations when `x2` is small. But it is assumed for now that the conditional variance is constant, which will be tested section 4. Three data points with extreme values `36`, `241` and `163` is discussed in sections 3 and 5. 

<img src="01-linear-regression_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

The box plot of `y` by `x6` is given. It can be seen that the tendency is not strictly linear and the condition variance is not stable. So we will regress `y` on `x2` first and use `x6` as the second regressor in section 6.

<img src="01-linear-regression_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />

## 2. Regress `y` on `x2`, Assumptions and Orthogonalization

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

## 3. Normality and Jarque-Bera Test of `mods[[1]]`

The following four plots can be used to check the plausibility of normality assumptions:

- The upper left plot shows residuals against fitted values of `mods[[1]]`. It is hard to trust indication the flat trending line because there are few data points with low fitted values. The variance seems to be stable when fitted values are high. The assumption of homoskedasticity is tested formally in section 4.
- Data points `36`, `241` and `163` are mentioned in all but the lower right plots. They are examined in section 6.
- The assumption of conditional normality looks reasonable according to the upper right Q-Q plot. A formal Jarque-Bera test is performed later this section to examine this assumption in a quantitative manner.

<img src="01-linear-regression_files/figure-html/unnamed-chunk-15-1.png" width="672" style="display: block; margin: auto;" />

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

  </tr>
</tbody>
</table>

## 4. Homoskedasticity and White's Test of `mods[[1]]`

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

## 5. Functional Form and RESET Test of `mods[[1]]`

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

## 6. Regress `y` on `x2` with `36` Data Point Excluded

`36`, `241` and `163` data points are mentioned in three plots regrading the analysis of residuals of `mods[[1]]` in section 3. According to the scatter plot in section 1, their values of `y` are too small compared to those with same values of `x2`. They seems to be well defined. 

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> index </th>
   <th style="text-align:left;"> y </th>
   <th style="text-align:left;"> x2 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 36 </td>
   <td style="text-align:left;"> 5.312 </td>
   <td style="text-align:left;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 163 </td>
   <td style="text-align:left;"> 7.054 </td>
   <td style="text-align:left;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 241 </td>
   <td style="text-align:left;"> 6.680 </td>
   <td style="text-align:left;"> 3 </td>
  </tr>
</tbody>
</table>

However, with just 8 other points when `x2` equals 6, data point `36` will have a huge impact on the model, so it is excluded in the following model `mods[[2]]`. That is, a new model is estimated with the same formula as `mods[[1]]` but the data set excluding data point `36`.


```
#> lm(formula = y ~ x2, data = .)
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
   <td style="text-align:left;"> 9.0101 </td>
   <td style="text-align:left;"> 0.07431 </td>
   <td style="text-align:left;"> 121.254 </td>
   <td style="text-align:left;"> 5.324e-255 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.2569 </td>
   <td style="text-align:left;"> 0.02612 </td>
   <td style="text-align:left;"> -9.832 </td>
   <td style="text-align:left;"> 6.208e-20 </td>
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
   <td style="text-align:left;"> 0.2456 </td>
   <td style="text-align:left;"> 0.243 </td>
   <td style="text-align:left;"> 0.6197 </td>
   <td style="text-align:left;"> 96.67 </td>
   <td style="text-align:left;"> 6.208e-20 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -280.2 </td>
   <td style="text-align:left;"> 566.4 </td>
   <td style="text-align:left;"> 577.5 </td>
   <td style="text-align:left;"> 114.1 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>

Compared with `mods[[1]]`, `mods[[2]]` has more accurate estimation. Besides, `mods[[2]]` passes all of the hypothesis tests. So data point `36` is exluded in the following models, and the corresponding new data set `dat_2` is used.

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
   <td style="text-align:left;"> 1.686 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 297 </td>
   <td style="text-align:left;"> 0.4304 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 1.986 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.1588 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

## 7. Models with More Regressors

### 7-1. Benchmark Model

`mods[[3]]` with `x2` and `x6` being regressors is a good model already and pass every test. It is chosen as the benchmark model after the discussion in subsection 7-4.


```
#> lm(formula = y ~ x2 + x6, data = dat_2)
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
   <td style="text-align:left;"> 8.522218 </td>
   <td style="text-align:left;"> 0.167008 </td>
   <td style="text-align:left;"> 51.029 </td>
   <td style="text-align:left;"> 1.015e-148 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.220207 </td>
   <td style="text-align:left;"> 0.028079 </td>
   <td style="text-align:left;"> -7.842 </td>
   <td style="text-align:left;"> 8.080e-14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> 0.007576 </td>
   <td style="text-align:left;"> 0.002331 </td>
   <td style="text-align:left;"> 3.249 </td>
   <td style="text-align:left;"> 1.290e-03 </td>
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
   <td style="text-align:left;"> 0.2715 </td>
   <td style="text-align:left;"> 0.2666 </td>
   <td style="text-align:left;"> 0.61 </td>
   <td style="text-align:left;"> 55.17 </td>
   <td style="text-align:left;"> 4.32e-21 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> -275 </td>
   <td style="text-align:left;"> 557.9 </td>
   <td style="text-align:left;"> 572.7 </td>
   <td style="text-align:left;"> 110.1 </td>
   <td style="text-align:left;"> 296 </td>
  </tr>
</tbody>
</table>


```r
results_test <- mods[[3]] %>% test_jb(dat_2)

results_test %<>%
  bind_rows(test_white(mods[[3]], dat_2, resi2 ~ x2 + x6 + I(x2^2) + I(x6^2),
    3)) %>%
  bind_rows(test_white(mods[[3]], dat_2, resi2 ~ x2 + x6 + I(x2^2) + I(x6^2) +
    I(x2 * x6), 6)) %>%
  bind_rows(test_reset(mods[[3]], dat_2))

results_test %>% tab_ti(F)
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
   <td style="text-align:left;"> 1.32474 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 296 </td>
   <td style="text-align:left;"> 0.7233 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 3.24389 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> 293 </td>
   <td style="text-align:left;"> 0.7777 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 0.04314 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.8355 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

### 7-2. Model with All Regressors

To construct `mods[[4]]`, all of the variables (excluding `x8`) are included. `mods[[4]]` can pass Jarque-Bera test and two White's tests, but cannot pass  RESET test.

\begin{table}[H]
\centering
\begin{tabular}{llllll}
\toprule
term & estimate & std.error & statistic & p.value & p.r.squared\\
\midrule
(Intercept) & 8.6009 & 0.1975 & 43.5 & 9.9e-130 & 0.86655\\
x2 & -0.2477 & 0.0289 & -8.6 & 6.0e-16 & 0.20110\\
x3 & -0.0835 & 0.0374 & -2.2 & 2.6e-02 & 0.01683\\
x4 & 0.0621 & 0.0189 & 3.3 & 1.1e-03 & 0.03567\\
x5 & -0.0216 & 0.0710 & -0.3 & 7.6e-01 & 0.00032\\
x6 & 0.0071 & 0.0024 & 3.0 & 3.0e-03 & 0.02980\\
x7 & 0.0158 & 0.0175 & 0.9 & 3.7e-01 & 0.00278\\
\bottomrule
\end{tabular}
\end{table}


```r
results_test <- mods[[4]] %>% test_jb(dat_2)

results_test %<>%
  bind_rows(test_white(mods[[4]], dat_2, resi2 ~ x2 + x3 + x4 + x5 + x6 + x7 + 
    I(x2^2) + I(x3^2) + I(x4^2) + I(x5^2) + I(x6^2) + I(x7^2), 7)) %>%
  bind_rows(test_white(mods[[4]], dat_2, resi2 ~ x2 + x3 + x4 + x5 + x6 + x7 + 
    I(x2^2) + I(x3^2) + I(x4^2) + I(x5^2) + I(x6^2) + I(x7^2) + I(x2 * x3) +
    I(x2 * x4) + I(x2 * x5) + I(x2 * x6) + I(x2 * x7) + I(x4 * x3) + 
    I(x5 * x3) + I(x6 * x3) + I(x3 * x7) + I(x4 * x5) + I(x4 * x6) + 
    I(x4 * x7) + I(x5 * x6) + I(x5 * x7) + I(x6 * x7), 28)) %>%
  bind_rows(test_reset(mods[[4]], dat_2))

results_test %>% tab_ti(F)
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
   <td style="text-align:left;"> 12.334 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> 292 </td>
   <td style="text-align:left;"> 0.09011 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 31.025 </td>
   <td style="text-align:left;"> 28 </td>
   <td style="text-align:left;"> 271 </td>
   <td style="text-align:left;"> 0.31598 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 4.103 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.04280 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> TRUE </td>
  </tr>
</tbody>
</table>

### 7-3. Likelihood Ratio Test

Likelihood ratio tests for restricting one parameter can be performed by using partial correlations. For example, to test the hypothesis that coefficient for `x5` is 0 in `mods[[4]]`, following calculation can be conducted. With `p_value` being 0.7581638, we cannot reject the hypothesis.


```r
lr_x5 <- - 299 * log(1 - 0.0003170) 
(1 - pchisq(lr_x5, 1))
```

```
#> [1] 0.7581638
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
   <td style="text-align:left;"> logLik </td>
   <td style="text-align:left;"> 0.09479 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 299 </td>
   <td style="text-align:left;"> 0.7582 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

Likelihood tests for restricting more than one parameter can be only performed by using values of log likelihood in the original and restricted models. For example, to test the hypothesis that coefficients for `x5` and `x7` are both 0 in `mods[[4]]`, following calculation can be conducted. We cannot reject the hypothesis according the function output.

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
   <td style="text-align:left;"> logLik </td>
   <td style="text-align:left;"> 0.9188 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.3378 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

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
   <td style="text-align:left;"> logLik </td>
   <td style="text-align:left;"> 0.824 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 299 </td>
   <td style="text-align:left;"> 0.364 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

The above three test statistics are related in an additive manner, so models with multiple regressors can be reduced in a step-wise procedure. During every step, partial correlations for regressors can be used as the indication of the next term to be reduced.


```
#> [1] TRUE
```

### 7-4. Automated Model Selection

Thus, `mods[[5]]` is determined by automated model selection using `mods[[4]]` with `stats::step` function. `mods[[5]]` can pass Jarque-Bera test and two White's tests, but cannot pass RESET test.


```
#> lm(formula = y ~ x2 + x3 + x4 + x6, data = dat_2)
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
   <td style="text-align:left;"> 8.602282 </td>
   <td style="text-align:left;"> 0.191431 </td>
   <td style="text-align:left;"> 44.937 </td>
   <td style="text-align:left;"> 1.003e-133 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.244215 </td>
   <td style="text-align:left;"> 0.028598 </td>
   <td style="text-align:left;"> -8.540 </td>
   <td style="text-align:left;"> 7.356e-16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x3 </td>
   <td style="text-align:left;"> -0.079886 </td>
   <td style="text-align:left;"> 0.036673 </td>
   <td style="text-align:left;"> -2.178 </td>
   <td style="text-align:left;"> 3.018e-02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x4 </td>
   <td style="text-align:left;"> 0.060276 </td>
   <td style="text-align:left;"> 0.018291 </td>
   <td style="text-align:left;"> 3.295 </td>
   <td style="text-align:left;"> 1.103e-03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> 0.007589 </td>
   <td style="text-align:left;"> 0.002297 </td>
   <td style="text-align:left;"> 3.304 </td>
   <td style="text-align:left;"> 1.070e-03 </td>
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
   <td style="text-align:left;"> 0.298 </td>
   <td style="text-align:left;"> 0.2885 </td>
   <td style="text-align:left;"> 0.6008 </td>
   <td style="text-align:left;"> 31.2 </td>
   <td style="text-align:left;"> 1.155e-21 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> -269.4 </td>
   <td style="text-align:left;"> 550.8 </td>
   <td style="text-align:left;"> 573 </td>
   <td style="text-align:left;"> 106.1 </td>
   <td style="text-align:left;"> 294 </td>
  </tr>
</tbody>
</table>


```r
results_test <- mods[[5]] %>% test_jb(dat_2)

results_test %<>%
  bind_rows(test_white(mods[[5]], dat_2, resi2 ~ x2 + x3 + x4 + x6 + I(x2^2) +
    I(x3^2) + I(x4^2) + I(x6^2), 5)) %>%
  bind_rows(test_white(mods[[5]], dat_2, resi2 ~ x2 + x3 + x4 + x6 + 
    I(x2^2) + I(x3^2) + I(x4^2) + I(x6^2) + I(x2 * x3) + I(x2 * x4) + 
    I(x2 * x6) + I(x4 * x3) + I(x6 * x3) +I(x4 * x6), 15)) %>%
  bind_rows(test_reset(mods[[5]], dat_2))

results_test %>% tab_ti(F)
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
   <td style="text-align:left;"> 10.051 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 294 </td>
   <td style="text-align:left;"> 0.07380 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 19.371 </td>
   <td style="text-align:left;"> 15 </td>
   <td style="text-align:left;"> 284 </td>
   <td style="text-align:left;"> 0.19742 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 3.898 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.04836 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> TRUE </td>
  </tr>
</tbody>
</table>

According to results of five models, though `mods[[4]]` and `mods[[5]]` have lower AIC, `mods[[3]]` is the one with all tests passed and lowst AIC. It is discussed intensively in subsection 8-1, and acts as the benchmark model in section 9. Besides, `mods[[3]]` has the lowest BIC.

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> index </th>
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
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 0.2611 </td>
   <td style="text-align:left;"> 0.2586 </td>
   <td style="text-align:left;"> 0.6309 </td>
   <td style="text-align:left;"> 105.30 </td>
   <td style="text-align:left;"> 2.352e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -286.5 </td>
   <td style="text-align:left;"> 579.0 </td>
   <td style="text-align:left;"> 590.1 </td>
   <td style="text-align:left;"> 118.6 </td>
   <td style="text-align:left;"> 298 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 0.2611 </td>
   <td style="text-align:left;"> 0.2586 </td>
   <td style="text-align:left;"> 0.6309 </td>
   <td style="text-align:left;"> 105.30 </td>
   <td style="text-align:left;"> 2.352e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -286.5 </td>
   <td style="text-align:left;"> 579.0 </td>
   <td style="text-align:left;"> 590.1 </td>
   <td style="text-align:left;"> 118.6 </td>
   <td style="text-align:left;"> 298 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 0.2715 </td>
   <td style="text-align:left;"> 0.2666 </td>
   <td style="text-align:left;"> 0.6100 </td>
   <td style="text-align:left;"> 55.17 </td>
   <td style="text-align:left;"> 4.320e-21 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> -275.0 </td>
   <td style="text-align:left;"> 557.9 </td>
   <td style="text-align:left;"> 572.7 </td>
   <td style="text-align:left;"> 110.1 </td>
   <td style="text-align:left;"> 296 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> 0.3002 </td>
   <td style="text-align:left;"> 0.2858 </td>
   <td style="text-align:left;"> 0.6020 </td>
   <td style="text-align:left;"> 20.87 </td>
   <td style="text-align:left;"> 2.372e-20 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> -269.0 </td>
   <td style="text-align:left;"> 553.9 </td>
   <td style="text-align:left;"> 583.5 </td>
   <td style="text-align:left;"> 105.8 </td>
   <td style="text-align:left;"> 292 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 0.2980 </td>
   <td style="text-align:left;"> 0.2885 </td>
   <td style="text-align:left;"> 0.6008 </td>
   <td style="text-align:left;"> 31.20 </td>
   <td style="text-align:left;"> 1.155e-21 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> -269.4 </td>
   <td style="text-align:left;"> 550.8 </td>
   <td style="text-align:left;"> 573.0 </td>
   <td style="text-align:left;"> 106.1 </td>
   <td style="text-align:left;"> 294 </td>
  </tr>
</tbody>
</table>

Additionally, `mods[[4]]` has the highest `r.squared` for including more regressors, but its `adj.r.squared` is penalized for that. The AIC and BIC are not low as well compared to those of `mods[[3]]` and `mods[[5]]`. 

## 8. Causality and Mediation

### 8-1. Causality of `x2`-`x6`

It can be seen from the following two models that `y` is highly correlated to `x2` and `x6` separately. Besides, according to `mods[[3]]`, `y` is highly correlated to `x2` and `x6` at the same time. 


```
#> lm(formula = y ~ x2, data = dat_2)
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
   <td style="text-align:left;"> 9.0101 </td>
   <td style="text-align:left;"> 0.07431 </td>
   <td style="text-align:left;"> 121.254 </td>
   <td style="text-align:left;"> 5.324e-255 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.2569 </td>
   <td style="text-align:left;"> 0.02612 </td>
   <td style="text-align:left;"> -9.832 </td>
   <td style="text-align:left;"> 6.208e-20 </td>
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
   <td style="text-align:left;"> 0.2456 </td>
   <td style="text-align:left;"> 0.243 </td>
   <td style="text-align:left;"> 0.6197 </td>
   <td style="text-align:left;"> 96.67 </td>
   <td style="text-align:left;"> 6.208e-20 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -280.2 </td>
   <td style="text-align:left;"> 566.4 </td>
   <td style="text-align:left;"> 577.5 </td>
   <td style="text-align:left;"> 114.1 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>


```
#> lm(formula = y ~ x6, data = dat_2)
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
   <td style="text-align:left;"> 7.58909 </td>
   <td style="text-align:left;"> 0.128574 </td>
   <td style="text-align:left;"> 59.02 </td>
   <td style="text-align:left;"> 4.109e-166 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> 0.01492 </td>
   <td style="text-align:left;"> 0.002342 </td>
   <td style="text-align:left;"> 6.37 </td>
   <td style="text-align:left;"> 7.192e-10 </td>
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
   <td style="text-align:left;"> 0.1202 </td>
   <td style="text-align:left;"> 0.1172 </td>
   <td style="text-align:left;"> 0.6692 </td>
   <td style="text-align:left;"> 40.57 </td>
   <td style="text-align:left;"> 7.192e-10 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -303.2 </td>
   <td style="text-align:left;"> 612.4 </td>
   <td style="text-align:left;"> 623.5 </td>
   <td style="text-align:left;"> 133 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>

It is reasonable to assume that people tend to have more accompanies as age increases after 18. Also, the following model proves the relationship between `x2` and `x6`. We can say that the effect of `x6` on `y` is mediated by `x2`. With `x6` affecting `y` as well, `x2` does not mediate `x6` completely. So `x2` and `x6` are both supposed to appear in the model for `y`. The mediation factor `x2` may affect `y` though other ways, which will be explored in section 10. Besides, we find that `x6` does not affect `y` in other ways in section 10.


```
#> lm(formula = x2 ~ x6, data = dat_2)
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
   <td style="text-align:left;"> 4.23752 </td>
   <td style="text-align:left;"> 0.242174 </td>
   <td style="text-align:left;"> 17.50 </td>
   <td style="text-align:left;"> 1.318e-47 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> -0.03335 </td>
   <td style="text-align:left;"> 0.004412 </td>
   <td style="text-align:left;"> -7.56 </td>
   <td style="text-align:left;"> 5.057e-13 </td>
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
   <td style="text-align:left;"> 0.1614 </td>
   <td style="text-align:left;"> 0.1586 </td>
   <td style="text-align:left;"> 1.261 </td>
   <td style="text-align:left;"> 57.15 </td>
   <td style="text-align:left;"> 5.057e-13 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -492.5 </td>
   <td style="text-align:left;"> 991 </td>
   <td style="text-align:left;"> 1002 </td>
   <td style="text-align:left;"> 471.9 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>

### 8-2. Causality of `x3`-`x4`

When taking `x3` and `x4` into consideration, the models assocating `y` with `x3` or `x4` both show no significance, though `x3` and `x4` are highly correlated. So neither `x3` nor `x4` should be included in the model.


```
#> lm(formula = x4 ~ x3, data = dat_2)
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
   <td style="text-align:left;"> 0.5103 </td>
   <td style="text-align:left;"> 0.3311 </td>
   <td style="text-align:left;"> 1.541 </td>
   <td style="text-align:left;"> 1.244e-01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x3 </td>
   <td style="text-align:left;"> 1.0462 </td>
   <td style="text-align:left;"> 0.1011 </td>
   <td style="text-align:left;"> 10.347 </td>
   <td style="text-align:left;"> 1.251e-21 </td>
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
   <td style="text-align:left;"> 0.265 </td>
   <td style="text-align:left;"> 0.2625 </td>
   <td style="text-align:left;"> 1.977 </td>
   <td style="text-align:left;"> 107.1 </td>
   <td style="text-align:left;"> 1.251e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -627.1 </td>
   <td style="text-align:left;"> 1260 </td>
   <td style="text-align:left;"> 1271 </td>
   <td style="text-align:left;"> 1161 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>


```
#> lm(formula = y ~ x3 + x4, data = dat_2)
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
   <td style="text-align:left;"> 8.324004 </td>
   <td style="text-align:left;"> 0.12011 </td>
   <td style="text-align:left;"> 69.3012 </td>
   <td style="text-align:left;"> 5.327e-185 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x3 </td>
   <td style="text-align:left;"> 0.004589 </td>
   <td style="text-align:left;"> 0.04261 </td>
   <td style="text-align:left;"> 0.1077 </td>
   <td style="text-align:left;"> 9.143e-01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x4 </td>
   <td style="text-align:left;"> 0.008583 </td>
   <td style="text-align:left;"> 0.02096 </td>
   <td style="text-align:left;"> 0.4094 </td>
   <td style="text-align:left;"> 6.825e-01 </td>
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
   <td style="text-align:left;"> 0.001031 </td>
   <td style="text-align:left;"> -0.005719 </td>
   <td style="text-align:left;"> 0.7143 </td>
   <td style="text-align:left;"> 0.1528 </td>
   <td style="text-align:left;"> 0.8584 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> -322.2 </td>
   <td style="text-align:left;"> 652.3 </td>
   <td style="text-align:left;"> 667.1 </td>
   <td style="text-align:left;"> 151 </td>
   <td style="text-align:left;"> 296 </td>
  </tr>
</tbody>
</table>


### 8-3. Causality of `x4`-`x8`

It can be seen that `y` is highly correlated to `x8`.


```
#> lm(formula = y ~ x8, data = dat_2)
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
   <td style="text-align:left;"> 7.99316 </td>
   <td style="text-align:left;"> 0.11394 </td>
   <td style="text-align:left;"> 70.152 </td>
   <td style="text-align:left;"> 6.738e-187 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x8 </td>
   <td style="text-align:left;"> 0.04606 </td>
   <td style="text-align:left;"> 0.01302 </td>
   <td style="text-align:left;"> 3.538 </td>
   <td style="text-align:left;"> 4.674e-04 </td>
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
   <td style="text-align:left;"> 0.04045 </td>
   <td style="text-align:left;"> 0.03722 </td>
   <td style="text-align:left;"> 0.6989 </td>
   <td style="text-align:left;"> 12.52 </td>
   <td style="text-align:left;"> 0.0004674 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -316.1 </td>
   <td style="text-align:left;"> 638.3 </td>
   <td style="text-align:left;"> 649.4 </td>
   <td style="text-align:left;"> 145.1 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>

Also, `x8` is highly related to `x4`, which makes sense, because people with more income tend to buy houses with more rooms.


```
#> lm(formula = x8 ~ x4, data = dat_2)
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
   <td style="text-align:left;"> 5.6150 </td>
   <td style="text-align:left;"> 0.29511 </td>
   <td style="text-align:left;"> 19.03 </td>
   <td style="text-align:left;"> 2.472e-53 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x4 </td>
   <td style="text-align:left;"> 0.6895 </td>
   <td style="text-align:left;"> 0.06741 </td>
   <td style="text-align:left;"> 10.23 </td>
   <td style="text-align:left;"> 3.108e-21 </td>
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
   <td style="text-align:left;"> 0.2605 </td>
   <td style="text-align:left;"> 0.258 </td>
   <td style="text-align:left;"> 2.679 </td>
   <td style="text-align:left;"> 104.6 </td>
   <td style="text-align:left;"> 3.108e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -717.9 </td>
   <td style="text-align:left;"> 1442 </td>
   <td style="text-align:left;"> 1453 </td>
   <td style="text-align:left;"> 2132 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>

However, from subsection 9.2 we already know that `y` is not highly correlated with `x4`, which is illustrated again by the following model. So we say that the effect of `x4` on `y` is completely mediated by `x8`. Though it makes sense that people with more income tend to consume more energy on average, the direct effect is completely mediated through `x8` and possibly other factors.


```
#> lm(formula = y ~ x8 + x4, data = dat_2)
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
   <td style="text-align:left;"> 8.01203 </td>
   <td style="text-align:left;"> 0.11446 </td>
   <td style="text-align:left;"> 69.999 </td>
   <td style="text-align:left;"> 3.249e-186 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x8 </td>
   <td style="text-align:left;"> 0.05730 </td>
   <td style="text-align:left;"> 0.01511 </td>
   <td style="text-align:left;"> 3.793 </td>
   <td style="text-align:left;"> 1.807e-04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x4 </td>
   <td style="text-align:left;"> -0.02976 </td>
   <td style="text-align:left;"> 0.02041 </td>
   <td style="text-align:left;"> -1.458 </td>
   <td style="text-align:left;"> 1.458e-01 </td>
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
   <td style="text-align:left;"> 0.04729 </td>
   <td style="text-align:left;"> 0.04085 </td>
   <td style="text-align:left;"> 0.6976 </td>
   <td style="text-align:left;"> 7.346 </td>
   <td style="text-align:left;"> 0.0007694 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> -315.1 </td>
   <td style="text-align:left;"> 638.2 </td>
   <td style="text-align:left;"> 653 </td>
   <td style="text-align:left;"> 144 </td>
   <td style="text-align:left;"> 296 </td>
  </tr>
</tbody>
</table>

## 9. `mods[[3]]` with extra terms

In `mods[[6]]`, `x2`, `x6` and `x8` are kept at the same time.


```
#> lm(formula = y ~ x2 + x6 + x8, data = dat_2)
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
   <td style="text-align:left;"> 8.305297 </td>
   <td style="text-align:left;"> 0.165172 </td>
   <td style="text-align:left;"> 50.283 </td>
   <td style="text-align:left;"> 1.003e-146 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.259198 </td>
   <td style="text-align:left;"> 0.027894 </td>
   <td style="text-align:left;"> -9.292 </td>
   <td style="text-align:left;"> 3.456e-18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> 0.004116 </td>
   <td style="text-align:left;"> 0.002328 </td>
   <td style="text-align:left;"> 1.768 </td>
   <td style="text-align:left;"> 7.804e-02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x8 </td>
   <td style="text-align:left;"> 0.060505 </td>
   <td style="text-align:left;"> 0.011495 </td>
   <td style="text-align:left;"> 5.264 </td>
   <td style="text-align:left;"> 2.724e-07 </td>
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
   <td style="text-align:left;"> 0.3341 </td>
   <td style="text-align:left;"> 0.3273 </td>
   <td style="text-align:left;"> 0.5842 </td>
   <td style="text-align:left;"> 49.33 </td>
   <td style="text-align:left;"> 7.192e-26 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> -261.5 </td>
   <td style="text-align:left;"> 533.1 </td>
   <td style="text-align:left;"> 551.6 </td>
   <td style="text-align:left;"> 100.7 </td>
   <td style="text-align:left;"> 295 </td>
  </tr>
</tbody>
</table>

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
   <td style="text-align:left;"> 3.922 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> 295 </td>
   <td style="text-align:left;"> 0.4167 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 9.740 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> 289 </td>
   <td style="text-align:left;"> 0.4636 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 2.120 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.1454 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

With the idea of diminishing effects of the number of household members in mind, it is natural to include the square of the household numbers. In addition, `x8` is included according to the discussion in subsection 8-3. Thus, `mods[[7]]` is estimated. Being insignificant, `x6` is excluded, beccause the effect of `x6` on `y` seems to be mediated compeletely by `x2` and `x2^2`.

\begin{table}[H]
\centering
\begin{tabular}{llllll}
\toprule
term & estimate & std.error & statistic & p.value & p.r.squared\\
\midrule
(Intercept) & 8.779 & 0.137 & 64.3 & 1.5e-175 & 0.933\\
x2 & -0.521 & 0.086 & -6.0 & 5.0e-09 & 0.110\\
x8 & 0.073 & 0.011 & 6.5 & 2.6e-10 & 0.127\\
I(x2\textasciicircum{}2) & 0.036 & 0.012 & 2.9 & 4.1e-03 & 0.028\\
\bottomrule
\end{tabular}
\end{table}

With number of observations being 299, the model is sensitive to exlusion of some term only if the partial correlation of that term is smaller than 0.01276551. That is, if `p.r.squared` of some term displayed above is smaller than 0.01276551, the hypothesis regaring the coefficient for that term in the likelihood ratio test would not be rejected. The value `0.01276551` is obtained according to the discussion in subsection 7-3. Besides, small `p.value`s indicate that terms cannot be excluded as well. 



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
   <td style="text-align:left;"> 2.28866 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 296 </td>
   <td style="text-align:left;"> 0.5147 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 2.36415 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> 293 </td>
   <td style="text-align:left;"> 0.8834 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 0.06767 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.7948 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

`mods[[7]]` has a lower AIC than `mods[[6]]` and `mods[[3]]`, so it is choosen as the final model for presentation and conclusion.

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> df </th>
   <th style="text-align:left;"> AIC </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 527.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 533.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> 557.9 </td>
  </tr>
</tbody>
</table>

## 10. Interpretation of `mods[[7]]`

### 10-1. Model Structure

The overall structure can be illustrated in the following figure. The income is correlated to the number of household memebers, which is probably caused by the correlation between numbers of people and rooms. Because those relations don't contribute to the interpretation of consumptions directly, they are omitted.

![Illustration of the model structure.](./images/1.png)

### 10-2. Regressors

Electricity consumption is highly correlated to the number of household members of the respondent. When there are not too many household members, with more members, the quantity of consumption decreases, probably due to the fact that people tend to share the kitchen. However, the effect diminishes gradually when there are many household members (around 5-8).

<img src="01-linear-regression_files/figure-html/unnamed-chunk-48-1.png" width="672" style="display: block; margin: auto;" />

Because `y` is the log of average electricity consumptions, the final relationship between electricity consumptions and numbers of household members and numbers of rooms are:

As for the effect of number of rooms on electricity consumptions, 

<img src="01-linear-regression_files/figure-html/unnamed-chunk-49-1.png" width="672" style="display: block; margin: auto;" />

### 10-3. Orthogonalization of Multiple Regressors


```r
mods[[8]] <-
  dat_2 %>%
  mutate(z1 = lm(x2 ~ 1)$residuals) %>%
  mutate(z2 = lm(x8 ~ x2 + 1)$residuals) %>%
  mutate(x2.2 = x2^2) %>%
  mutate(z3 = lm(x2.2 ~ x2 + x8 + 1)$residuals) %>%
  {lm(y ~ z1 + z2 + z3, data = .)}
```


```
#> lm(formula = y ~ z1 + z2 + z3, data = .)
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
   <td style="text-align:left;"> 8.37009 </td>
   <td style="text-align:left;"> 0.03349 </td>
   <td style="text-align:left;"> 249.911 </td>
   <td style="text-align:left;"> 0.000e+00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> z1 </td>
   <td style="text-align:left;"> -0.25686 </td>
   <td style="text-align:left;"> 0.02441 </td>
   <td style="text-align:left;"> -10.521 </td>
   <td style="text-align:left;"> 3.420e-22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> z2 </td>
   <td style="text-align:left;"> 0.06625 </td>
   <td style="text-align:left;"> 0.01093 </td>
   <td style="text-align:left;"> 6.060 </td>
   <td style="text-align:left;"> 4.145e-09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> z3 </td>
   <td style="text-align:left;"> 0.03563 </td>
   <td style="text-align:left;"> 0.01232 </td>
   <td style="text-align:left;"> 2.893 </td>
   <td style="text-align:left;"> 4.104e-03 </td>
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
   <td style="text-align:left;"> 0.3456 </td>
   <td style="text-align:left;"> 0.3389 </td>
   <td style="text-align:left;"> 0.5791 </td>
   <td style="text-align:left;"> 51.93 </td>
   <td style="text-align:left;"> 5.594e-27 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> -258.9 </td>
   <td style="text-align:left;"> 527.9 </td>
   <td style="text-align:left;"> 546.4 </td>
   <td style="text-align:left;"> 98.94 </td>
   <td style="text-align:left;"> 295 </td>
  </tr>
</tbody>
</table>

The intercept in `mods[[8]]` (8.37009) can be interpreted as the exptected value for an individual with average values of `x2`, `x8` and `I(x2^2)`, which can be verified by the prediction using `mods[[7]]`.


```r
( 8.77946 - 0.52071 * mean(dat_2$x2) + 0.07329 * mean(dat_2$x8) + 
  0.03563 * mean(dat_2$x2^2) ) - 8.37009 <= 1e-4
```

```
#> [1] TRUE
```

Since the standard errors in `mods[[8]]` are smaller than those in `mods[[7]]`, `mods[[8]]` is used to conduct inference. Particularly, `se` for `Intercept` is reduced by 75.48%, and `se`s for first two regressors are reduced by 71.75% and 2.41%. The estimations for the last term are exactly the same, which is expected.


```
#>                   2.5 %      97.5 %
#> (Intercept)  8.30417224  8.43600027
#> z1          -0.30490653 -0.20881311
#> z2           0.04473184  0.08775875
#> z3           0.01138835  0.05986556
```

To reduce average electricity consumptions, people are encouraged to live together in houses with fewer rooms.

<!-- ## 11. One-Sided t-Test of `mods[[1]]` -->

<!-- ```{r, echo=T} -->
<!-- mods[[1]] %>% -->
<!--   summary() %>% -->
<!--   {pt(coef(.)[2, 3], mods[[1]]$df, lower = FALSE)} %>% -->
<!--   {. <= qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)} -->
<!-- ``` -->


## 7. Models with More Regressors

### 7-1. Benchmark Model

`mods[[3]]` with `x2` and `x6` being regressors is a good model already and pass every test. It is chosen as the benchmark model after the discussion in subsection 7-4.


```
#> lm(formula = y ~ x2 + x6, data = dat_2)
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
   <td style="text-align:left;"> 8.522218 </td>
   <td style="text-align:left;"> 0.167008 </td>
   <td style="text-align:left;"> 51.029 </td>
   <td style="text-align:left;"> 1.015e-148 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.220207 </td>
   <td style="text-align:left;"> 0.028079 </td>
   <td style="text-align:left;"> -7.842 </td>
   <td style="text-align:left;"> 8.080e-14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> 0.007576 </td>
   <td style="text-align:left;"> 0.002331 </td>
   <td style="text-align:left;"> 3.249 </td>
   <td style="text-align:left;"> 1.290e-03 </td>
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
   <td style="text-align:left;"> 0.2715 </td>
   <td style="text-align:left;"> 0.2666 </td>
   <td style="text-align:left;"> 0.61 </td>
   <td style="text-align:left;"> 55.17 </td>
   <td style="text-align:left;"> 4.32e-21 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> -275 </td>
   <td style="text-align:left;"> 557.9 </td>
   <td style="text-align:left;"> 572.7 </td>
   <td style="text-align:left;"> 110.1 </td>
   <td style="text-align:left;"> 296 </td>
  </tr>
</tbody>
</table>


```r
results_test <- mods[[3]] %>% test_jb(dat_2)

results_test %<>%
  bind_rows(test_white(mods[[3]], dat_2, resi2 ~ x2 + x6 + I(x2^2) + I(x6^2),
    3)) %>%
  bind_rows(test_white(mods[[3]], dat_2, resi2 ~ x2 + x6 + I(x2^2) + I(x6^2) +
    I(x2 * x6), 6)) %>%
  bind_rows(test_reset(mods[[3]], dat_2))

results_test %>% tab_ti(F)
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
   <td style="text-align:left;"> 1.32474 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 296 </td>
   <td style="text-align:left;"> 0.7233 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 3.24389 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> 293 </td>
   <td style="text-align:left;"> 0.7777 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 0.04314 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.8355 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

### 7-2. Model with All Regressors

To construct `mods[[4]]`, all of the variables (excluding `x8`) are included. `mods[[4]]` can pass Jarque-Bera test and two White's tests, but cannot pass  RESET test.

\begin{table}[H]
\centering
\begin{tabular}{llllll}
\toprule
term & estimate & std.error & statistic & p.value & p.r.squared\\
\midrule
(Intercept) & 8.6009 & 0.1975 & 43.5 & 9.9e-130 & 0.86655\\
x2 & -0.2477 & 0.0289 & -8.6 & 6.0e-16 & 0.20110\\
x3 & -0.0835 & 0.0374 & -2.2 & 2.6e-02 & 0.01683\\
x4 & 0.0621 & 0.0189 & 3.3 & 1.1e-03 & 0.03567\\
x5 & -0.0216 & 0.0710 & -0.3 & 7.6e-01 & 0.00032\\
x6 & 0.0071 & 0.0024 & 3.0 & 3.0e-03 & 0.02980\\
x7 & 0.0158 & 0.0175 & 0.9 & 3.7e-01 & 0.00278\\
\bottomrule
\end{tabular}
\end{table}


```r
results_test <- mods[[4]] %>% test_jb(dat_2)

results_test %<>%
  bind_rows(test_white(mods[[4]], dat_2, resi2 ~ x2 + x3 + x4 + x5 + x6 + x7 + 
    I(x2^2) + I(x3^2) + I(x4^2) + I(x5^2) + I(x6^2) + I(x7^2), 7)) %>%
  bind_rows(test_white(mods[[4]], dat_2, resi2 ~ x2 + x3 + x4 + x5 + x6 + x7 + 
    I(x2^2) + I(x3^2) + I(x4^2) + I(x5^2) + I(x6^2) + I(x7^2) + I(x2 * x3) +
    I(x2 * x4) + I(x2 * x5) + I(x2 * x6) + I(x2 * x7) + I(x4 * x3) + 
    I(x5 * x3) + I(x6 * x3) + I(x3 * x7) + I(x4 * x5) + I(x4 * x6) + 
    I(x4 * x7) + I(x5 * x6) + I(x5 * x7) + I(x6 * x7), 28)) %>%
  bind_rows(test_reset(mods[[4]], dat_2))

results_test %>% tab_ti(F)
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
   <td style="text-align:left;"> 12.334 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> 292 </td>
   <td style="text-align:left;"> 0.09011 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 31.025 </td>
   <td style="text-align:left;"> 28 </td>
   <td style="text-align:left;"> 271 </td>
   <td style="text-align:left;"> 0.31598 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 4.103 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.04280 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> TRUE </td>
  </tr>
</tbody>
</table>

### 7-3. Likelihood Ratio Test

Likelihood ratio tests for restricting one parameter can be performed by using partial correlations. For example, to test the hypothesis that coefficient for `x5` is 0 in `mods[[4]]`, following calculation can be conducted. With `p_value` being 0.7581638, we cannot reject the hypothesis.


```r
lr_x5 <- - 299 * log(1 - 0.0003170) 
(1 - pchisq(lr_x5, 1))
```

```
#> [1] 0.7581638
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
   <td style="text-align:left;"> logLik </td>
   <td style="text-align:left;"> 0.09479 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 299 </td>
   <td style="text-align:left;"> 0.7582 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

Likelihood tests for restricting more than one parameter can be only performed by using values of log likelihood in the original and restricted models. For example, to test the hypothesis that coefficients for `x5` and `x7` are both 0 in `mods[[4]]`, following calculation can be conducted. We cannot reject the hypothesis according the function output.

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
   <td style="text-align:left;"> logLik </td>
   <td style="text-align:left;"> 0.9188 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.3378 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

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
   <td style="text-align:left;"> logLik </td>
   <td style="text-align:left;"> 0.824 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 299 </td>
   <td style="text-align:left;"> 0.364 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

The above three test statistics are related in an additive manner, so models with multiple regressors can be reduced in a step-wise procedure. During every step, partial correlations for regressors can be used as the indication of the next term to be reduced.


```
#> [1] TRUE
```

### 7-4. Automated Model Selection

Thus, `mods[[5]]` is determined by automated model selection using `mods[[4]]` with `stats::step` function. `mods[[5]]` can pass Jarque-Bera test and two White's tests, but cannot pass RESET test.


```
#> lm(formula = y ~ x2 + x3 + x4 + x6, data = dat_2)
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
   <td style="text-align:left;"> 8.602282 </td>
   <td style="text-align:left;"> 0.191431 </td>
   <td style="text-align:left;"> 44.937 </td>
   <td style="text-align:left;"> 1.003e-133 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.244215 </td>
   <td style="text-align:left;"> 0.028598 </td>
   <td style="text-align:left;"> -8.540 </td>
   <td style="text-align:left;"> 7.356e-16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x3 </td>
   <td style="text-align:left;"> -0.079886 </td>
   <td style="text-align:left;"> 0.036673 </td>
   <td style="text-align:left;"> -2.178 </td>
   <td style="text-align:left;"> 3.018e-02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x4 </td>
   <td style="text-align:left;"> 0.060276 </td>
   <td style="text-align:left;"> 0.018291 </td>
   <td style="text-align:left;"> 3.295 </td>
   <td style="text-align:left;"> 1.103e-03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> 0.007589 </td>
   <td style="text-align:left;"> 0.002297 </td>
   <td style="text-align:left;"> 3.304 </td>
   <td style="text-align:left;"> 1.070e-03 </td>
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
   <td style="text-align:left;"> 0.298 </td>
   <td style="text-align:left;"> 0.2885 </td>
   <td style="text-align:left;"> 0.6008 </td>
   <td style="text-align:left;"> 31.2 </td>
   <td style="text-align:left;"> 1.155e-21 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> -269.4 </td>
   <td style="text-align:left;"> 550.8 </td>
   <td style="text-align:left;"> 573 </td>
   <td style="text-align:left;"> 106.1 </td>
   <td style="text-align:left;"> 294 </td>
  </tr>
</tbody>
</table>


```r
results_test <- mods[[5]] %>% test_jb(dat_2)

results_test %<>%
  bind_rows(test_white(mods[[5]], dat_2, resi2 ~ x2 + x3 + x4 + x6 + I(x2^2) +
    I(x3^2) + I(x4^2) + I(x6^2), 5)) %>%
  bind_rows(test_white(mods[[5]], dat_2, resi2 ~ x2 + x3 + x4 + x6 + 
    I(x2^2) + I(x3^2) + I(x4^2) + I(x6^2) + I(x2 * x3) + I(x2 * x4) + 
    I(x2 * x6) + I(x4 * x3) + I(x6 * x3) +I(x4 * x6), 15)) %>%
  bind_rows(test_reset(mods[[5]], dat_2))

results_test %>% tab_ti(F)
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
   <td style="text-align:left;"> 10.051 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 294 </td>
   <td style="text-align:left;"> 0.07380 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 19.371 </td>
   <td style="text-align:left;"> 15 </td>
   <td style="text-align:left;"> 284 </td>
   <td style="text-align:left;"> 0.19742 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 3.898 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.04836 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> TRUE </td>
  </tr>
</tbody>
</table>

According to results of five models, though `mods[[4]]` and `mods[[5]]` have lower AIC, `mods[[3]]` is the one with all tests passed and lowst AIC. It is discussed intensively in subsection 8-1, and acts as the benchmark model in section 9. Besides, `mods[[3]]` has the lowest BIC.

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> index </th>
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
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 0.2611 </td>
   <td style="text-align:left;"> 0.2586 </td>
   <td style="text-align:left;"> 0.6309 </td>
   <td style="text-align:left;"> 105.30 </td>
   <td style="text-align:left;"> 2.352e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -286.5 </td>
   <td style="text-align:left;"> 579.0 </td>
   <td style="text-align:left;"> 590.1 </td>
   <td style="text-align:left;"> 118.6 </td>
   <td style="text-align:left;"> 298 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 0.2611 </td>
   <td style="text-align:left;"> 0.2586 </td>
   <td style="text-align:left;"> 0.6309 </td>
   <td style="text-align:left;"> 105.30 </td>
   <td style="text-align:left;"> 2.352e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -286.5 </td>
   <td style="text-align:left;"> 579.0 </td>
   <td style="text-align:left;"> 590.1 </td>
   <td style="text-align:left;"> 118.6 </td>
   <td style="text-align:left;"> 298 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 0.2715 </td>
   <td style="text-align:left;"> 0.2666 </td>
   <td style="text-align:left;"> 0.6100 </td>
   <td style="text-align:left;"> 55.17 </td>
   <td style="text-align:left;"> 4.320e-21 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> -275.0 </td>
   <td style="text-align:left;"> 557.9 </td>
   <td style="text-align:left;"> 572.7 </td>
   <td style="text-align:left;"> 110.1 </td>
   <td style="text-align:left;"> 296 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> 0.3002 </td>
   <td style="text-align:left;"> 0.2858 </td>
   <td style="text-align:left;"> 0.6020 </td>
   <td style="text-align:left;"> 20.87 </td>
   <td style="text-align:left;"> 2.372e-20 </td>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:left;"> -269.0 </td>
   <td style="text-align:left;"> 553.9 </td>
   <td style="text-align:left;"> 583.5 </td>
   <td style="text-align:left;"> 105.8 </td>
   <td style="text-align:left;"> 292 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 0.2980 </td>
   <td style="text-align:left;"> 0.2885 </td>
   <td style="text-align:left;"> 0.6008 </td>
   <td style="text-align:left;"> 31.20 </td>
   <td style="text-align:left;"> 1.155e-21 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> -269.4 </td>
   <td style="text-align:left;"> 550.8 </td>
   <td style="text-align:left;"> 573.0 </td>
   <td style="text-align:left;"> 106.1 </td>
   <td style="text-align:left;"> 294 </td>
  </tr>
</tbody>
</table>

Additionally, `mods[[4]]` has the highest `r.squared` for including more regressors, but its `adj.r.squared` is penalized for that. The AIC and BIC are not low as well compared to those of `mods[[3]]` and `mods[[5]]`. 

## 8. Causality and Mediation

### 8-1. Causality of `x2`-`x6`

It can be seen from the following two models that `y` is highly correlated to `x2` and `x6` separately. Besides, according to `mods[[3]]`, `y` is highly correlated to `x2` and `x6` at the same time. 


```
#> lm(formula = y ~ x2, data = dat_2)
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
   <td style="text-align:left;"> 9.0101 </td>
   <td style="text-align:left;"> 0.07431 </td>
   <td style="text-align:left;"> 121.254 </td>
   <td style="text-align:left;"> 5.324e-255 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.2569 </td>
   <td style="text-align:left;"> 0.02612 </td>
   <td style="text-align:left;"> -9.832 </td>
   <td style="text-align:left;"> 6.208e-20 </td>
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
   <td style="text-align:left;"> 0.2456 </td>
   <td style="text-align:left;"> 0.243 </td>
   <td style="text-align:left;"> 0.6197 </td>
   <td style="text-align:left;"> 96.67 </td>
   <td style="text-align:left;"> 6.208e-20 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -280.2 </td>
   <td style="text-align:left;"> 566.4 </td>
   <td style="text-align:left;"> 577.5 </td>
   <td style="text-align:left;"> 114.1 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>


```
#> lm(formula = y ~ x6, data = dat_2)
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
   <td style="text-align:left;"> 7.58909 </td>
   <td style="text-align:left;"> 0.128574 </td>
   <td style="text-align:left;"> 59.02 </td>
   <td style="text-align:left;"> 4.109e-166 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> 0.01492 </td>
   <td style="text-align:left;"> 0.002342 </td>
   <td style="text-align:left;"> 6.37 </td>
   <td style="text-align:left;"> 7.192e-10 </td>
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
   <td style="text-align:left;"> 0.1202 </td>
   <td style="text-align:left;"> 0.1172 </td>
   <td style="text-align:left;"> 0.6692 </td>
   <td style="text-align:left;"> 40.57 </td>
   <td style="text-align:left;"> 7.192e-10 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -303.2 </td>
   <td style="text-align:left;"> 612.4 </td>
   <td style="text-align:left;"> 623.5 </td>
   <td style="text-align:left;"> 133 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>

It is reasonable to assume that people tend to have more accompanies as age increases after 18. Also, the following model proves the relationship between `x2` and `x6`. We can say that the effect of `x6` on `y` is mediated by `x2`. With `x6` affecting `y` as well, `x2` does not mediate `x6` completely. So `x2` and `x6` are both supposed to appear in the model for `y`. The mediation factor `x2` may affect `y` though other ways, which will be explored in section 10. Besides, we find that `x6` does not affect `y` in other ways in section 10.


```
#> lm(formula = x2 ~ x6, data = dat_2)
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
   <td style="text-align:left;"> 4.23752 </td>
   <td style="text-align:left;"> 0.242174 </td>
   <td style="text-align:left;"> 17.50 </td>
   <td style="text-align:left;"> 1.318e-47 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> -0.03335 </td>
   <td style="text-align:left;"> 0.004412 </td>
   <td style="text-align:left;"> -7.56 </td>
   <td style="text-align:left;"> 5.057e-13 </td>
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
   <td style="text-align:left;"> 0.1614 </td>
   <td style="text-align:left;"> 0.1586 </td>
   <td style="text-align:left;"> 1.261 </td>
   <td style="text-align:left;"> 57.15 </td>
   <td style="text-align:left;"> 5.057e-13 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -492.5 </td>
   <td style="text-align:left;"> 991 </td>
   <td style="text-align:left;"> 1002 </td>
   <td style="text-align:left;"> 471.9 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>

### 8-2. Causality of `x3`-`x4`

When taking `x3` and `x4` into consideration, the models assocating `y` with `x3` or `x4` both show no significance, though `x3` and `x4` are highly correlated. So neither `x3` nor `x4` should be included in the model.


```
#> lm(formula = x4 ~ x3, data = dat_2)
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
   <td style="text-align:left;"> 0.5103 </td>
   <td style="text-align:left;"> 0.3311 </td>
   <td style="text-align:left;"> 1.541 </td>
   <td style="text-align:left;"> 1.244e-01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x3 </td>
   <td style="text-align:left;"> 1.0462 </td>
   <td style="text-align:left;"> 0.1011 </td>
   <td style="text-align:left;"> 10.347 </td>
   <td style="text-align:left;"> 1.251e-21 </td>
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
   <td style="text-align:left;"> 0.265 </td>
   <td style="text-align:left;"> 0.2625 </td>
   <td style="text-align:left;"> 1.977 </td>
   <td style="text-align:left;"> 107.1 </td>
   <td style="text-align:left;"> 1.251e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -627.1 </td>
   <td style="text-align:left;"> 1260 </td>
   <td style="text-align:left;"> 1271 </td>
   <td style="text-align:left;"> 1161 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>


```
#> lm(formula = y ~ x3 + x4, data = dat_2)
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
   <td style="text-align:left;"> 8.324004 </td>
   <td style="text-align:left;"> 0.12011 </td>
   <td style="text-align:left;"> 69.3012 </td>
   <td style="text-align:left;"> 5.327e-185 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x3 </td>
   <td style="text-align:left;"> 0.004589 </td>
   <td style="text-align:left;"> 0.04261 </td>
   <td style="text-align:left;"> 0.1077 </td>
   <td style="text-align:left;"> 9.143e-01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x4 </td>
   <td style="text-align:left;"> 0.008583 </td>
   <td style="text-align:left;"> 0.02096 </td>
   <td style="text-align:left;"> 0.4094 </td>
   <td style="text-align:left;"> 6.825e-01 </td>
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
   <td style="text-align:left;"> 0.001031 </td>
   <td style="text-align:left;"> -0.005719 </td>
   <td style="text-align:left;"> 0.7143 </td>
   <td style="text-align:left;"> 0.1528 </td>
   <td style="text-align:left;"> 0.8584 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> -322.2 </td>
   <td style="text-align:left;"> 652.3 </td>
   <td style="text-align:left;"> 667.1 </td>
   <td style="text-align:left;"> 151 </td>
   <td style="text-align:left;"> 296 </td>
  </tr>
</tbody>
</table>


### 8-3. Causality of `x4`-`x8`

It can be seen that `y` is highly correlated to `x8`.


```
#> lm(formula = y ~ x8, data = dat_2)
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
   <td style="text-align:left;"> 7.99316 </td>
   <td style="text-align:left;"> 0.11394 </td>
   <td style="text-align:left;"> 70.152 </td>
   <td style="text-align:left;"> 6.738e-187 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x8 </td>
   <td style="text-align:left;"> 0.04606 </td>
   <td style="text-align:left;"> 0.01302 </td>
   <td style="text-align:left;"> 3.538 </td>
   <td style="text-align:left;"> 4.674e-04 </td>
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
   <td style="text-align:left;"> 0.04045 </td>
   <td style="text-align:left;"> 0.03722 </td>
   <td style="text-align:left;"> 0.6989 </td>
   <td style="text-align:left;"> 12.52 </td>
   <td style="text-align:left;"> 0.0004674 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -316.1 </td>
   <td style="text-align:left;"> 638.3 </td>
   <td style="text-align:left;"> 649.4 </td>
   <td style="text-align:left;"> 145.1 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>

Also, `x8` is highly related to `x4`, which makes sense, because people with more income tend to buy houses with more rooms.


```
#> lm(formula = x8 ~ x4, data = dat_2)
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
   <td style="text-align:left;"> 5.6150 </td>
   <td style="text-align:left;"> 0.29511 </td>
   <td style="text-align:left;"> 19.03 </td>
   <td style="text-align:left;"> 2.472e-53 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x4 </td>
   <td style="text-align:left;"> 0.6895 </td>
   <td style="text-align:left;"> 0.06741 </td>
   <td style="text-align:left;"> 10.23 </td>
   <td style="text-align:left;"> 3.108e-21 </td>
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
   <td style="text-align:left;"> 0.2605 </td>
   <td style="text-align:left;"> 0.258 </td>
   <td style="text-align:left;"> 2.679 </td>
   <td style="text-align:left;"> 104.6 </td>
   <td style="text-align:left;"> 3.108e-21 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -717.9 </td>
   <td style="text-align:left;"> 1442 </td>
   <td style="text-align:left;"> 1453 </td>
   <td style="text-align:left;"> 2132 </td>
   <td style="text-align:left;"> 297 </td>
  </tr>
</tbody>
</table>

However, from subsection 9.2 we already know that `y` is not highly correlated with `x4`, which is illustrated again by the following model. So we say that the effect of `x4` on `y` is completely mediated by `x8`. Though it makes sense that people with more income tend to consume more energy on average, the direct effect is completely mediated through `x8` and possibly other factors.


```
#> lm(formula = y ~ x8 + x4, data = dat_2)
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
   <td style="text-align:left;"> 8.01203 </td>
   <td style="text-align:left;"> 0.11446 </td>
   <td style="text-align:left;"> 69.999 </td>
   <td style="text-align:left;"> 3.249e-186 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x8 </td>
   <td style="text-align:left;"> 0.05730 </td>
   <td style="text-align:left;"> 0.01511 </td>
   <td style="text-align:left;"> 3.793 </td>
   <td style="text-align:left;"> 1.807e-04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x4 </td>
   <td style="text-align:left;"> -0.02976 </td>
   <td style="text-align:left;"> 0.02041 </td>
   <td style="text-align:left;"> -1.458 </td>
   <td style="text-align:left;"> 1.458e-01 </td>
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
   <td style="text-align:left;"> 0.04729 </td>
   <td style="text-align:left;"> 0.04085 </td>
   <td style="text-align:left;"> 0.6976 </td>
   <td style="text-align:left;"> 7.346 </td>
   <td style="text-align:left;"> 0.0007694 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> -315.1 </td>
   <td style="text-align:left;"> 638.2 </td>
   <td style="text-align:left;"> 653 </td>
   <td style="text-align:left;"> 144 </td>
   <td style="text-align:left;"> 296 </td>
  </tr>
</tbody>
</table>

## 9. `mods[[3]]` with extra terms

In `mods[[6]]`, `x2`, `x6` and `x8` are kept at the same time.


```
#> lm(formula = y ~ x2 + x6 + x8, data = dat_2)
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
   <td style="text-align:left;"> 8.305297 </td>
   <td style="text-align:left;"> 0.165172 </td>
   <td style="text-align:left;"> 50.283 </td>
   <td style="text-align:left;"> 1.003e-146 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x2 </td>
   <td style="text-align:left;"> -0.259198 </td>
   <td style="text-align:left;"> 0.027894 </td>
   <td style="text-align:left;"> -9.292 </td>
   <td style="text-align:left;"> 3.456e-18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x6 </td>
   <td style="text-align:left;"> 0.004116 </td>
   <td style="text-align:left;"> 0.002328 </td>
   <td style="text-align:left;"> 1.768 </td>
   <td style="text-align:left;"> 7.804e-02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x8 </td>
   <td style="text-align:left;"> 0.060505 </td>
   <td style="text-align:left;"> 0.011495 </td>
   <td style="text-align:left;"> 5.264 </td>
   <td style="text-align:left;"> 2.724e-07 </td>
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
   <td style="text-align:left;"> 0.3341 </td>
   <td style="text-align:left;"> 0.3273 </td>
   <td style="text-align:left;"> 0.5842 </td>
   <td style="text-align:left;"> 49.33 </td>
   <td style="text-align:left;"> 7.192e-26 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> -261.5 </td>
   <td style="text-align:left;"> 533.1 </td>
   <td style="text-align:left;"> 551.6 </td>
   <td style="text-align:left;"> 100.7 </td>
   <td style="text-align:left;"> 295 </td>
  </tr>
</tbody>
</table>

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
   <td style="text-align:left;"> 3.922 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> 295 </td>
   <td style="text-align:left;"> 0.4167 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 9.740 </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> 289 </td>
   <td style="text-align:left;"> 0.4636 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 2.120 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.1454 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

With the idea of diminishing effects of the number of household members in mind, it is natural to include the square of the household numbers. In addition, `x8` is included according to the discussion in subsection 8-3. Thus, `mods[[7]]` is estimated. Being insignificant, `x6` is excluded, beccause the effect of `x6` on `y` seems to be mediated compeletely by `x2` and `x2^2`.

\begin{table}[H]
\centering
\begin{tabular}{llllll}
\toprule
term & estimate & std.error & statistic & p.value & p.r.squared\\
\midrule
(Intercept) & 8.779 & 0.137 & 64.3 & 1.5e-175 & 0.933\\
x2 & -0.521 & 0.086 & -6.0 & 5.0e-09 & 0.110\\
x8 & 0.073 & 0.011 & 6.5 & 2.6e-10 & 0.127\\
I(x2\textasciicircum{}2) & 0.036 & 0.012 & 2.9 & 4.1e-03 & 0.028\\
\bottomrule
\end{tabular}
\end{table}

With number of observations being 299, the model is sensitive to exlusion of some term only if the partial correlation of that term is smaller than 0.01276551. That is, if `p.r.squared` of some term displayed above is smaller than 0.01276551, the hypothesis regaring the coefficient for that term in the likelihood ratio test would not be rejected. The value `0.01276551` is obtained according to the discussion in subsection 7-3. Besides, small `p.value`s indicate that terms cannot be excluded as well. 



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
   <td style="text-align:left;"> 2.28866 </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:left;"> 296 </td>
   <td style="text-align:left;"> 0.5147 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:left;"> 2.36415 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> 293 </td>
   <td style="text-align:left;"> 0.8834 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESET </td>
   <td style="text-align:left;"> 0.06767 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 298 </td>
   <td style="text-align:left;"> 0.7948 </td>
   <td style="text-align:left;"> 0.05 </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

`mods[[7]]` has a lower AIC than `mods[[6]]` and `mods[[3]]`, so it is choosen as the final model for presentation and conclusion.

<table class="table table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> df </th>
   <th style="text-align:left;"> AIC </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 527.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 533.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> 557.9 </td>
  </tr>
</tbody>
</table>

## 10. Interpretation of `mods[[7]]`

### 10-1. Model Structure

The overall structure can be illustrated in the following figure. The income is correlated to the number of household memebers, which is probably caused by the correlation between numbers of people and rooms. Because those relations don't contribute to the interpretation of consumptions directly, they are omitted.

![Illustration of the model structure.](./images/1.png)

### 10-2. Regressors

Electricity consumption is highly correlated to the number of household members of the respondent. When there are not too many household members, with more members, the quantity of consumption decreases, probably due to the fact that people tend to share the kitchen. However, the effect diminishes gradually when there are many household members (around 5-8).

<img src="01-linear-regression_files/figure-html/unnamed-chunk-80-1.png" width="672" style="display: block; margin: auto;" />

Because `y` is the log of average electricity consumptions, the final relationship between electricity consumptions and numbers of household members and numbers of rooms are:

As for the effect of number of rooms on electricity consumptions, 

<img src="01-linear-regression_files/figure-html/unnamed-chunk-81-1.png" width="672" style="display: block; margin: auto;" />

### 10-3. Orthogonalization of Multiple Regressors


```r
mods[[8]] <-
  dat_2 %>%
  mutate(z1 = lm(x2 ~ 1)$residuals) %>%
  mutate(z2 = lm(x8 ~ x2 + 1)$residuals) %>%
  mutate(x2.2 = x2^2) %>%
  mutate(z3 = lm(x2.2 ~ x2 + x8 + 1)$residuals) %>%
  {lm(y ~ z1 + z2 + z3, data = .)}
```


```
#> lm(formula = y ~ z1 + z2 + z3, data = .)
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
   <td style="text-align:left;"> 8.37009 </td>
   <td style="text-align:left;"> 0.03349 </td>
   <td style="text-align:left;"> 249.911 </td>
   <td style="text-align:left;"> 0.000e+00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> z1 </td>
   <td style="text-align:left;"> -0.25686 </td>
   <td style="text-align:left;"> 0.02441 </td>
   <td style="text-align:left;"> -10.521 </td>
   <td style="text-align:left;"> 3.420e-22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> z2 </td>
   <td style="text-align:left;"> 0.06625 </td>
   <td style="text-align:left;"> 0.01093 </td>
   <td style="text-align:left;"> 6.060 </td>
   <td style="text-align:left;"> 4.145e-09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> z3 </td>
   <td style="text-align:left;"> 0.03563 </td>
   <td style="text-align:left;"> 0.01232 </td>
   <td style="text-align:left;"> 2.893 </td>
   <td style="text-align:left;"> 4.104e-03 </td>
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
   <td style="text-align:left;"> 0.3456 </td>
   <td style="text-align:left;"> 0.3389 </td>
   <td style="text-align:left;"> 0.5791 </td>
   <td style="text-align:left;"> 51.93 </td>
   <td style="text-align:left;"> 5.594e-27 </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:left;"> -258.9 </td>
   <td style="text-align:left;"> 527.9 </td>
   <td style="text-align:left;"> 546.4 </td>
   <td style="text-align:left;"> 98.94 </td>
   <td style="text-align:left;"> 295 </td>
  </tr>
</tbody>
</table>

The intercept in `mods[[8]]` (8.37009) can be interpreted as the exptected value for an individual with average values of `x2`, `x8` and `I(x2^2)`, which can be verified by the prediction using `mods[[7]]`.


```r
( 8.77946 - 0.52071 * mean(dat_2$x2) + 0.07329 * mean(dat_2$x8) + 
  0.03563 * mean(dat_2$x2^2) ) - 8.37009 <= 1e-4
```

```
#> [1] TRUE
```

Since the standard errors in `mods[[8]]` are smaller than those in `mods[[7]]`, `mods[[8]]` is used to conduct inference. Particularly, `se` for `Intercept` is reduced by 75.48%, and `se`s for first two regressors are reduced by 71.75% and 2.41%. The estimations for the last term are exactly the same, which is expected.


```
#>                   2.5 %      97.5 %
#> (Intercept)  8.30417224  8.43600027
#> z1          -0.30490653 -0.20881311
#> z2           0.04473184  0.08775875
#> z3           0.01138835  0.05986556
```

To reduce average electricity consumptions, people are encouraged to live together in houses with fewer rooms.

<!-- ## 11. One-Sided t-Test of `mods[[1]]` -->

<!-- ```{r, echo=T} -->
<!-- mods[[1]] %>% -->
<!--   summary() %>% -->
<!--   {pt(coef(.)[2, 3], mods[[1]]$df, lower = FALSE)} %>% -->
<!--   {. <= qchisq(0.95, 1, lower.tail = TRUE, log.p = FALSE)} -->
<!-- ``` -->

