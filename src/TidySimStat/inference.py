

def infer_dist(pvalue:float, alpha:float=0.05):
    """Perform statistical test regarding distributions of two populations.

    Returns
    =======
    Whether the tested distribution is the same as the given one.
    """
    print("Null hypothesis: two populations have the same distribution. \n"
        f"The input p value is {pvalue:.4f}. \n"
        f"Is the p value smaller than {alpha}? {pvalue < alpha}. \n"
        f"If reject the null hypothesis? {pvalue < alpha}. \n"
        f"If from the same distribution? {pvalue >= alpha}.")

    return pvalue >= alpha


def cal_pvalue_ks(d, n=10, m=1000):
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
        ## If the value is larger than `d`, we say it is a good run.
        if max(d_sim) >= d:
            num_good += 1

    pvalue = num_good / m
    # print(f"One-sample Kolmogorov–Smirnov test p-value: {pvalue:.4f}.")
    return pvalue


def cal_stat_ks(samples, cdf):
    """Calculate statistic in one-sample Kolmogorov–Smirnov test.

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
    print(f"One-sample Kolmogorov–Smirnov test: {stat:.4f}.")

    return stat
