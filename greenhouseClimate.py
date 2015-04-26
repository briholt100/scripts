# -*- coding: utf-8 -*-
"""
Created on Wed Mar 18 13:38:37 2015

@author: bholt

"""
"""http://www.csee.umbc.edu/courses/331/spring11/notes/python/python3.ppt.pdf
A GOOD EXAMPLE http://www.wellho.net/resources/ex.php?item=y301/waterflows.py

Some notes on creating climate for t

before fog is turned off, turn off air exchange to let fog settle...?maybe 10 minutes of no air?


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

class thermo(object):

    def __init__(self):
        self=self
        #self.currentTemp=currentTemp #heat is units per minute added?
    
    def check_Temp(self):
        #self.current_temp=        
        # based on thermometer, this turns on or off
        print Climate.self.tempAvg

class Heater(object): #I would like to add a Name to the print statements in INIT
    power="OFF"
    def __init__(self,minTemp=75,heat_perCuft_perMin=.01,Name=None):
        self.minTemp=minTemp #heat is units per minute added?
        self.heat_perCuft_perMin=heat_perCuft_perMin
        self.Name=Name

        
    def set_Temp(self,F=None):
        if F == None:
            self.minTemp=int(raw_input(
                "\n\nWhat should be the minimum temp in F°? "))
        else:
            self.minTemp=F
        print "\nThe thermometer is now set at " + str(self.minTemp)+"\n\n"

    def switch_on(self, on="ON"):
        if on == "ON":
            self.power="ON"
        else:
            self.power="OFF"
        print "\nThe Heater is now " + str(self.power)+"\n\n"
        
    def heater_check(self):
        print "\nThe Heater is  "+ str(self.power)
        print "And the temperature is set at " +str(self.minTemp)+"F°"
        print "And heat rate is " +str(self.heat_perCuft_perMin)+ (
          " degree per cubic foot per minute.\n\n"
          )       
    