# -*- coding: utf-8 -*-
"""
Created on Thu May 28 17:26:20 2015

@author: brian
"""

from selenium import webdriver
from selenium.webdriver.support.ui import Select
profile = webdriver.FirefoxProfile()
profile.set_preference('network.http.phishy-userpass-length', 255)
driver = webdriver.Firefox(firefox_profile=profile)




#  Add user name and pass word 
#driver.get("https://userID:Pass@inside.seattlecolleges.com/default.aspx?svc=enrollment&page=enrollment")

element = driver.find_element_by_id("ctl08_ddlCollegeView")

element.select_by_value(063)



select = Select(driver.find_element_by_id("ctl08_ddlCollegeView"))  #college choice
select.select_by_visible_text("South")
select.select_by_value('063')

selectQN = Select(driver.find_element_by_id("ctl08_ddlQuarterView"))  #quarter choice
selectQN.select_by_value('B341')


reportLink = driver.find_element_by_id('ctl08_optAll') # view report

driver.window_handles
window_before = driver.window_handles[0]
reportLink.click()
window_after = driver.window_handles[1]
driver.switch_to.window(window_after)

firstTable=driver.find_element_by_tag_name('tbody')
firstTable.text()

#https://inside.seattlecolleges.com/enrollment/content/displayReport.aspx


#ctl08_ddlCollegeView
"""<select name="ctl08$ddlCollegeView" id="ctl08_ddlCollegeView">
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

"""


