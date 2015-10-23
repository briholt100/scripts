# -*- coding: utf-8 -*-
"""
Created on Wed Oct 21 21:58:49 2015

@author: brian
"""

url='https://inside.seattlecolleges.edu/directory/content/results.asp'
import re, requests, collections, BeautifulSoup,  bs4
from requests.auth import HTTPDigestAuth, HTTPBasicAuth

#user=
#passwrd=
r=requests.get(url, auth=(user,passwrd))
r.status_code
i=0
for i,l in enumerate(r.iter_lines()):
    while i < 500:
        print i, l
        i+=1
    
text=bs4.BeautifulSoup(r.text)
print text.prettify()

#==============================================================================
# Below is openning a saved CSV file
#==============================================================================
pattern=r'Faculty'   # pattern selects what is between ""

i=0
#==============================================================================
# Campus
#==============================================================================
with open('I://My Data Sources//Data//SCCDstaff.csv') as infile:
#==============================================================================
# Windater
#==============================================================================
#with open('/home/brian/Projects/data/SCCDstaff.csv') as infile:
    tempList=[]
    while True:
        line = infile.readline()
        if not line: break        
        if not re.match('^ \n',str(line)):
            #print "empty line"
            tempList.append(line)
            #print tempList            
            #print '|'.join(['Contact...%d' % i] +line.strip('\n').split('\n'))
        else: 
            try: print tempList
            except: 
                print "list is empty"
            tempList=[]
        i+=1
    infile.close()
    
'|'.join(['line%d' % i] +   x .strip('\n').split('\n')
    ['|'.join(['line%d' % i] + x.strip('\n').split('\n')) 
         for i, x in enumerate(re.split('line[0-9]+', l)) 
             if x.strip('\n')]
                 
                 
                 #fac = re.findall(pattern, line) #this is problematic because it ignores other lines of importance  
        #if fac:
        
#==============================================================================
# PseudoCode
#==============================================================================

"""
for line in page:
    if line has text:
        add to temporary list
    else: pop all items from list and join them by '\t'
    write this new line to outfile
    """