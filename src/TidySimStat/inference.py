
import scipy.stats as st
import random as rd

from auxiliary import cdf2pmf


def cal_pvalue_norm(stat, mute:bool=True):
    """Calculate the p value of two-sided Z-test using standard normal
    distribution."""
    if z > 0:
        pvalue = 2 * (1 - st.norm.cdf(z, 0, 1))
    else:
        pvalue = 2 * st.norm.cdf(z, 0, 1)
    if not mute:
        print(f"The input stat: {stat:.4f}. \n"
            f"The p value from normal distribution: {pvalue:.4f}.")
    return pvalue


def cal_pvalue_chi2(stat, df, mute:bool=True):
    """Calculate the pvalue of two-sided t-test using Chi-Square distribution."""
    pvalue = 1 - st.chi2.cdf(stat, df)
    if not mute:
        print(f"The input stat: {stat:.4f}. \n"
            f"The p value from Chi-Square distribution: {pvalue:.4f}.")
    return pvalue


def infer_independence(pvalue, alpha:float=0.05, mute:bool=True):
    """Perform independence test."""
    if not mute:
        print("Null hypothesis: given samples are generated independently. \n"
            f'The input p value is {pvalue:.4f}. \n'
            f'Is the p value smaller than {alpha}? {pvalue < alpha}. \n'
            f'If to reject the null hypothesis? {pvalue <= alpha}. \n'
            f'If given samples are independent? {pvalue >= alpha}. \n')


def infer_dist(pvalue:float, alpha:float=0.05, mute:bool=True):
    """Perform statistical test regarding distributions of two populations.

    Returns
    =======
    Whether the tested distribution is the same as the given one.
    """
    if not mute:
        print("Null hypothesis: two populations have the same distribution. \n"
            f"The input p value is {pvalue:.4f}. \n"
            f"Is the p value smaller than {alpha}? {pvalue < alpha}. \n"
            f"If reject the null hypothesis? {pvalue < alpha}. \n"
            f"If from the same distribution? {pvalue >= alpha}. \n")

    return pvalue >= alpha


def cal_pvalue_ks(stat, n=10, m=1000):
    """Obtain the p-value corresponding a statistic from Kolmogorov–Smirnov
    test by simulations.

    Keyword Arguments
    =================
    n: sample size in each simulation run (default 10)
    m: number of simulation runs (default 500)
    """
    num_good = 0  # A counter to remember the number of good runs
    for i in range(m):
        u = [rd.random() for j in range(n)]
        u.sort()
        d_sim = [j / n - u[j] for j in range(1, (n-1))] + \
            [u[j] - (j-1) / n for j in range(1, (n-1))]
        ## If the value is larger than `stat`, we say it is a good run.
        if max(d_sim) >= stat:
            num_good += 1

    pvalue = num_good / m
    # print(f"One-sample Kolmogorov–Smirnov test p-value: {pvalue:.4f}.")
    return pvalue


def cal_stat_ks(samples, cdf, mute:bool=True):
    """Calculate the statistic in one-sample Kolmogorov–Smirnov test for
    distribution of a continuous random variable.

    Keyword Arguments
    =================
    samples: list of samples
    cdf: target cumulative density function
    """
    samples.sort()
    n = len(samples)
    li_new = [(j+1) / n - cdf(samples[j]) for j in range(n)] + \
        [cdf(samples[j]) - j / n  for j in range(n)]
    stat = max(li_new)
    if not mute:
        print(f"One-sample Kolmogorov–Smirnov test: {stat:.4f}.")

    return stat


def count_gof(samples:list, end_left:float=0, end_right:float=1, k:int=10):
    """Count numbers of samples in different intervals of Chi-Squared
    Goodness-of-Fit Test for a continuous random variable.

    Keyword arguments
    =================
    samples: list of samples to be tested
    end_left: minimum possible value of the distribution
    end_right: maximum possible value of the distribution
    k: number of intervals in the test.

    Returns
    =======
    counts: list of counts in different intervals
    ends: list of left end of intervals
    """
    if end_left >= end_right:
        raise Exception("end_left >= end_right!")
    span = (end_right - end_left) / k  # Length of intervals
    ends = [end_left + (i+1) * span for i in range(k)]
    ends[-1] = end_right
    counts = [0 for i in range(k)]
    samples.sort()

    j = 0
    i = 0
    counter = 0

    ## The left side is considered in the first interval
    while samples[i] == end_left:
        counter += 1
        i += 1

    while i < len(samples):
        if samples[i] <= ends[j] and samples[i] > ends[j] - span:
            counter += 1
            i += 1
        else:
            counts[j] = counter + 0
            while not (samples[i] <= ends[j] and
                    samples[i] > ends[j] - span):
                j += 1
            counter = 1
            i += 1
    counts[j] = counter + 0

    return counts, ends


def cal_stat_gof(freqs:list, pmf:list, mute:bool=True):
    """Calculate the statistic in Goodness of Fit test for the distribution
    of a discrete random variable or a continuous random variable.

    Keyword Arguments
    =================
    freqs: list of frequencies in different intervals
    pmf: list representing probablity mass function of the target distribution

    Attentions
    ==========
    The function can be used for both discrete and continuous random variables.
    """
    n = sum(freqs)
    k = len(pmf)
    stat = sum( [(freqs[i] - n * pmf[i])**2 / n / pmf[i] for i in range(k)] )
    if not mute:
        print(f"Chi-squared goodness of fit test: {stat:.4f}.")

    return stat
