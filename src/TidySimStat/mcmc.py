
import random as rd
import pandas as pd
import math
# from TidySimStat.des_queue import cal_erlang_b


def sim_mcmc(x1:int, f_candidate, f_accept, n_sample:int):
    """Conduct Markov Chain Monte Carlo simulation.

    Keyword Arguments
    =================
    f_candidate: function to generate candidate state.
    f_accept: function to decide whether to accept candidate state.
    n_sample: number of samples
    """
    if callable(f_candidate) is not True:
        raise ValueError(f"Input `f_candidate` is not callable.")
    if callable(f_accept) is not True:
        raise ValueError(f"Input `f_accept` is not callable.")

    states = {}
    y1 = f_candidate(x1)
    states[1] = {"x": x1, "y": y1, "whe_accept": 0}

    for n in range(2, n_sample+1):
        x_pre = states[n-1]['x']
        y = f_candidate(x_pre)
        states[n] = f_accept(x_pre, y)

    results = pd.DataFrame.from_dict(states, orient='index')
    results.drop([i for i in range(1, math.floor(0.05 * n_sample))],
        inplace=True)

    return results


def get_dict_ss(sample_space:list) -> dict:
    """Formulate the dictionary containing sample space.

    Attentions
    ==========
    The index of the dictionary starts from 1.
    """
    ss = {}
    n = len(sample_space)
    for i in range(n):
        ss[i+1] = sample_space[i]
    return ss


def loop_walk_rd(x:int, x_min:int, x_max:int) -> int:
    x1 = x + walk_rd_with0()
    # x1 = x + walk_rd()
    if x1 > x_max:
        x1 = x_min + 0
    elif x1 < x_min:
        x1 = x_max + 0
    return x1


def walk_rd() -> int:
    delta = -1 if rd.randint(0, 1) == 0 else 1
    return delta


def walk_rd_with0() -> int:
    delta = rd.randint(-1, 1)
    return delta


def accept_simple(x_pre:int, y:int, f_b):
    if callable(f_b) is not True:
        raise ValueError(f"Input `f_b` is not callable.")

    if f_b(y) >= f_b(x_pre):
        x = y + 0
        whe_accept = 1
    elif rd.random() < f_b(y) / f_b(x_pre):
        x = y + 0
        whe_accept = 1
    else:
        x = x_pre + 0
        whe_accept = 0

    return {'x': x, 'y': y, 'whe_accept': whe_accept}
