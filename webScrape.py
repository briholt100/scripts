# -*- coding: utf-8 -*-
"""
Created on Sun May  3 11:52:01 2015

@author: brian
"""

#webscraping

import requests, bs4,BeautifulSoup
url='http://americasmarkets.usatoday.com/2015/04/30/surprise-women-trump-men-on-ceo-pay/'
response =  requests.get(url)
response.status_code == requests.codes.ok
response.raise_for_status() #if returns blank, Aok, otherwise will throw exception

type(response)

len(response.text)

print(response.text[:200])

text1 = bs4.BeautifulSoup(response.text)
table_elements=text1.select('table')
len(table_elements)
table_elements[0].getText()
str(table_elements[0])
table_elements[0].attrs

tr_elements=text1.select('tr')
tr_elements
len(tr_elements)
tr_elements[0].getText()
str(tr_elements[0])
tr_elements[0].attrs
for item in tr_elements:
    for i in item:
        print i.string
    
