# -*- coding: utf-8 -*-
"""
Created on Mon Sep 14 16:48:52 2015

@author: brian


make addressDic an ordered dict
validate with usps?

"""

import usaddress, os
os.getcwd()
os.chdir("/home/brian/Projects/scripts")
#dataPath="/home/brian/Projects/data")
#for campus
#os.chdir("I:\My Data Sources\Scripts")
#dataPath=os.chdir("/home/brian/Projects/scripts")
#directions = ['n','s','w','e','ne','nw','se','sw','North','South','West','East','Northwest','Southwest', 'Northeast','Southeast']
#addr='16614 Stone Ave N, shoreline, wa, 98133-5425'
with open("../data/addresses.csv") as file:
    addressDic={} 
    while True:
        line = file.readline()
        #print line
        address = line#.title()
        #print "\n"+address+"\n"
        address = usaddress.tag(address)
        for i,(key,value) in enumerate(address[0].items()):
            print key, value 
            addressDic.update({address[0].values()[0].title():{k:v.title() for k,v in address[0].items()}}) 
            name=address[0].values()[0]
        print "the recipient's name is "+str(name)
        print "\n"
        if not line: break
    file.close()

addressDic.items()



    
    
    