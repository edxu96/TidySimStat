## TidySimStat:
## Edward J. Xu

import math
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
import scipy.stats as st
import random as rd
from typing import Union

from TidySimStat import (
    inference, drv, crv, auxiliary, exam, des_queue, estimation, mcmc
)

__all__ = [
    "inference", "drv", "crv", "auxiliary", 
    "exam", "des_queue", "estimation", "mcmc"
]

# if __name__ == '__main__':
#     print("`TidySimStat.py` is a module by Edward J. Xu. Last modifed date."
#         "is June 1, 2020.")
# elif __name__ == 'TidySimStat':
#     print("`TidySimStat.py` by Edward J. Xu is imported. Copyright all "
#         "reserved. \n"
#         "Last modifed date is June 2, 2020.")
