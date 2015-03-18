# -*- coding: utf-8 -*-
"""
Created on Wed Mar 18 13:38:37 2015

@author: bholt

"""



class Climate(object):
    
    def __init__(self,tempAvg=68,humidity=.45,airFlow=1,days=1):
        self.tempAvg=tempAvg        
        self.humidity=humidity
        self.airFlow=airFlow
        self.days=days
                
    def TempCycle(self,minutes=10,tempPosition=20):
        import time,random
        import numpy as np
        print "\n\n  F°" + " " * tempPosition + str(self.tempAvg)  
        for d in range(1,self.days+1):
            print "\nA New Day "+ str(d)  +"\n"
            for sec in range(1,minutes+1):
                randNum=random.uniform(-2,2)    
                if randNum < 0:
                    tempPosition+= np.floor(randNum)
                if randNum > 0:
                    tempPosition += np.ceil(randNum)
                print str(sec)+"|" + " " * tempPosition + "%.2f" % (self.tempAvg)
                self.tempAvg+=randNum
                time.sleep(.1)
                sec+=1
            d+=1
