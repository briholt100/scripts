# -*- coding: utf-8 -*-
"""
Created on Sun Oct 18 20:16:23 2015

@author: brian

for scraping doc titles from SCCD
"""

import requests, collections, bs4, re #BeautifulSoup
from requests.auth import HTTPDigestAuth, HTTPBasicAuth

NoTitleList=[]
SCCDdocDic={}

url = 'https://inside.seattlecolleges.edu/default.aspx?svc=documentcenter&page=searchdocuments'
docNumber=1
# Below is a single url, but the docid can be iterated from 1 to 6k
# Also, siteID = 275 is financial stuff
while docNumber<105:
    payload = {'docID': str(docNumber)}
    payload_str = "&".join("%s=%s" % (k,v) for k,v in payload.items())
    #  Below is a 'head' request, which is not typical of reading web pages. 
    # Typically you do a .get request, but that pulls all of the content.  
    try:    
        r_head=requests.head(url, params = payload_str, auth=(user,passwrd))
        # This checks for a keyword in the header key; if T, title is populat
        if 'content-disposition' in r_head.headers.keys():
            title=r_head.headers.get('content-disposition')            
            print ("this has a title .........  " + title)
            # Updates a SCCDdocDic with nested dictionary using filename and
              # a new dictionary tracking length and last-modified
            if SCCDdocDic.has_key(title):
                print ("this dictionary already has title: " + str(title))
                SCCDdocDic.update({str(title) + str(docNumber):
                    {docNumber:{'content-length':r_head.headers.get(
                    'content-length'),'last-modified':
                    r_head.headers.get('last-modified')}}})                
            else: SCCDdocDic.update({title:{docNumber:{
                                'content-length':r_head.headers.get(
                                  'content-length'),'last-modified':
                                     r_head.headers.get('last-modified')}}})
        else: 
            # No title gets record appended to a list            
            NoTitleList.append({docNumber:{
                                'content-length':r_head.headers.get(
                                  'content-length'),'last-modified':
                                     r_head.headers.get('last-modified')}})
            print ("\nNo Title No Title No Title")
    except:  print ("hmmmm....DocID didn't take")
    print ("\n" + str(docNumber) + "\n\n")
    docNumber+=1


len(NoTitleList)
len(SCCDdocDic)

#==============================================================================
# Removes extaneous info from key including titles
#==============================================================================
pattern=r'.*"(.*)"' 
replace_str = '\1'
k=''
new_key=''
   
for (k,v) in SCCDdocDic.items():
    pattern=r'.*"(.*)"'   # pattern selects what is between ""
    new_key = re.sub(pattern, '\\1', str(k)) 
    SCCDdocDic[new_key] = SCCDdocDic[k]  #right of = is the VALUES for that k
    del SCCDdocDic[k]

for k,v in SCCDdocDic.items():
    print (k +'\n')
    
for item in NoTitleList:
    for k,v in item.items():
        print k
        
#==============================================================================
# # Writing to file below should be done after confirming above output
#==============================================================================
"""
for (k,v) in SCCDdocDic.items():        
    with open('./budgetTitles.csv', "a") as outfile:
        outfile.write("%s;%s\n" % (k,v))
outfile.close()    
    

for item in NoTitleList:
    for k,v in item.items():
        with open('./budgetTitles.csv', "a") as outfile:
            outfile.write("%s;%s\n" % (k,v))
outfile.close()    

"""