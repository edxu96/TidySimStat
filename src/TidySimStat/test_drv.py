
import unittest

from inference import *
from drv import *


def infer_dist_samples(samples, num_sim, pmf):
    counts = [samples.count(l) for l in range(num_sim)]
    freqs = [i / num_sim for i in counts]
    stat = cal_stat_gof(freqs, pmf)
    pvalue = cal_pvalue_chi2(stat, df=len(pmf) - 1)
    return infer_dist(pvalue)


def exam_sim(pmf, algo, num_sim:int=10000):
    """Test if samples from `algo` can pass KS test."""
    if not callable(algo):
        raise Exception("`algo` should be a function!")

    samples = [algo(pmf) for l in range(num_sim)]
    return infer_dist_samples(samples, num_sim, pmf)


class TestDisRandomVariable(unittest.TestCase):

    def setUp(self):
        ## Set up different probability mass functions for tests.
        ## Values will be created everytime when test functions are called.
        ## That is, they cannot be changed permanently within test functions.
        self.pmf_1 = [0.1, 0.1, 0.2, 0.4, 0.1, 0.1]
        self.pmf_2 = [7/16, 1/4, 1/8, 3/16]

        ## Test if `sim_drv_reject` raises `ValueError` when PMF is not
        ## well defined.
        self.pmf_not_1 = [0.2, 0.2, 0.2, 0.2]
        self.pmf_negative = [- 0.2, 0.2, 0.2, 0.2, 0.4]

    def test_sim_drv_reject(self):
        self.assertTrue(exam_sim(self.pmf_1, sim_drv_reject))
        self.assertTrue(exam_sim(self.pmf_2, sim_drv_reject))

        with self.assertRaises(ValueError):
            sim_drv_reject(self.pmf_not_1)
            sim_drv_reject(self.pmf_negative)

    def test_sim_drv_alias(self):
        def exam(pmf, num_sim:int=10000):
            """Test if samples from alias method can pass KS test."""
            alias = set_alias(pmf)
            samples = [run_alias(alias) for l in range(num_sim)]
            return infer_dist_samples(samples, num_sim, pmf)

        self.assertTrue(exam(self.pmf_1))
        self.assertTrue(exam(self.pmf_1))

        with self.assertRaises(ValueError):
            set_alias(self.pmf_not_1)
            set_alias(self.pmf_negative)

    def test_sim_drv_alias_direct(self):
        def exam(pmf, num_sim:int=10000):
            """Test if samples from direct alias method can pass KS test."""
            f, l = set_alias_direct(pmf)
            samples = [run_alias_direct(f, l) for i in range(num_sim)]
            return infer_dist_samples(samples, num_sim, pmf)

        self.assertTrue(exam(self.pmf_1))
        self.assertTrue(exam(self.pmf_2))

        with self.assertRaises(ValueError):
            set_alias_direct(self.pmf_not_1)
            set_alias_direct(self.pmf_negative)


if __name__ == '__main__':
    unittest.main()
