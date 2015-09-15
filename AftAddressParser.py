# -*- coding: utf-8 -*-
"""
Created on Mon Sep 14 16:48:52 2015

@author: brian
"""

""" open excel file, read each line, parse the address, add to dictinoary? and to line"""

import usaddress
from collections import defaultdict



directions = ['n','s','w','e','ne','nw','se','sw','North','South','West','East','Northwest','Southwest', 'Northeast','Southeast']



with open("../data/addresses.csv") as file:
    while True:
        line = file.readline()
        address = line.title()
        print "\n"+address
        address = usaddress.parse(address)
        
    file.close()
    
addr='16614 Stone Ave N, shoreline, wa, 98133-5425'

#

up= (addr.upper())


home=usaddress.parse(addr)

for i,v in home:
    print i,v


print home


usaddress.parse(up)