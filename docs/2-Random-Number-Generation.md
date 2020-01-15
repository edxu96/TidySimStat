



Write a program generating 10.000 (pseudo-) random numbers and

# 1,  Random Number Generator (RNG)

## 1.1,  Fibonacci Generator

## 1.2,  Linear Congruential Generator (LCG)

First implement the LCG yourself by experimenting with different values of “a”, “b” and “c”.

```matlab
function [vec_result, vec_prob] = getRandomNumLCG(mCap, a, c, x0)
    vec_result = zeros(mCap, 1);
    vec_prob = zeros(mCap, 1);
    vec_result(1) = rem(a * x0 + c, mCap);
    for i = 2:mCap
        vec_result(i) = rem(a * vec_result(i-1) + c, mCap);
        vec_prob(i) = vec_result(i) / mCap;
    end
    histogram(vec_result, 10)
end
```

# 2,  Statistical Test of the RNG List

There are two statistical characters of the RNG list, distribution type and randomness, for which some tests are used.

## 2.1,  Test for distribution type

H0: Multi-nominal Distribution [0.1] * 10
H1: [0.1253 0.0625 0.1249 0.1249 0.0625 0.125 0.0624 0.125 0.125 0.0625]

### 2.1.1,  Visual tests/plots

Present these numbers in a histogram (e.g. 10 classes): `histogram(vec_result, 10)`.

### 2.1.2,  Chi-Square test

```matlab
function [tCap, prob] = testChiSquare(vecNumObsClass)
    % [1253 625 1249 1249 625 1250 624 1250 1250 625]
    numClass = length(vecNumObsClass);
    numObs = sum(vecNumObsClass);
    vecResultTest = zeros(numClass, 1);
    expect = numObs / numClass;
    for i = 1:numClass
        vecResultTest(i) = (vecNumObsClass(i) - expect)^2 / expect;
    end
    tCap = sum(vecResultTest);
    prob = 1 - chi2pdf(tCap, numClass - 1 - 0)
end
```

The lower, the better.

### 2.1.3,  Kolmogorov Smirnov test



## 2.2,  Test for independence

### 2.2.1,  Visual tests/plots

### 2.2.2,  Run test up/down

### 2.2.3,  Run test length of runs

### 2.2.4,  Test of correlation coefficients
