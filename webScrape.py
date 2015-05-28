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

url="https://inside.seattlecolleges.com/enrollment/content/displayReport.aspx?col=063&q=B343&qn=WINTER%2014&nc=false&in=&cr="
url="https://inside.seattlecolleges.com/enrollment/content/displayReport.aspx"
payload = {'col': '063', 'q': 'B343', 'qn': 'WINTER+14', 'nc': 'false', 'in': '', 'cr': ''}
payload_str = "&".join("%s=%s" % (k,v) for k,v in payload.items())




r=requests.get(url,
               params=payload, 
               auth=('us', '!'))
r
r.url
r.text
r.headers
r.cookies
r.encoding
r.content
r.raw
r.json

#params='format=json&key=site:dummy+type:example+group:wheel')

payload = {'format': 'json', 'key': 'site:dummy+type:example+group:wheel'}

payload_str = "&".join("%s=%s" % (k,v) for k,v in payload.items())
# 'format=json&key=site:dummy+type:example+group:wheel'

r = requests.get(url, params=payload_str)



from selenium import webdriver

profile = webdriver.FirefoxProfile()
profile.set_preference('network.http.phishy-userpass-length', 255)
driver = webdriver.Firefox(firefox_profile=profile)

driver.get("https://putUsername:putPassword@inside.seattlecolleges.com/default.aspx?svc=enrollment&page=enrollment")

element = driver.find_element_by_id("ctl08_ddlCollegeView")

element.select_by_value(063)

dir(element)

#ctl08_ddlCollegeView
<select name="ctl08$ddlCollegeView" id="ctl08_ddlCollegeView">
	<option value="062">Central</option>
	<option selected="selected" value="063">North</option>
	<option value="064">South</option>
	<option value="065">SVI</option>

</select>

<select name="ctl08$ddlQuarterView" id="ctl08_ddlQuarterView">
	<option value="B341">SUMMER 13 </option>
	<option value="B342">FALL 13   </option>
	<option value="B343">WINTER 14 </option>
	<option value="B344">SPRING 14 </option>
	<option value="B451">SUMMER 14 </option>
	<option value="B452">FALL 14   </option>
	<option value="B453">WINTER 15 </option>
	<option value="B454">SPRING 15 </option>
	<option selected="selected" value="B561">SUMMER 15 </option>
	<option value="B562">FALL 15   </option>

</select>

<a onclick="clickChoice.reportChoice='all';return ValidateAndOpenWindow2('ctl08_lblItemRequired', 'ctl08_lblCollegeRequired', 'ctl08_txtItemNum', 'ctl08_optAll', 'ctl08_optSingle', 'ctl08_optClassList', 'ctl08_optElearn', 'ctl08_ddlCollegeView', 'ctl08_ddlQuarterView', 'ctl08_chkNonCancelled', '0', 'enrollment/content/displayReport.aspx', 900, 600);" id="ctl08_optAll" class="btnViewReport" href="javascript:WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions(&quot;ctl08$optAll&quot;, &quot;&quot;, false, &quot;&quot;, &quot;enrollment/content/#&quot;, false, true))">View Report</a>



