# -*- coding: utf-8 -*-
"""
Created on Mon Sep 14 16:48:52 2015

@author: brian
"""

""" open excel file, read each line, parse the address, add to dictinoary? and to line"""

import usaddress



with open("../data/addresses.csv") as file:
    while True:
        line = file.readline()
        print line
        address = line.upper()
        address = usaddress.parse(address)
        print address
        if not line: break
    file.close()

addr='16614 Stone Ave N, shoreline, wa, 98133-5425'

#

up= (addr.upper())


home=usaddress.parse(addr)

print home


usaddress.parse(up)