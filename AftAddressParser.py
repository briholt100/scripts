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

import usaddress


#directions = ['n','s','w','e','ne','nw','se','sw','North','South','West','East','Northwest','Southwest', 'Northeast','Southeast']



with open("../data/addresses.csv") as file:
    while True:
        line = file.readline()
        address = line.title()
        print "\n"+address+"\n"
        address = usaddress.parse(address)
        for i, (v,d) in enumerate(address):
            if d == "StateName":
                #v=v.upper()                
                print i, d, v
                print address[i]
        if not line: break
    file.close()
    
    
"""need to either update the tuple (I don't think that's possible) or to make a new dictionary, but return that dictionary"""       
    
addr='16614 Stone Ave N, shoreline, wa, 98133-5425'