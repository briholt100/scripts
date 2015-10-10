# -*- coding: utf-8 -*-
"""
Created on Mon Sep 14 16:48:52 2015

@author: brian

to do:
verify that there is a recipient name, if not, create a flag of some kind
produce a new file with formated address?  separate values with /n?
validate with usps?

I could have used a regular dictionary, but chose an ordered
and trust the usaddress module's choice to use an ordered dic; also
makes it easier to recreate a useable address.


"""
scriptLoc = "/home/brian/Projects/scripts"
import usaddress, os, collections
os.getcwd()
os.chdir(scriptLoc)
with open("../data/addresses.csv") as file:  #opens file to readeach line
    addressDic={} # For parased data
    addressOrdered={} # Ordered dict for parased data
    #something like 'if line then true' else false, closes this while loop    
    while True: 
        line = file.readline()
        address = line 
        #print "\n"+address+"\n"
        # This will parse based on usaddress algorithm
        address = usaddress.tag(address) 
        # Iterates over each item pair in the ordered dict
        for i,(key,value) in enumerate(address[0].items()):
            print key, value 
            # Updates dictionary, key being first value of address[0] 
            # while the 'value' is the remaining from the ordered dictionary
            # .title() changes the values to be punctuated
            # the last portion is dict comprehension to populate addressDic
            addressOrdered.update({address[0].values()[0].title():
                collections.OrderedDict([(k,v) for
                            k,v in address[0].items()])})  
            #makes an unordered, standard dictionary
            addressDic.update({address[0].values()[0].title():{k:v.title() for
                               k,v in address[0].items()}}) 
            name=address[0].values()[0]  # Just a test to pull the first value
        print "the recipient's name is "+str(name)
        print "\n"
        if not line: break
    file.close()  # Must close the file!

print addressDic.items()[0:3]
print addressOrdered.items()[0:3]