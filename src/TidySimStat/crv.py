
import random as rd
import math


def sim_exp(expect, u=True):
    """Simulate a realisation of a random variable with exponential
    distribution and specified expect.

    Keyword Argument
    ================
    expect: expectation of the exponential distribution
    u: input simulated random number. If missing, simulate one.
       The default value should be set at `rd.random()` directly,
       or the realisation in different calls will the same.

    Note
    ====
    The CDF is defined as `lambda x: 1 - math.exp(- x / expect)`.
    The PDF is thus `lambda x: math.exp(- x / expect) / expect`.
    """
    if u:
        u = rd.random()
    elif u < 0 or u > 1:
        raise Exception("Please input a simulated random number of leave it blank!")

    x = - math.log(u) * expect
    return x


def sim_pareto(beta, k, u=True):
    """Simulate a realisation of a random variable with Pareto distribution
    and specified beta and k.

    Keyword Argument
    ================
    beta: parameter in the CDF.
    k: parameter in the CDf

    Note
    ====
    The CDF is defined as `lambda x: 1 - (beta / x)**k`.
    The PDF is thus `lambda x: k * (beta)**k / x**(k+1)`.
    """
    if u:
        u = rd.random()
    elif u < 0 or u > 1:
        raise Exception("Please input a simulated random number of leave it blank!")

    x = beta / (1 - u)**(1/k)
    return x


def sim_norm(num_samples:int=10):
    """Simulate a realisation of a random variable with standard normal
    distribution according to central limit theory.

    Keyword Argument
    ================
    num_samples: number of samples for one realisation.

    Note
    ====
    The CDF is defined as `st.norm.cdf`.
    The PDF is thus `st.norm.pdf`.
    """
    us = [rd.random() for i in range(num_samples)]

    x = sum(us) - num_samples / 2
    return x


def sim_cossin():
    while True:
        v1 = 2 * rd.random() - 1
        v2 = 2 * rd.random() - 1
        r_square = v1**2 + v2**2
        if r_square <= 1:
            break
    sample = [0, 0]
    sample[0] = v1 / math.sqrt(r_square)  # cosine
    sample[1] = v2 / math.sqrt(r_square)  # sine
    return sample


def sim_norm_bm():
    """Simulate a realisation of a random variable with standard normal
    distribution using Box-Muller method.

    Notes
    =====
    - The CDF is defined as `st.norm.cdf`.
    - The PDF is thus `st.norm.pdf`.
    - Note that `sim_norm_bm()` will return outcomes from two different
      variables
    """
    samples = sim_cossin()
    u1 = rd.random()
    z1 = math.sqrt(- 2 * math.log(u1)) * samples[0]
    z2 = math.sqrt(- 2 * math.log(u1)) * samples[1]

    return [z1, z2]
