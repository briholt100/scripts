# -*- coding: utf-8 -*-
"""
Created on Mon Mar 23 10:59:15 2015

@author: bholt
"""

import random
subj_pool = ['N', 'N', 'N', 'N', 'N', 'N', 'T', 'T']
groupA = []
groupB = []

n_trials = 100000
select_white_ = 0

for i in xrange(8):
    random.shuffle(subj_pool)
    print "\nHere shuffle # "+ str(i+1) + ": " + str(subj_pool)
    draw = subj_pool.pop()    
    print "\nThis is the draw:.... " + str(draw)
    
#How to randomly pick between grpA or B? Once that is done:
    groupA.append(draw)    
    
    
    print "\nThis is what remains:.... " + str(subj_pool)
    subj_pool = subj_pool
print groupA
    



"""
for trials in xrange(n_trials):
    random.shuffle(subj_pool)
    if subj_pool[0] == 'T'  or subj_pool[1] == 'T':
        not_both_reds_successes += 1

print float(not_both_reds_successes) / n_trials"""