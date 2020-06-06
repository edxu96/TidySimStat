
import unittest

from TidySimStat.var_reduction import *
from TidySimStat.estimation import cal_mean_sample


def cal_mean_var_sample(sample:list):
    mean = cal_mean_sample(sample)
    var = cal_var_sample(sample)
    return round(mean, 2), round(var, 2)


class TestVarReduction(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.f_derivative = math.exp
        cls.n = 10000
        rd.seed(123)
        cls.sample = eval_int(cls.f_derivative, cls.n)

    def test_eval_int(self):
        mean, var = cal_mean_var_sample(self.sample["x"].tolist())
        self.assertEqual(mean, 1.72)
        self.assertEqual(var, 0.24)

    def test_reduce_stratified(self):
        results = reduce_stratified(self.sample)
        mean, var = analyse_stratified(results, self.n)

        mean = round(mean, 2)
        self.assertEqual(mean, 1.72)
        self.assertTrue(var < 0.24)

    def test_reduce_antithetic_int(self):
        sample_new = reduce_antithetic_int(self.f_derivative, self.sample)
        mean, var = cal_mean_var_sample(sample_new["y"])
        self.assertEqual(mean, 1.72)
        self.assertTrue(var <= 0.0039)

    def test_reduce_control(self):
        sample_new = reduce_control(self.sample)
        mean, var = cal_mean_var_sample(sample_new["y"])
        self.assertEqual(mean, 1.72)
        self.assertTrue(var <= 0.0039)
