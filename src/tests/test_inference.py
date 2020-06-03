
import unittest

from TidySimStat.inference import *


class TestInference(unittest.TestCase):

    def setUp(self):
        self.li_1 = [1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0,1, 1, 1, 0,
            1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1]
        self.li_2 = [0,0,1,0,1,0,0,1,0,0,1,1,1,0,0,0,1]
        self.li_3 = [0, 0, -1, 1, 2]
        self.li_4 = [0, 0, 1.1, 1]
        self.li_5 = [87.9, 64.7, 87.8, 74.9, 71.6, 84.9, 74.3, 76.5,
            83.1, 77.5, 80.8, 75.1, 85.6, 56.3, 89.0, 66.2, 68.0,
            84.6, 81.2, 78.0, 87.1, 85.9, 84.7, 85.2, 85.2, 83.7,
            90.6, 82.4, 75.4, 78.3, 92.8, 79.6, 84.3, 86.3, 87.8,
            93.6, 97.4, 102.0, 98.7, 96.2, 100.3, 92.3, 95.1, 91.7,
            96.7, 94.0, 94.7, 100.9, 93.5, 100.4, 92.9, 99.0, 100.4,
            90.2, 95.9, 94.8, 79.6, 78.8, 98.1, 97.9, 93.0, 100.6,
            81.3, 78.6, 81.9, 82.9, 80.9, 85.8, 78.0, 89.3]
        self.li_6 = [rd.random() for i in range(10000)]
        self.li_7 = [0.54, 0.67, 0.13, 0.89, 0.33, 0.45, 0.90, 0.01, 0.45,
            0.76, 0.82, 0.24, 0.17]
        self.li_8 = [1, 2, 3, 4, 5, 6, 7, 8]

    def test_cal_num_runs(self):
        self.assertEqual(cal_num_runs(self.li_2), 10)

        with self.assertRaises(ValueError):
            cal_num_runs(self.li_3)
            cal_num_runs(self.li_4)

    def test_infer_runs_ww(self):
        z = cal_stat_runs_ww(self.li_1)
        pvalue = cal_pvalue_norm(z)
        self.assertTrue(infer_independence(pvalue))

        li_binary = get_binary_ww(self.li_5)
        z = cal_stat_runs_ww(li_binary)
        pvalue = cal_pvalue_norm(z)
        self.assertFalse(infer_independence(pvalue))

        li_binary = get_binary_ww(self.li_6)
        z = cal_stat_runs_ww(li_binary)
        pvalue = cal_pvalue_norm(z)
        self.assertTrue(infer_independence(pvalue))

    def test_get_li_ups(self):
        self.assertEqual(get_li_ups(self.li_7), [2, 2, 3, 4, 1, 1])

    def test_infer_runs_kunth(self):
        def exam(li):
            ups = get_li_ups(li)
            stat = cal_stat_runs_kunth(ups)
            pvalue = cal_pvalue_chi2(stat, df=6)
            return infer_independence(pvalue)

        self.assertTrue(exam(self.li_7))
        self.assertTrue(exam(self.li_6))
        self.assertFalse(exam(self.li_8))

    def test_infer_runs_ud(self):
        def exam(li):
            li_binary = get_binary_ud(self.li_7)
            stat = cal_stat_runs_ud(li_binary)
            pvalue = cal_pvalue_norm(stat)
            return infer_independence(pvalue)

        self.assertTrue(exam(self.li_7))
        self.assertTrue(exam(self.li_6))

    def test_infer_corr(self):
        def exam(li, h):
            stat = cal_stat_corr(li, h)
            pvalue = cal_pvalue_norm(stat)
            return infer_corr(pvalue)

        self.assertFalse(exam(self.li_8, 1))
        self.assertFalse(exam(self.li_8, 2))
        self.assertFalse(exam(self.li_8, 3))
        self.assertTrue(exam(self.li_6, 1))
        self.assertTrue(exam(self.li_6, 2))
        self.assertTrue(exam(self.li_6, 3))
