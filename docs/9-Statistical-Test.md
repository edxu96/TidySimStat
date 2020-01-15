
## 1,  Chi-Square Test

```matlab
function testChiSquare(vecObs, vecExp, alpha)
% Perform Chi-Square Test
% Hypothesis 0: the simulated vecObs can represent vecExp from analytical result
% Warning: If the simulation produces count, vecObs should be count instead of probability
    fprintf('Perform Chi-Square Test: \n')
    fprintf('    alpha = %f ; \n', alpha)
    numClass = length(vecObs);
    vecResultTest = zeros(numClass, 1);
    for i = 1:numClass
        vecResultTest(i) = (vecObs(i) - vecExp(i))^2 / vecExp(i);
    end
    chiSquare = sum(vecResultTest);
    fprintf('    chiSquare = %f ;\n', chiSquare)
    pValue = 1 - chi2cdf(chiSquare, numClass - 1 - 0);
    fprintf('    pValue = %f ;\n', pValue)
    chiQuareCritical = chi2inv((1 - alpha), numClass - 1 - 0);
    fprintf('    chiQuareCritical = %f ;\n', chiQuareCritical)
    if chiSquare > chiQuareCritical
        fprintf('    Reject H0. \n')
    else
        fprintf('    Accept H0. \n')
    end
end
```

## Confidence Interval

```matlab
function [lb, ub] = calInterConf(vecResult, alpha)
% Calculate the Confidence Interval of vecResult
% default: alpha = 0.05
% ub: upper bound ; lb: lower bound ;
    n = length(vecResult);
    expect = mean(vecResult);
    se = sqrt(sum((vecResult - expect).^2) / (n - 1));
    % se = (sum(vecResult.^2) - n * expect^2) / (n - 1);
    lb = expect - se * tinv(1 - alpha / 2, n - 1) / sqrt(n);
    ub = expect + se * tinv(1 - alpha / 2, n - 1) / sqrt(n);
end
```
