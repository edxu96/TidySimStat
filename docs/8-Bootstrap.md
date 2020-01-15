
## Exercise 8: Bootstrap to Analyze Pareto Simulation

Write a subroutine that takes as input a “data” vector of observed values, and which outputs the median as well as the bootstrap estimate of the variance of the median, based on `r = 100` bootstrap replicates.

Test the method: Simulate `n = 200` Pareto distributed random variates with `beta = 1` and `k = 1.05`. Compute the mean, the median, and the bootstrap estimate of the variance of the sample median.

Compare the precision of the estimated median with the precision of the estimated mean.

```
--------------------------------------------------------------------------------
Exercise 8: Bootstrap
--------------------------------------------------------------------------------
Set Parameters:
    beta = 1.000000 ;
    k = 1.050000 ;
    nObs = 200 ;
--------------------------------------------------------------------------------
Analysis of Simulated Pareto Distribution:
    mean = 5.096183 ;
    median = 1.862766 ;
    variance = 172.119351 ;
    ubMean = 29.096227 ;
    lbMean = -18.903861 ;
    ubVar = 156.742619 ;
    lbVar = 190.867438 ;
--------------------------------------------------------------------------------
Boostrap:
    nSet = 100 ;
    timeElapsed = 0.033649 ;
Analysis of vecMean from boostrap:
    mean = 5.182998 ;
    variance = 0.874796 ;
    ubMean = 5.356576 ;
    lbMean = 5.009419 ;
    ubVar = 0.768077 ;
    lbVar = 1.016229 ;
Analysis of vecMedian from boostrap:
    mean = 1.884051 ;
    variance = 0.016174 ;
    ubMean = 1.887261 ;
    lbMean = 1.880842 ;
    ubVar = 0.014201 ;
    lbVar = 0.018789 ;
Analysis of vecVar from boostrap:
    mean = 177.895556 ;
    variance = 9159.991066 ;
    ubMean = 1995.436511 ;
    lbMean = -1639.645399 ;
    ubVar = 8042.534860 ;
    lbVar = 10640.934960 ;
--------------------------------------------------------------------------------
Theoretically:
    mean = 21.000000 ;
    median = 1.935064 ;
    We cannot get theoretical value for variance ;
--------------------------------------------------------------------------------
```

|   Name    |  Method   |   Mean   | Theoretical |  lbMean  |  ubMean  | Variance |  lbVar   |  ubVar   |
|:---------:|:---------:|:--------:|:-----------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|  vecMean  | bootstrap | 5.182998 |  21.000000  | 5.009419 | 5.356576 | 0.874796 | 1.016229 | 0.768077 |
| vecMedian | bootstrap | 1.884051 |  1.935064   | 1.880842 | 1.887261 | 0.016174 | 0.018789 | 0.014201 |

|         Name          |   Mean   |  lbMean   |   ubMean   |  Median  |  Variance  |   lbVar    |   ubVar    |
|:---------------------:|:--------:|:---------:|:----------:|:--------:|:----------:|:----------:|:----------:|
| Simulated Pareto Dist | 5.096183 | 29.096227 | -18.903861 | 1.862766 | 172.119351 | 156.742619 | 190.867438 |

## Notes

- A technique for estimating the variance (etc) of an estimator
- Based on sampling from the empirical distribution.
- Non-parametric technique

we don't want want to assume anything specific about F
