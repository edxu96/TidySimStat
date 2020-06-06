
import random as rd
import math
import pandas as pd
import numpy as np


from TidySimStat.estimation import *


def eval_int(f_derivative, n:int=1000) -> pd.core.frame.DataFrame:
    us = [rd.random() for i in range(n)]
    xs = [f_derivative(u) for u in us]

    return pd.DataFrame({"u": us, "x": xs})


def analyse_stratified(sample:pd.core.frame.DataFrame):
    sample["y"] = [math.floor(i) + 1 for i in sample["u"] * 10]
    xbars_y = [0 for i in range(10)]
    vars_y = [0 for i in range(10)]
    for i in range(10):
        sample_y = sample.loc[sample["y"] == i+1]
        xbars_y[i] = np.mean(sample_y["x"])
        vars_y[i] = np.var(sample_y["x"])
    return xbars_y, vars_y


def analyse_antithetic_int(f_derivative, sample:pd.core.frame.DataFrame):
    sample["u2"] = [1 - u for u in sample["u"]]
    sample["x2"] = [f_derivative(u) for u in sample["u2"]]
    n = sample.shape[0]
    sample["y"] = [(sample["x"][i] + sample["x2"][i]) / 2 for i in range(n)]
    return sample


# def evaluate_integral_antithetic(n:int) -> list:
#     us = [rd.random() for i in range(n)]
#     ys = [(math.exp(u) + math.exp(1 - u)) / 2 for u in us]
#     return est_three_points(ys)
#
#
# def evaluate_integral_antithetic(n):
#     us = [rd.random() for i in range(n)]
#     xs = [math.exp(u) for u in us]
#
#     dat = np.array([xs, us])
#     cov_xu = np.cov(dat)[0][0]
#     # mean_xs = cal_mean_sample(xs)
#     var_u = cal_var_sample(us)
#     c = - cov_xu / var_u
#
#     zs = [xs[i] + c * (us[i] - 0.5) for i in range(n)]
#     return est_three_points(zs)
#
#
# def eval_int_strata_sample(n, m:int=10):
#     # us = [rd.random() for i in range(n)]
#     # xs = [math.exp(u) for u in us]
#
#     def stratify(m):
#         us = [rd.random() for i in range(m)]
#         w = sum([math.exp((i + us[i]) / m) for i in range(m)]) / m
#         return w
#
#     ws = [stratify(m) for i in range(n)]
#     return ws
