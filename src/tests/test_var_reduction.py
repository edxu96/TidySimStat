
import unittest

from TidySimStat.var_reduction import *
from TidySimStat.estimation import cal_mean_sample


def cal_mean_var_sample(sample:list, n):
    mean = cal_mean_sample(sample)
    var = cal_var_sample(sample)
    conf = est_interval_mean_var(mean, var, n)
    return round(mean, 2), round(var, 2), conf


def cal_diff_stratified(n:int):
    ## Calculate the theoretical variance of the condition expectation
    vcm = (sum([math.exp(i / 5) for i in range(1, 11)]) / 10 -
        (sum(math.exp(i / 10) for i in range(1, 11)) / 10)**2) * 100 * \
        (1 - math.exp(- 0.1))**2
    return vcm


class TestVarReduction(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.f_derivative = math.exp
        cls.n = 10000
        rd.seed(1234)
        cls.sample = eval_int(cls.f_derivative, cls.n)

    def test_eval_int(self):
        mean, var, conf = cal_mean_var_sample(
            self.sample["x"].tolist(), self.n)
        self.assertEqual(mean, 1.72)
        self.assertEqual(var, 0.24)  # var = 0.2414618108801089
        self.assertTrue(math.e - 1 > conf[0] and math.e - 1 < conf[1])

    def test_reduce_stratified(self):
        results = reduce_stratified(self.sample)

        for i in range(10):
            mean = results.iloc[i]['xbar']
            var = results.iloc[i]['var']
            n = results.iloc[i]['n']
            conf = est_interval_mean_var(mean, var, n)

            ## Calculate the theoretical conditional expectation
            theta = 10 * (1 - math.exp(- 0.1)) * math.exp(0.1 * (i+1))
            self.assertTrue(theta > conf[0] and theta < conf[1])

        mean, var = analyse_stratified(results, self.n)
        conf = est_interval_mean_var(mean, var, 10)

        mean = round(mean, 2)
        self.assertEqual(mean, 1.72)
        self.assertTrue(var <= 0.0027)

        # var_improve = cal_diff_stratified(self.n) / self.n
        self.assertTrue(math.e - 1 > conf[0] and math.e - 1 < conf[1])

    def test_reduce_antithetic_int(self):
        sample_new = reduce_antithetic_int(self.f_derivative, self.sample)
        mean, var, conf = cal_mean_var_sample(sample_new["y"], self.n)
        self.assertEqual(mean, 1.72)
        self.assertTrue(var <= 0.0039)
        self.assertTrue(math.e - 1 > conf[0] and math.e - 1 < conf[1])

    def test_reduce_control(self):
        sample_new = reduce_control(self.sample)
        mean, var, conf = cal_mean_var_sample(sample_new["y"], self.n)

        self.assertEqual(mean, 1.72)
        self.assertTrue(var <= 0.0039)
        self.assertTrue(math.e - 1 > conf[0] and math.e - 1 < conf[1])
