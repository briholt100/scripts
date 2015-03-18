# -*- coding: utf-8 -*-
"""
Spyder Editor

working with Time
http://stackoverflow.com/questions/28641336/access-time-in-real-time
"""
#from datetime import timedelta,datetime
import time,random
import numpy as np
print "degrees"+"\t 65" + "\t" * 2 + "70.00"+ "." * 10+"75"    
temp = 70
tempPosition=20
for sec in range(1,61):
    randNum=random.uniform(-2,2)    
    if randNum < 0:
        tempPosition+= np.floor(randNum)
    if randNum > 0:
        tempPosition += np.ceil(randNum)
    print str(sec)+"|" + " " * tempPosition + "%.2f" % (temp)
    temp+=randNum
    time.sleep(.1)
    sec+=1
"""The following are sandbox experiments with time"""
#print time.strftime("%H")
#print random.uniform(0,1)
#print "this is the current time in seconds since epoch"  + str(time.time())
#print "this is the current local time " + str(time.localtime())
#print "this is the current local time " + str(datetime.datetime.now().time())

"""
for i in range(0,2):
    for sec in iter(lambda: datetime.now().second, 6):
        print(sec)
        time.sleep(1)
    time.sleep(2)  # sleep for 2 seconds before starting again
    print i
    i+=1
    

for count in range(0,2):
    #if not datetime.now().second: # make sure we start first run at start of minute
    t = timedelta(seconds=5)
    while t:
        t -= timedelta(seconds=.25)
        time.sleep(.005)
        print(t)
    time.sleep(5) # sleep for 5 seconds before starting again
    t = timedelta(seconds=2)
    count+=1
    print (count)"""