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
#with open('I://My Data Sources//Data//SCCDstaff.csv') as infile:
#==============================================================================
# Windater
#==============================================================================
with open('/home/brian/Projects/data/SCCDstaff.csv') as infile:
    tempList=[]
    while True:
        line = infile.readline()
        if not line: break
        if not re.match('^ \n',str(line)):
            tempList.append(line)
        else: #line should be empty, which will trigger list dump and reset
            #print line
            try: 
                for i,(item) in enumerate(tempList):
                    tempList[i]=re.sub('\n|Email|mailstop:','',str(item))
                print tempList
                tempList.append('\n')
                with open('/home/brian/Projects/data/outfile.csv',"a") as outfile:
                    for item in tempList:
                       outfile.write(str(item))
            except: 
                print "list is empty"
            tempList=[]
        i+=1
    infile.close()
    outfile.close()
    
