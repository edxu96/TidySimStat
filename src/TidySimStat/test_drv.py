
import unittest

from TidySimStat.inference import *
from TidySimStat.drv import *
from TidySimStat.auxiliary import pmf2cdf

class TestDisRandomVariable(unitest.TestCase):

    def setUp(self):
        ## Set up different probability mass functions for tests.
        ## Values will be created everytime when test functions are called.
        ## That is, they cannot be changed permanently within test functions.
        self.pmf_1 = [0.1, 0.1, 0.2, 0.4, 0.1, 0.1]
        self.pmf_2 = [7/16, 1/4, 1/8, 3/16]
        self.pmf_not_1 = [0.2, 0.2, 0.2, 0.2]
        self.pmf_negative = [- 0.2, 0.2, 0.2, 0.2, 0.4]

    def test_sim_drv_reject(self):

        def infer_dist_sim(pmf):
            """Test if samples from `sim_drv_reject` can pass KS test."""
            num_sim = 10000
            xs = [sim_drv_reject(p) for l in range(num_sim)]

            counts = [xs.count(l) for l in range(1, n+1)]
            li_cdf = pmf2cdf(p)
            stat = cal_stat_gof(li_count, li_cdf)
            pvalue = cal_pvalue_chi2(stat, df=5)
            infer_dist(pvalue)

        self.assertTrue(infer_dist_sim(self.pmf_1))
        self.assertTrue(infer_dist_sim(self.pmf_2))

        ## Test if `sim_drv_reject` raises `ValueError` when PMF is not
        ## well defined.
        with self.assertRaises(ValueError):
            sim_drv_reject(self.pmf_not_1)
            sim_drv_reject(self.pmf_negative)
