# -*- coding: utf-8 -*-
"""
Spyder Editor

working with Time
http://stackoverflow.com/questions/28641336/access-time-in-real-time
"""
import time, datetime


print "this is the current time in seconds since epoch"  + str(time.time())
print "this is the current local time " + str(time.localtime())

print "this is the current local time " + str(datetime.datetime.now().time())



"""from datetime import datetime
import time

while True:
    for sec in iter(lambda: datetime.now().second, 46):
        print(sec)
        time.sleep(1)
    time.sleep(14)  # sleep for 14 seconds before starting again"""
    
    
from datetime import timedelta,datetime
import time


for count in range(0,2):
    #if not datetime.now().second: # make sure we start first run at start of minute
    t = timedelta(seconds=5)
    while t:
        t -= timedelta(seconds=.25)
        time.sleep(.5)
        print(t)
    time.sleep(5) # sleep for 15 seconds before starting again
    t = timedelta(seconds=5)
    count+=1
    print (count)