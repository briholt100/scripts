f_loc = r"C:\Documents and Settings\brian\My Documents\My Data Sources\practice\SVIWinter2013Enrollments.csv"
outfile_store = r"C:\Documents and Settings\brian\My Documents\My Data Sources\practice\TidySviWinter2013Enrollments.csv"
Parse_Folder =r"C:\Documents and Settings\brian\My Documents\My Data Sources\practice"
needs_work=[]
new_quarters=[]

"""Okay, I've got a list of file names that need to be iteratively run through my parser."""


def identify_untidy():
    """this searches and returns .csv files that have no 'tidy' in the filename and appends to a list, 'needs_work'."""
    import os,re
    file_list = os.listdir(Parse_Folder)
    for f in file_list:
        if "Tidy" not in f:      ###alternatively, this works:  if not re.match('^Tidy',f):####
            if ".csv" in f:
                needs_work.append(f)
    return            

def filename_Parser():
    """takes a string file location from list called needs_work and pulls out 2 variable names from the filename, Quarter and campus.  These will be fed to file_tidy""" 
    import re
    import ntpath   #might not be needed
    identify_untidy()
    print needs_work
    campusList= ["North","South","Central","SVI"]
    quarterList = ["Fall","Winter","Spring","Summer"]
    for i in needs_work:             #fileName = ntpath.basename(filename_from_needs_work)      ##this pulls just the file name from a file location
        yearMatch = re.search("[0-9]{4}",i)
        year = yearMatch.group(0)
        print year
    for i in needs_work:
        for c in campusList:
            if c in i:
                campus = c
                print c
    for i in needs_work:
        for q in quarterList:            
            if q in i:
                quarter = q
                print q
   # quarterCampus = [quarter, year, campus]        ####this doesn't work because it only takes the last items.  I need the above for loops to be iterated.
    return quarterCampus


def list_of_new_quarters():
    """this will iteratively take list elements from filename_Parser and generate a new list with all of the new quarters needing tidying"""
    identify_untidy()
    for i in filename_Parser(needs_work):  ####this no longer works.  This procedure expects only a list of 3 strings, but I'm trying to make a list of lists
        new_quarters.append[i]




def file_tidy(f_loc):
    """This definition is longer than necessary, but it works. It creates a new outfile 
    that includes only the raw data, but prefixes these lines with the 
    campus and quarter info from filename_Parser above"""
    import re
    prefix = filename_Parser(f_loc)[0], filename_Parser(f_loc)[1]+","+filename_Parser(f_loc)[2] + ","
    with open(f_loc,) as infile, open(outfile_store, "w") as outfile: # <<==
        while True:
            line=infile.readline()
            if not line: break
            match = re.findall("^[0-9]{4}",line)
            if match:
                outfile.write("Winter 2013,SVI,"+line) # <<==  I must use the fileNameParser to obtain these values
        infile.close()

def file_length(f_loc):
    """counts the number of lines in a file"""
    with open(f_loc) as f:
        for i, l in enumerate(f):
            pass
    return i + 1