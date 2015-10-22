# -*- coding: utf-8 -*-
"""
Created on Wed Oct 21 21:58:49 2015

@author: brian
"""

url='https://inside.seattlecolleges.edu/directory/content/results.asp'
import requests, collections, BeautifulSoup, re, bs4
from requests.auth import HTTPDigestAuth, HTTPBasicAuth

user=
passwrd=
r=requests.get(url, auth=(user,passwrd))
r.status_code
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
with open('/home/brian/Projects/data/SCCDstaff.csv') as infile:
    while True:
        line = infile.readline()
        if not line: break        
        fac = re.findall(pattern, line)   
        if fac:
            print line
        elif:
        i+=1
    infile.close()