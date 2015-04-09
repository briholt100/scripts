# -*- coding: utf-8 -*-
"""
Created on Mon Mar 23 10:59:15 2015

@author: bholt
This is a program to simulate something from the Lady Tasting Tea
IN it, a description of P-values was exampled by taking 8 women, 4 on a cancer 
drug, 4 on placebo.  If two of the placebo's return cancer, does the drug work?

What if there were 500 women and 1/2 of placebo return with cancer?


"""
#%%
import random

n_trials = 100000
select_tagged = 0

for i in xrange(n_trials):
    subj_pool = [0, 0, 0, 0, 0, 0, 1, 1]
    group_select=['A','B','A','B','A','B','A','B'] 
    groupA = []
    groupB = []
    random.shuffle(subj_pool) #shuffles the subject pool of 8    
    random.shuffle(group_select) #shuffles the possible assignments
    for i in xrange(8):
        draw = subj_pool.pop()    # pulls last member of pool list, adds to 'draw'
        pick=group_select.pop()    # pulls, adds to pick
        if  pick == 'A':
            groupA.append(draw) 
        else:
            groupB.append(draw)
    print "\nGroup A looks like " + str(groupA)
    print "Group B looks like " + str(groupB)

    if sum(groupA)==2 or sum(groupB)==2: #if sum's to 2, then both '1's are in same group
        select_tagged +=1
    
print float(select_tagged)/n_trials
#%%   
   
   
#%%   
from random import shuffle

def trial(n_targets, n_distractors, n_groups):
    all_ = n_distractors * [0] + n_targets * [1]
    shuffle(all_)
    group_size = len(all_) // n_groups
    return any(
        sum(all_[i::group_size]) == n_targets
        for i in range(n_groups)
    )
    
def mean_of_bools(iterator):
    sum_ = 0
    for i, x in enumerate(iterator, 1):  #enumerate adds numbers to a list/seq
        sum_ += 1 if x else 0
    return sum_ / i    

# for more on enumerate http://stackoverflow.com/a/10777408
# [pair for pair in enumerate(mylist)]    

#%%
#%%
def avg(iterator):
    sum_ = 0
    for i, x in enumerate(iterator, 1):  #enumerate adds numbers to a list/seq
        sum_ += x if x else 0
    return sum_ / i    


#from statistics import mean  Only works on pythong 3.x
from functools import partial

def simulate(trial_func, n_trials):
    return mean_of_bools(trial_func() for _ in range(n_trials))

simulate(partial(trial, 2, 6, 2), 10000)
#%%