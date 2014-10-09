# -*- coding: utf-8 -*-
"""
Spyder Editor

This temporary script file is located here:
I:\Downloads\WinPython-32bit-2.7.6.2\settings\.spyder2\.temp.py
"""

user_length = float(input("please enter a length, in feet.  Decimals are ok: "))

# calculate left and right side of deicmal
decimal = user_length%1
feet = user_length - decimal

#convert decimals to inches
inches = decimal * 12

print ("you entered  " + str(user_length) + " feet in decimal form.")
print feet
print decimal
print inches

print (str(user_length)+ " is equivalent to " + str(int(feet)) + " feet " + str(inches) +" inches.")
