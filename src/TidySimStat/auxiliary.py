

def pmf2cdf(pmf):
    """Obtain cumulative distribution function of a discrete random
    variable according to its probablity mass function."""
    k = len(pmf)
    cdf = [pmf[0] for i in range(k)]
    for i in range(1, k):
        cdf[i] = pmf[i] + cdf[i-1]
    return cdf


def check_posi_pmf(li:list, if_mute=True):
    """Check if input probability mass function represented by a list is
    a `n`-point positive probability mass function."""
    if sum([i <= -0.0001 for i in li]) > 0:
        print(li)
        raise Exception("Some probability is not positive.")
    elif abs(sum(li) - 1) >= 0.001:
        raise Exception(f"Sum of PMF {sum(li):.4f} is not 100%.")
    elif not if_mute:
        print(f"The input is a {len(li)}-point positive PMF.")


def greater(x:float, a:float, epsilon:float=0.0001):
    whe_true = x > a + epsilon
    return whe_true


def less(x:float, a:float, epsilon:float=0.0001):
    whe_true = x < a - epsilon
    return whe_true


def geq(x:float, a:float, epsilon:float=0.0001):
    whe_true = x > a - epsilon
    return whe_true


def leq(x:float, a:float, epsilon:float=0.0001):
    whe_true = x < a + epsilon
    return whe_true


def equal(x:float, a:float, epsilon:float=0.0001):
    whe_true = abs(x - a) < epsilon
    return whe_true
