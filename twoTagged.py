# -*- coding: utf-8 -*-
"""
Created on Mon Mar 23 10:59:15 2015

@author: bholt
This is a program to simulate something from the Lady Tasting Tea
IN it, a description of P-values was exampled by taking 8 women, 4 on a cancer 
drug, 4 on placebo.  If two of the placebo's return cancer, does the drug work?

What if there were 500 women and 1/2 of placebo return with cancer?


"""
import random
subj_pool = [0, 0, 0, 0, 0, 0, 1, 1]
group_select=['A','B','A','B','A','B','A','B'] 
groupA = []
groupB = []

n_trials = 100000
select_tagged = 0

for i in xrange(n_trials):
    for i in xrange(8):
        random.shuffle(subj_pool) #shuffles the subject pool of 8
        draw = subj_pool.pop()    # pulls last member of pool list, adds to 'draw'
        random.shuffle(group_select) #shuffles the possible assignments
        pick=group_select.pop()    # pulls last member of assignments, adds to pick
        if  pick == 'A':
            groupA.append(draw) 
        else:
            groupB.append(draw)
    
    if sum(groupA)==2 or sum(groupB)==2: #if sum's to 2, then both '1's are in same group
        select_tagged +=1
    # the following resets the experiment
    subj_pool = [0, 0, 0, 0, 0, 0, 1, 1]
    group_select=['A','B','A','B','A','B','A','B'] 
    groupA = []
    groupB = []
    
print float(select_tagged)/n_trials
   
   
   
   
   
   
"""
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



"""
for trials in xrange(n_trials):
    random.shuffle(subj_pool)
    if subj_pool[0] == 'T'  or subj_pool[1] == 'T':
        not_both_reds_successes += 1

print float(not_both_reds_successes) / n_trials"""