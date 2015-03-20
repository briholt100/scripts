# -*- coding: utf-8 -*-
"""
Created on Wed Mar 18 13:38:37 2015

@author: bholt

"""
"""http://www.csee.umbc.edu/courses/331/spring11/notes/python/python3.ppt.pdf"""
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

class thermo(object):

    def __init__(self,currentTemp):
        self.currentTemp=currentTemp #heat is units per minute added?
    
    def check_Temp(self):
        # based on thermometer, this turns on or off
        print self.tempAvg

class Heater(object): #I would like to add a Name to the print statements in INIT
    power="OFF"
    def __init__(self,minTemp=75):
        self.minTemp=minTemp #heat is units per minute added?
        print "The Heater is  "+ str(self.power)
        print "And the temperature is set at " +str(self.minTemp)        

    def set_Temp(self):
        self.minTemp=int(raw_input("what would like to be the minimum temp? "))
        print self.minTemp
        
    def ON(self):
        # based on thermometer, this turns on or off
        self.power = "ON"
        print "The Heater is currently " + str(self.power)
            
    def OFF(self):     
        self.power= "OFF"        
        print "The Heater is currently " + str(self.power)
        
    def heater_check(self):
        print "The Heater is  "+ str(self.power)
        print "And the temperature is set at " +str(self.minTemp)
        
        
        
        
        
        
        