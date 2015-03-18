# -*- coding: utf-8 -*-
"""
Created on Wed Mar 18 13:38:37 2015

@author: bholt




    def TempCycle (minutes,temp=70,tempPosition=20):


"""



class Climate(object):
    
    def __init__(self,temp,humidity,airFlow,days):
        self.temp=temp        
        self.humidity=humidity
        self.airFlow=airFlow
        self.days=days
                
    def TempCycle(self,minutes,tempPosition=20):
        import time,random
        import numpy as np
        print "degrees"+"\t "+str(self.temp-5) + "\t" * 2 + str(self.temp)+ "." * 10+str(self.temp+5)    
        #temp = 70
        #tempPosition=20
        for sec in range(1,minutes+1):
            randNum=random.uniform(-2,2)    
            if randNum < 0:
                tempPosition+= np.floor(randNum)
            if randNum > 0:
                tempPosition += np.ceil(randNum)
            print str(sec)+"|" + " " * tempPosition + "%.2f" % (self.temp)
            self.temp+=randNum
            time.sleep(.1)
            sec+=1
