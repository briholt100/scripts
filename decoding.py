"""this script is a test script for utf coding processing"""

def d () :
    line=""
    with open("I:\\My Data Sources\\AFT Data\\toTidy\\NorthSpring2012enrollments.csv",) as infile: 
        i=0
        while True and i <30:
            line=infile.readline() #this reads each and every line of file into a variable "line"
            line=line.replace('\xa0', '').encode('utf-8')
            if not line: break
        infile.close()
    return line        

