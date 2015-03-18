# -*- coding: utf-8 -*-
"""
Spyder Editor

working with Time
http://stackoverflow.com/questions/28641336/access-time-in-real-time
"""
#from datetime import timedelta,datetime
import time,random
#print time.strftime("%H")

#print random.uniform(0,1)

#print "this is the current time in seconds since epoch"  + str(time.time())
#print "this is the current local time " + str(time.localtime())

#print "this is the current local time " + str(datetime.datetime.now().time())

print ".....65 degrees........70..........75"    
temp = 70
for sec in range(1,61):
    print str(sec) + "                    " + "%.2f" % (temp)
    temp+=random.uniform(-1,2)
    time.sleep(.1)
    sec+=1


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