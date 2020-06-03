
import unittest

from TidySimStat.inference import *


class TestInference(unittest.TestCase):

    def setUp(self):
        self.li_1 = [1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0,1, 1, 1, 0,
            1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1]
        self.li_2 = [0,0,1,0,1,0,0,1,0,0,1,1,1,0,0,0,1]
        self.li_3 = [0, 0, -1, 1, 2]
        self.li_4 = [0, 0, 1.1, 1]

    def test_cal_num_runs(self):
        self.assertEqual(cal_num_runs(self.li_2), 10)

        with self.assertRaises(ValueError):
            cal_num_runs(self.li_3)
            cal_num_runs(self.li_4)

    def test_infer_runs_ww(self):
        z = cal_stat_runs_ww(self.li_1)
        pvalue = cal_pvalue_norm(z)
        self.assertTrue(infer_independence(pvalue))
