# -*- coding: utf-8 -*-
"""
Created on Mon Sep 14 16:48:52 2015

@author: brian
"""

""" 
#open excel file, 
#read each line change to title --upper first letter
#parse the address

return the updated address


#bonus:
strip unnecessary commas
add appropriate punctuation
validate with usps?

"""

import usaddress, os
os.getcwd()
os.chdir("/home/brian/Projects/scripts")
#dataPath="/home/brian/Projects/data")
#for campus
os.chdir("I:\My Data Sources\Scripts")
#dataPath=os.chdir("/home/brian/Projects/scripts")
#directions = ['n','s','w','e','ne','nw','se','sw','North','South','West','East','Northwest','Southwest', 'Northeast','Southeast']

"""with open("../data/addresses.csv") as file:
       while True:
        line = file.readline()
        address = line.title()
        print "\n"+address+"\n"
        address = usaddress.parse(address)
        for i, (v,d) in enumerate(address):
            if d == "StateName":
                v=v.upper()                
                print i, d, v
                print address[i]
        if not line: break
    file.close()
"""

with open("../data/addresses.csv") as file:
    addressDic={} 
    addressList=[]
    while True:
        line = file.readline()
        #print line
        address = line#.title()
        #print "\n"+address+"\n"
        address = usaddress.tag(address)
        for key, value in address[0].items():
           print  value.title()
            #addressDic.update({key:value})
            #addressList.append(value)
        for i,(key,value) in enumerate(address[0].items()):
            #addressDic.update({value[0]:value[1:]})
            print i, key,value
            #print address[0].get('Recipent')
        name=address[0].get('Recipient')
        print "the recipient's name is "+str(name)
        address[0].viewkeys()
        if not line: break
    file.close()

addressDic


    
"""need to either update the tuple (I don't think that's possible) or to make a new dictionary, but return that dictionary"""       
    
addr='16614 Stone Ave N, shoreline, wa, 98133-5425'

    
    
    