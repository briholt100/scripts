# -*- coding: utf-8 -*-
"""
Created on Mon Sep 14 16:48:52 2015

@author: brian

to do:

verify that there is a recipient name, if not, create Missing list, should be dict?
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

with open("../data/addresses.csv") as file:
    addressDic={} # For parased data
    addressOrdered={} # Ordered dict for parased data
    missRecipList=[]
        #something like 'if line then true' else false, closes this while loop    
    while True: 
        line = file.readline()
        address = line 
        # This will parse based on usaddress algorithm
        address = usaddress.tag(address) 
        # looks for addresses without a recipient, makes list of them        
        for k,v in address[0].items()[0:1]: # add [0:1] after .items() for whole record
            if not address[0].has_key('Recipient'):
                missRecipList.append(v)
        # Iterates over each item pair in the ordered dict
        for i,(key,value) in enumerate(address[0].items()):
            #            
            # Print key, value 
            # Updates dictionary, key being first value of address[0] 
            # While the 'value' is the remaining from the ordered dictionary
            # .title() changes the values to be punctuated
            # The last portion is dict comprehension to populate addressDic
            #            
            addressOrdered.update({address[0].values()[0].title():
                collections.OrderedDict([(k,v.title()) 
                    for k,v in address[0].items()])})  
            
            #makes an unordered, standard dictionary
            addressDic.update({address[0].values()[0].title():{k:v.title() for
                               k,v in address[0].items()}}) 
        if not line: break
    file.close()  # Must close the file!
    
with open('../data/formattAddress.csv', "w") as outfile:
    for k,v in addressOrdered.items():
        print "\n"+ k + "\n"
        for i,j in v.items():
            print i + " " + v[i]
            #outfile.write(j + ",") 
    outfile.close()

"""
pseudo code for creatinga  file

print recipient
print number + street + posttype + direction + and so on until reach "PlaceName"
make newline
print PlaceName comma New line
print StateName
print ZipCode


print addressOrdered['Recipient']

"""





print "\n\nEntries that are missing a recipient\n \
 includes the following: \n" + str(missRecipList)  #[0] calls first item

"""print addressDic.items()[0:3]
print addressOrdered.items()[0:3]"""