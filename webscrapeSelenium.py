# -*- coding: utf-8 -*-
"""
Created on Thu May 28 17:26:20 2015

@author: brian
"""

from selenium import webdriver

profile = webdriver.FirefoxProfile()
profile.set_preference('network.http.phishy-userpass-length', 255)
driver = webdriver.Firefox(firefox_profile=profile)

driver.get("https://:!@inside.seattlecolleges.com/default.aspx?svc=enrollment&page=enrollment")

element = driver.find_element_by_id("ctl08_ddlCollegeView")

element.select_by_value(063)

dir(element)

from selenium.webdriver.support.ui import Select

select = Select(driver.find_element_by_id("ctl08_ddlCollegeView"))
select.select_by_visible_text("North")
select.select_by_value(063)




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






#Try this#http://stackoverflow.com/questions/12164205/selenium-selecting-a-dropdown-option-with-for-loop-from-dictionary
#####using selenium 
#ScriptName : Login.py
#---------------------
from selenium import webdriver

#Following are optional required
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException

baseurl = "http://www.mywebsite.com/login.php"
username = "admin"
password = "admin"

xpaths = { 'usernameTxtBox' : "//input[@name='username']",
           'passwordTxtBox' : "//input[@name='password']",
           'submitButton' :   "//input[@name='login']"
         }

mydriver = webdriver.Firefox()
mydriver.get(baseurl)
mydriver.maximize_window()

#Clear Username TextBox if already allowed "Remember Me" 
mydriver.find_element_by_xpath(xpaths['usernameTxtBox']).clear()

#Write Username in Username TextBox
mydriver.find_element_by_xpath(xpaths['usernameTxtBox']).send_keys(username)

#Clear Password TextBox if already allowed "Remember Me" 
mydriver.find_element_by_xpath(xpaths['passwordTxtBox']).clear()

#Write Password in password TextBox
mydriver.find_element_by_xpath(xpaths['passwordTxtBox']).send_keys(password)

#Click Login button
mydriver.find_element_by_xpath(xpaths['submitButton']).click()