
# Regression Analysis

- Solve the masking problem when many packages are loaded with `conflicted` package. https://www.tidyverse.org/blog/2018/06/conflicted/

## 1. Data Visualization

Briefly describe the variables in Table 1. You can use tabulation, histograms, plots, cross-plots.

```
  x     y           r
  <chr> <chr>   <dbl>
1 x2    y     -0.432
2 x3    y      0.167
3 x4    y      0.0447
4 x5    y      0.150
5 x6    y      0.368
6 x7    y      0.0683
```

![](./images/2.png)

![](./images/3.png)

## 2. First Regression Model

Estimate a regression model of the log of KWH per person on a constant and numbers of household members.

```
lm(formula = y ~ x2, data = dat)

Residuals:
     Min       1Q   Median       3Q      Max
-2.10403 -0.41287  0.01591  0.46000  1.53154

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  9.03574    0.07526  120.06   <2e-16 ***
x2          -0.26998    0.02631  -10.26   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.6309 on 298 degrees of freedom
Multiple R-squared:  0.2611,	Adjusted R-squared:  0.2586
F-statistic: 105.3 on 1 and 298 DF,  p-value: < 2.2e-16
```

```
                 2.5 %     97.5 %
(Intercept)  8.8876236  9.1838480
x2          -0.3217532 -0.2182019
```

Show how you may obtain your slope estimate $\widehat{\beta}_{2}$ in Q2 based on the orthogonal reparameterization.

```
lm(formula = y ~ x1 + x21, data = .)

Residuals:
     Min       1Q   Median       3Q      Max
-2.10403 -0.41287  0.01591  0.46000  1.53154

Coefficients: (1 not defined because of singularities)
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  8.35989    0.03642  229.52   <2e-16 ***
x1                NA         NA      NA       NA    
x21         -0.26998    0.02631  -10.26   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.6309 on 298 degrees of freedom
Multiple R-squared:  0.2611,	Adjusted R-squared:  0.2586
F-statistic: 105.3 on 1 and 298 DF,  p-value: < 2.2e-16
```

```
                 2.5 %     97.5 %
(Intercept)  8.2882122  8.4315720
x1                  NA         NA
x21         -0.3217532 -0.2182019
```

## 3. Assumption of Normality and Jarque-Bera Test

Suppose (from now on) that the assumption of independence and the assumption of exogeneity of all regressors hold. We can then focus here on testing the assumption of normality and constant error variance.

Plot conditional histograms. How does the sample mean vary with $X$?

![](./images/4.png)

Jarque-Bera Test of `mod_1`: `True`

![](./images/7.png)

## 4. Assumption of Constant Conditional Variance and White's Test

White's Test of `mod_1`: `FALSE`

## 5.

Check for the presence of any extreme residuals (i.e. outliers), or small groups thereof. If present, try to assess the influence of these outliers on the two mis-specification tests above. Try to identify the outliers and investigate whether they are special/extraordinary with respect to the other variables in Table 1 (or more generally other variables in the dat2). Comment.

![](./images/6.png)

After remove data points 241, 163 and 36, `mod_4`:

```
lm(formula = y ~ x2, data = .)

Residuals:
     Min       1Q   Median       3Q      Max
-1.45726 -0.41179  0.00286  0.43826  1.52842

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  9.02886    0.07304  123.61   <2e-16 ***
x2          -0.25999    0.02565  -10.14   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.607 on 295 degrees of freedom
Multiple R-squared:  0.2584,	Adjusted R-squared:  0.2558
F-statistic: 102.8 on 1 and 295 DF,  p-value: < 2.2e-16
```

## 6.

Augment the model with the remaining variables in table 1. Call the augmented model. Perform the JB and White's test again. What are your conclusions now?



If your model is still mis-specified, you may consider adding other variables, and/or adding transformations of some of the variables in table 1 e.g. polynomial (say, squares and/or cubic) terms.

## RESET Test

Assumption of Functional Form and RESET Test

RESET Test of `mods[[1]]`: `FALSE`
