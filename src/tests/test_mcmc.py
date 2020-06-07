
import unittest

from TidySimStat.mcmc import *
from TidySimStat.des_queue import cal_count_queue


class TestMCMC(unittest.TestCase):

    def test_sim_mcmc(self):
        n_sample = 10000
        n_servers = 10
        print(cal_block_rate(n_servers, 8, n_sample))


def cal_block_rate(n_servers:int, a, n_sample:int=10000):
    ss = get_dict_ss([i for i in range(0, n_servers+1)])

    f_candidate = lambda x_pre: loop_walk_rd(x_pre, 1, max(ss.keys()))
    f_b = lambda x: cal_count_queue(ss[x], a)

    def f_accept(x_pre, y):
        if x_pre < 0:
            raise ValueError(f"x_pre = {x_pre} < 0 .")
        elif y < 0:
            raise ValueError(f"y = {y} < 0 .")
        else:
            d = accept_simple(x_pre, y, f_b)

        return d

    x1 = rd.randint(1, n_servers+1)
    results = sim_mcmc(x1, f_candidate, f_accept, n_sample)

    counts = [results['x'].tolist().count(i) for i in range(1, n_servers+2)]
    freqs = [counts[i] / sum(counts) for i in range(n_servers+1)]
    return freqs
