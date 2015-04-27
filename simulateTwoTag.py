# -*- coding: utf-8 -*-
"""
Created on Mon Mar 23 22:59:25 2015

@author: brian
"""

from statistics import mean
from functools import partial

def simulate(trial_func, n_trials):
    return mean(trial_func() for _ in range(n_trials))

simulate(partial(trial, 2, 6, 2), 10000)