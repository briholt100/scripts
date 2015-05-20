# -*- coding: utf-8 -*-
"""
Created on Sun May  3 11:52:01 2015

@author: brian
"""

#webscraping

import requests, bs4, BeautifulSoup
url='http://americasmarkets.usatoday.com/2015/04/30/surprise-women-trump-men-on-ceo-pay/'
response =  requests.get(url)
response.status_code == requests.codes.ok
response.raise_for_status() #if returns blank, Aok, otherwise will throw exception

type(response)

len(response.text)

print(response.text[:200])

text1 = bs4.BeautifulSoup(response.text)
print text1.prettify()

table_elements=text1.select('table')
len(table_elements)
table_elements[0].getText()
str(table_elements[0])
table_elements[0].attrs

table = text1.find("table")
print table
dir(table)

for row in table.findAll('tr')[0:]:
    col = row.findAll('td')
    print col
   
   """col = row.findAll('td')
    rank = col[0].string
    artist = col[1].string
    album = col[2].string
    cover_link = col[3].img['src']
    record = (rank, artist, album, cover_link)
    print "|".join(record)
"""

tr_elements=text1.select('tr')
tr_elements
len(tr_elements)
tr_elements[0].getText()
str(tr_elements[0])
tr_elements[0].attrs
for item in tr_elements:
    for i in item:
        print i.string
    
print soup.prettify()





##webscraping SCCD
import requests
from requests.auth import HTTPDigestAuth
import json

url="https://inside.seattlecolleges.com/default.aspx?svc=enrollment&page=enrollment"
url="https://inside.seattlecolleges.com/enrollment/content/displayReport.aspx?col=063&q=B343&qn=WINTER 14&nc=false&in=&cr="
r=requests.get(url, auth=('bholt', 'fuckD1strict!'))
r
r.text
r.headers["content-type"]
r.encoding
r.content
r.json
r.binary


text1 = bs4.BeautifulSoup(r.text)
print text1.prettify()

print(r.json)




dir(requests.Response)




"Basic YmhvbHQ6ZnVja0Qxc3RyaWN0IQ=="



