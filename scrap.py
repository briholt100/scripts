# -*- coding: utf-8 -*-
"""
Created on Fri Oct 23 16:12:05 2015

@author: brian
"""

temp=['hello there\t\tQ','goodbye\n','comeback!\n']
temp
len(temp)



for item in (temp):    
    item=re.sub('\t|\n','fuck fuck fuck',str(item))
temp




a = ['a', 'b', 'c']
res = "".join(a)
res


import requests
urlFull='https://inside.seattlecolleges.edu/enrollment/content/displayReport.aspx?col=063&q=B563&qn=Winter%2016&nc=false&in=&cr='
url='https://inside.seattlecolleges.edu/enrollment/content/displayReport.aspx'
college = '063'
quarter = 'B233'
quartName= 'Winter%13'
ExcludeCancelled = 'false'
itemNumber=''
credit=''
payload={'col':college,'q':quarter,'qn':quartName, 'nc' :  ExcludeCancelled ,'in':itemNumber,'cr':credit}
payload_str = "&".join("%s=%s" % (k,v) for k,v in payload.items())

r=requests.get(url, params=payload_str,auth=(user,passwrd),stream=True)

payload={'col':'063','q':'B233','qn':'Winter%2013', 'nc' : 'false','in':'','cr':''}
session = requests.Session()
resp    = session.post(url,auth=(user,passwrd))
cookies = requests.utils.cookiejar_from_dict(requests.utils.dict_from_cookiejar(session.cookies))
resp    = session.post(url,data=payload,cookies =cookies,auth=(user,passwrd))
r=session.get(url,auth=(user,passwrd))
r = requests.post(url,data=payload, auth=(user,passwrd))
print(r.status_code, r.reason)
print(r.text)
print(r.url)


urlEnrol='https://inside.seattlecolleges.edu/default.aspx?svc=enrollment&page=enrollment'
payload = {
    "ctl08$ddlCollegeView":'063' ,
    'ctl08$ddlQuarterView': 'A013'
}



r = requests.post(url, data=payload,auth=(user,passwrd))


<form name="form1" method="post" action="default.aspx?svc=enrollment&amp;page=enrollment" id="form1">


  <select name="ctl08$ddlCollegeView" id="ctl08_ddlCollegeView">
  <option value="062">Central</option>
  <option selected="selected" value="063">North</option>
  <option value="064">South</option>
  <option value="065">SVI</option>

  </select>


  <select name="ctl08$ddlQuarterView" id="ctl08_ddlQuarterView">
  <option value="B343">Winter 14</option>
  <option value="B344">Spring 14</option>
  <option value="B451">Summer 14</option>
  <option value="B452">Fall 14</option>
  <option value="B453">Winter 15</option>
  <option value="B454">Spring 15</option>
  <option value="B561">Summer 15</option>
  <option value="B562">Fall 15</option>
  <option selected="selected" value="893">Winter 1999</option>

  </select>



  <a onclick="clickChoice.reportChoice='all';return ValidateAndOpenWindow2('ctl08_lblItemRequired', 'ctl08_lblCollegeRequired', 'ctl08_txtItemNum', 'ctl08_optAll', 'ctl08_optSingle', 'ctl08_optClassList', 'ctl08_optElearn', 'ctl08_ddlCollegeView', 'ctl08_ddlQuarterView', 'ctl08_chkNonCancelled', '0', 'enrollment/content/displayReport.aspx', 900, 600);" id="ctl08_optAll" class="btnViewReport" href='javascript:WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions("ctl08$optAll", "", false, "", "enrollment/content/#", false, true))'>View Report</a>





# -*- coding: utf-8 -*-
"""
Created on Sat Mar 26 18:36:07 2016

@author: brian
"""

import socket

mysock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
mysock.connect(('www.pythonlearn.com', 80))
mysock.send('GET http://www.pythonlearn.com/code/intro-short.txt HTTP/1.0\n\n')

while True:
    data = mysock.recv(512)
    if ( len(data) < 1 ) :
        break
    print data;

mysock.close()



# Note - this code must run in Python 2.x and you must download
# http://www.pythonlearn.com/code/BeautifulSoup.py
# Into the same folder as this program

import urllib
from BeautifulSoup import *

url = raw_input('Enter - ')
html = urllib.urlopen(url).read()

soup = BeautifulSoup(html)

# Retrieve all of the anchor tags
tags = soup('span')

total=0
for tag in tags:
    print tag.contents[0]
    total+= int(tag.contents[0])    
    
print total

       
    
    
# Note - this code must run in Python 2.x and you must download
# http://www.pythonlearn.com/code/BeautifulSoup.py
# Into the same folder as this program

import urllib
from BeautifulSoup import *
import re

position = int(raw_input('Enter which link '))-1
repeat = int(raw_input('Enter repeat number '))-1
url = raw_input('Enter - ')
url = "http://python-data.dr-chuck.net/known_by_Fikret.html"
url = "http://python-data.dr-chuck.net/known_by_Kamron.html"
html = urllib.urlopen(url).read()
soup = BeautifulSoup(html)

# Retrieve all of the anchor tags
tags = soup('a')
print tags[position]    
i=0
while i < repeat:
    #strip out url from a tag, use above code to redo
    url = tags[position].get('href', None)
    html = urllib.urlopen(url).read()
    soup = BeautifulSoup(html)
    tags = soup('a')
    print tags[position]
    i+=1
    
    
    
    
    
    
import urllib
from BeautifulSoup import *
import re

position = int(raw_input('Enter which link '))-1
repeat = int(raw_input('Enter repeat number '))-1
url = raw_input('Enter - ')
url = "http://python-data.dr-chuck.net/known_by_Fikret.html"
url = "http://python-data.dr-chuck.net/known_by_Kamron.html"
html = urllib.urlopen(url).read()
soup = BeautifulSoup(html)

# Retrieve all of the anchor tags
tags = soup('a')
print tags[position]    
i=0
while i < repeat:
    #strip out url from a tag, use above code to redo
    url = tags[position].get('href', None)
    html = urllib.urlopen(url).read()
    soup = BeautifulSoup(html)
    tags = soup('a')
    print tags[position]
    i+=1
    
        
    
    
    
    
    
import urllib
import xml.etree.ElementTree as ET


url = 'http://python-data.dr-chuck.net/comments_255852.xml'
print 'Retrieving', url
uh = urllib.urlopen(url)
data = uh.read()
print 'Retrieved',len(data),'characters'
#print data
tree = ET.fromstring(data)


results = tree.findall('.//count')
total=0
for count in results:
    print  int(count.text)
    total+= int(count.text)

print total
    
    
    
    
import json
import urllib

#url = 'http://python-data.dr-chuck.net/comments_42.json'
url = 'http://python-data.dr-chuck.net/comments_255856.json'
print 'Retrieving', url
uh = urllib.urlopen(url)
data = uh.read()
print 'Retrieved',len(data),'characters'

input = data

info = json.loads(input)
print 'User count:', len(info)
total=0
for item in info['comments']:
    print item['count']
    total+=int(item['count'])

    
    
    
    
    
import urllib
import json

# serviceurl = 'http://maps.googleapis.com/maps/api/geocode/json?'
serviceurl = 'http://python-data.dr-chuck.net/geojson?'

while True:
    address = raw_input('Enter location: ')
    if len(address) < 1 : break

    url = serviceurl + urllib.urlencode({'sensor':'false', 'address': address})
    print 'Retrieving', url
    uh = urllib.urlopen(url)
    data = uh.read()
    print 'Retrieved',len(data),'characters'

    try: js = json.loads(str(data))
    except: js = None
    if 'status' not in js or js['status'] != 'OK':
        print '==== Failure To Retrieve ===='
        print data
        continue

    print json.dumps(js, indent=4)

    lat = js["results"][0]["geometry"]["location"]["lat"]
    lng = js["results"][0]["geometry"]["location"]["lng"]
    print 'lat',lat,'lng',lng
    location = js['results'][0]['formatted_address']
    print location    
    
    
    
    
    
    
    
    
    