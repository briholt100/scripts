# -*- coding: utf-8 -*-
"""
Created on Mon Sep 14 16:48:52 2015

@author: brian

to do:
verify that there is a recipient name, if not, create a flag of some kind
make addressDic an ordered dict
produce a new file with formated address?  separate values with /n?
validate with usps?

"""
scriptLoc = "/home/brian/Projects/scripts"
import usaddress, os, collections
os.getcwd()
os.chdir(scriptLoc)
with open("../data/addresses.csv") as file:  #opens file to readeach line
    addressDic={} #creates dictionary to hold parased data
    addressOrdered=collections.OrderedDict() #creates ordered dictionary to hold parased data
    while True: #something about how 'if line then true' else false, closes this while loop
        line = file.readline()
        address = line  #could just keep line
        #print "\n"+address+"\n"
        address = usaddress.tag(address) # this will parse based on usaddress algorithm
        
        for i,(key,value) in enumerate(address[0].items()): #iterates over each item pair in the ordered dict
            print key, value 

            addressOrdered.update({address[0].values()[0].title():collections.OrderedDict([(key,value) for k,v in address[0].items()])})  #close...the nested dict in the values are not complete.            
#######below works for making a new dict.        
            addressDic.update({address[0].values()[0].title():{k:v.title() for k,v in address[0].items()}}) 
            #previous line updates dictionary, the key being the first value of address[0] 
            #while the value is the remaining prased values from the address ordered dictionary
            # .title() chnages the values to be punctuated
            # the last portion is a dict comprehension to populate addressDic update
            name=address[0].values()[0]  #just a test to pull the first ordered value from the address line
        print "the recipient's name is "+str(name)
        print "\n"
        if not line: break
    file.close()  #must close the file!

print addressDic.items()[0:3]


test=collections.OrderedDict([(k,v) for k,v in addressDic.items()])  #works as expected
print test
print test.update(addressOrdered) #works as expected