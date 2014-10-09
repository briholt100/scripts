__author__ = 'bholt'

"""
Seattle Colleges report enrollments via web, 
but it's clunky and divided by campus and quarter.  
So, I need to make a consistent file name that 
separates the information in order to combine it 
into a tidy, workable csv, titled like: 
"CentralSummer2013Enrollments"
"""

""""
After generating an enrollment report for a given quarter/campus,
do a copy paste into a worksheet.  Do this because
the 2nd line of the worksheet will contain the campus,
quarter, year, and date accessed. This can be used to create a file name"""

#Open file
#save .xls as csv using xld
#close file
#open new .csv
#read appropriate line (maybe just the first 3 lines)
#pull campus, quarter, year out of appropriate line
#rename
#close file

def make_name(year):
    school = ["Central", "North", "South"]
    quarter = ["Summer", "Fall", "Winter", "Spring"]
    for college in school:
        for term in quarter:
            print college + term + str(year) + "enrollments"