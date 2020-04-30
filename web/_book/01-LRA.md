---
editor_options:
  chunk_output_type: console
---

# (PART) Statistics {-}

# Linear Regression Analysis (LRA) {#LRA}



Following packages and functions are used in this chapter:


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
library(car)
library(perturb)
source("../src/funcs.R")
source("../src/tests.R")
```

The data set is defined as follows based on file `recs.csv`:


```r
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
```

The dataset `delivery` is from [@montgomery2012introduction]:


```r
dat_delivery <- 
  readxl::read_xls("../data/delivery.xls", col_names = c("i", "time", "case",
    "dist"), skip = 1)
```

The dataset `acetylene` is from [@montgomery2012introduction]:


```r
dat_acetylene <-
  readxl::read_xls("../data/acetylene.xls", col_names = c("i", "p", "t_raw",
    "h_raw", "c_raw"), skip = 1) %>%
  mutate(t = (t_raw - 1212.5) / 80.623) %>%
  mutate(h = (h_raw - 12.44) / 5.662) %>%
  mutate(c = (c_raw - 0.0403) / 0.03164) %>%
  select(i, p, t, h, c)
```

## To-Learn

- [x] Confidence Interval
- [x] MSA
- [ ] Likelihood Ratio Test
- [ ] ANOVA
- [ ] Orthogonalization



## Visualization

The first 5 rows of the dat_recsa set used can be visualized:

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

### Box Plot

For each level of `x2` a box indicating three quantiles (25%, 50%, 75%) of `y` is given. It shows that there is a tendency for `y` to decrease with `x2` by looking at the median. The sizes of different boxes seem to vary with different values of `x2`. Besides, there are many observations when `x2` is small. But it is assumed for now that the conditional variance is constant, which will be tested section 4. Three dat_recsa points with extreme values `36`, `241` and `163` is discussed in sections 3 and 5.

<img src="01-LRA_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

The box plot of `y` by `x6` is given. It can be seen that the tendency is not strictly linear and the condition variance is not stable. So we will regress `y` on `x2` first and use `x6` as the second regressor in section 6.

<img src="01-LRA_files/figure-html/unnamed-chunk-8-1.png" width="672" style="display: block; margin: auto;" />

<!-- ```{r child = '../docs/LRA-MSA.Rmd'} -->
<!-- ``` -->



## Multiple Linear Regression {#multi}

### Standardization




### Multicollinearity Diagnosis {#multi-diag}

> In some situations the regressors are nearly perfectly linearly related, and in such cases the inferences based on the regression model can be misleading or erroneous. When there are near-linear dependencies among the regressors, the problem of multicollinearity is said to exist. [9, @montgomery2012introduction]

There are four primary sources of multicollinearity: [9, @montgomery2012introduction]

1. The data collection method employed
2. Constraints on the model or in the population
3. Model specification
4. An overdefined model

> To really establish causation, it is usually necessary to do an experiment in which the putative causative variable is manipulated to see what effect it has on the response. [@wood2017generalized :1.5.7]

#### (1) Covariance Matrix {-}

> Inspection of the covariance matrix is not sufficient for detecting anything more complex than pair- wise multicollinearity. [@montgomery2012introduction :9.4.1 Examination of the Correlation Matrix]

\BeginKnitrBlock{example}<div class="example"><span class="example" id="exm:unnamed-chunk-9"><strong>(\#exm:unnamed-chunk-9) </strong></span>It can be seen from the following covariance matrix that `y` is highly correlated to `x2`, `x6` and `x8`. Besides, `x3`-`x4`, `x2`-`x6`, `x4`-`x8` are high correlated.</div>\EndKnitrBlock{example}

<div class="figure" style="text-align: center">
<img src="01-LRA_files/figure-html/unnamed-chunk-10-1.png" alt="(ref:multi-1)" width="672" />
<p class="caption">(\#fig:unnamed-chunk-10)(ref:multi-1)</p>
</div>

(ref:multi-1) Heat map for the covariance matrix of `recs`.

#### (2) Variance Inflation Factors (VIF) {-}

The collinearity diagnostics in R require the packages “perturb” and “car”. The R code to generate the collinearity diagnostics for the delivery data is:


```
#>     case     dist 
#> 3.118474 3.118474
```

```
#> Condition
#> Index	Variance Decomposition Proportions
#>          intercept case  dist 
#> 1  1.000 0.041     0.015 0.016
#> 2  3.240 0.959     0.069 0.076
#> 3  6.378 0.000     0.915 0.909
```


```
#>       x2       x3       x4       x5       x6       x7       x8 
#> 1.360196 1.494892 1.853040 1.049184 1.383186 1.094072 1.559469
```

```
#> Condition
#> Index	Variance Decomposition Proportions
#>           intercept x2    x3    x4    x5    x6    x7    x8   
#> 1   1.000 0.001     0.003 0.002 0.003 0.006 0.001 0.005 0.002
#> 2   3.542 0.000     0.004 0.001 0.035 0.730 0.000 0.001 0.006
#> 3   4.554 0.000     0.026 0.002 0.100 0.112 0.013 0.472 0.001
#> 4   5.164 0.000     0.518 0.027 0.037 0.004 0.021 0.018 0.003
#> 5   6.768 0.022     0.011 0.004 0.256 0.048 0.147 0.486 0.011
#> 6   9.250 0.015     0.018 0.555 0.067 0.073 0.009 0.012 0.376
#> 7  10.622 0.011     0.007 0.225 0.498 0.000 0.206 0.005 0.598
#> 8  17.214 0.951     0.411 0.184 0.004 0.026 0.602 0.001 0.004
```

### Orthogonalization


<!-- ```{r child = '../docs/LRA-model.Rmd'} -->
<!-- ``` -->

<!-- ```{r child = '../docs/LRA-factor.Rmd'} -->
<!-- ``` -->



## Inference

### Confidence Interval

> By choosing a 95% coverage, we accept that with 5% confidence we reach the false conclusion that the true parameter is not in the confidence interval. [@hendry2007econometrics :2.3.1 Confidence intervals]




```
#>                    2.5 %       97.5 %
#> (Intercept)  8.156353087  8.918779651
#> x2          -0.345668390 -0.232993887
#> x3          -0.173798148 -0.029166657
#> x4          -0.015521841  0.063752184
#> x5          -0.140484745  0.133522728
#> x6          -0.001040888  0.008468877
#> x7          -0.028330570  0.039288527
#> x8           0.041431470  0.095149773
```


### Likelihood Ratio Test




### Signed Likelihood Ratio Test
