
```
glm(formula = know_el ~ age_new, family = "binomial", data = .)

Deviance Residuals:
    Min       1Q   Median       3Q      Max  
-1.9629   0.5611   0.6760   0.8085   1.1221  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.13145    0.15045   0.874    0.382    
age_new      0.40943    0.05678   7.210 5.59e-13 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 1324.9  on 1199  degrees of freedom
Residual deviance: 1271.8  on 1198  degrees of freedom
AIC: 1275.8

Number of Fisher Scoring iterations: 4
```

```
glm(formula = know_el ~ age_new_1 + age_new_2 + age_new_3 + age_new_4,
    family = "binomial", data = .)

Deviance Residuals:
    Min       1Q   Median       3Q      Max  
-1.9364   0.5771   0.7147   0.7175   1.3141  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -0.3159     0.2223  -1.421 0.155311    
age_new_1     1.0458     0.2940   3.557 0.000375 ***
age_new_2     1.5415     0.2639   5.842 5.15e-09 ***
age_new_3     1.5504     0.2535   6.117 9.55e-10 ***
age_new_4     2.0242     0.2702   7.491 6.86e-14 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 1324.9  on 1199  degrees of freedom
Residual deviance: 1261.6  on 1195  degrees of freedom
AIC: 1271.6

Number of Fisher Scoring iterations: 4
```

```
Likelihood ratio test

Model 1: know_el ~ age_new
Model 2: know_el ~ age_new_1 + age_new_2 + age_new_3 + age_new_4
  #Df  LogLik Df  Chisq Pr(>Chisq)  
1   2 -635.91                       
2   5 -630.80  3 10.219    0.01679 *
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

General Advice
- Make a list for comments
