#  Brian C. Holt
#  Winter, Spring 2016
#  purpose is to read lbloom.net webpage and scrape out college level salary data

##
# After links are made, the creation of 'mylist' is used,
# then followed by tailored read.table commands
##

######  Needed Libraries

library(rvest)
library(XML)
library(stringr)

### Needed  functions and local variables 'year' and 'links' ##########

# This function opens up the index page for lbloom.net and pulls the colleges and university webpage links
get_links<-function(){
  print("searching for and pulling links from lbloom.net")
  d<-"http://lbloom.net/index"   # for "code book" see http://lbloom.net/dshsz.html
  d_yr<-c('01','03','05','07','09','11')
  d_pg<-".html"

  page_list<-vector("list",length(d_yr))
  for (i in 1:length(d_yr)){
     url<-paste0(d,d_yr[i],d_pg) # Gets all links in code using XML::getHTMLLink
     bloom<-htmlTreeParse(url,useInternalNodes=T) # for xpath to work below, 'T'
     page_list[[i]]<-bloom
}

  searchTerms<- "//a[contains(text(),' Col ')] |
  //a[contains(text(),'WSU')] |
  //a[contains(text(),'Olympic Co')] |
  //a[contains(text(),'Univ ')] "

  links<-vector("list",length(page_list))
  for (i in 1:length(page_list)){
       # This pulls the <a> names of link
  links[[i]]<-cbind(xpathSApply(page_list[[i]],searchTerms,xmlValue),
                # This pulls the links themselves.
             getHTMLLinks(page_list[[i]],xpQuery=gsub(']',']/@href',searchTerms)))
  }
  links<-do.call('rbind',links)
  writeLines("Here are the first few items of links:\n\n")
  print(head(links,3))
  writeLines("\n\nHhere are the last few items of links:\n\n")
  print(tail(links,3))
  return(links)
}

# This simply gives a user input to which year of interest.

select_year<-function(){
  year<-""
  choices<-c('2011', '2009', '2007', "2005", "2003")
 year<-readline(prompt= '\n\nPlease enter a following year: 2011, 2009, 2007, 2005, or 2003....\n')
  if (year %in% choices)
  {writeLines(paste0('\n\nThank you, pulling the data from year ',year,'\n\n'));
    return(year)} else{
      writeLines('Please try again.Select only from 2011, 2009, 2007, 2005, or 2003\n\n');
      select_year()}
}

# This makes the actual list of data, by year, that will make the final dataframe
make_list<-function(links=NULL,year=NULL){
  #check if links variable exists and use it.
  if(nrow(links)==0){links<-get_links()}else{print(paste("There are ",nrow(links),"url's in 'links'"))}
  year<-select_year()
  link<-links[grep(year,links),]
  mylist<-vector("list", length=nrow(link))
  for(i in 1:nrow(link)){
    text<-link[i,2] %>% url %>% read_html() %>%
      html_nodes(xpath= '//pre') %>%
      html_text(trim=F) #this pulls out the actual pre text
    mylist[[i]]<-text  # This puts the text into each element
    mylist[[i]][2]<-link[i,1] # Puts agency info into the 2nd element of the list
  }
  writeLines(paste('\nok, the list has been pulled from ',year,". Enjoy.\n\n"))
  return(mylist)
}


## This function is used for some years.  It removes dobule spaces and replaces
# with eventual single tabs, making read.delim functional

recursive_replace<-function(text=text){
  text<-gsub('([[:alpha:]]) {2}([[:alpha:]])','\1 \2',text)
  text<-gsub('ADAM   K.','ADAM K.',text)
  text<-gsub('CHRISTOPHER   R.','CHRISTOPHER R.',text)
  text<-gsub('CHRISTOPHER  T','CHRISTOPHER T.',text)
  text<-gsub('KA   I W ','KA I.W.',text)
  text<-gsub('I-YEU +\\(STEVE\\)','I-YEU, STEVE',text)
  text<-gsub('E. +E. +WALSH','E.E. WALSH',text)
  text<-gsub('ADMIN  SERVICES MANAGER A','ADMIN SERVICES MANAGER A',text)

  while (grepl('\\. +HRLY ',text)){
    text<-gsub('\\. +HRLY',' HRLY',text)
    print (grepl('\\. +HRLY ',text))
  }
  while (grepl("'S +\\)",text)){
    text<-gsub("'S +\\)","'S\\)",text)
    print (grepl("'S +\\)",text))
  }
  while (grepl(" {2,}- HOURLY",text)){
    text<-gsub(" {2,}- HOURLY"," - HOURLY",text)
    print (grepl(" {2,}- HOURLY",text))
  }


  while (grepl(' {2}',text)){
    text<-gsub(' {2}','\t',text)
  }
  while (grepl('\t\t|\t \t',text)){
    text<-gsub('\t\t|\t \t','\t',text)
    print (grepl('\t\t|\t \t',text))
  }
  return(text)
}
links<-get_links()
mylist<-make_list(links) #links=links can also be used after previous line run
mylist_bak<-mylist
#mylist<-mylist_bak
str(mylist)



## For 2003,
for (i in 1:length(mylist)){
  mylist[[i]][1]<-gsub(', +\\*',', \\*',mylist[[i]][1])
  mylist[[i]][1]<-recursive_replace(mylist[[i]][1])
  mylist[[i]][1]<-gsub('\t *\r','\r',mylist[[i]][1])
  mylist[[i]][1]<-gsub('\t \\*',' \\*',mylist[[i]][1])
}

df_list<-list()
for (i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  text<-recursive_replace(text)
  df_list[[i]]<-cbind(#mylist[[i]][2],
    regmatches(mylist[[i]][2],r[[i]])[[1]][2],
    regmatches(mylist[[i]][2],yr[[i]]),
    read.delim(textConnection(text),
               header=F,
               strip.white=T,
               skip=2,
               stringsAsFactors=F)
  )


}
sapply(df_list,length)

final_df_2003<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df_2003)<-c('Institution','year','Employee','Job.Title','Salary')
final_df_2003$Salary<-as.numeric(final_df_2003$Salary)
final_df_2003<-final_df_2003[(is.na(final_df_2003$Salary))==F,]
final_df_2003$Employee<-gsub('Z,',',',final_df_2003$Employee)
final_df_2003$et<-NA
final_df_2003$mp<-NA
final_df_2003$percent_ft<-NA
#Institution year Employee Job_title  Salary et mp percent_ft
final_df_2003$job.cat<-"other"
head(final_df_2003)
write.csv(final_df_2003,file="I:\\My Data Sources\\Data\\final_df_2003.csv")  #on campus

##2005

for (i in 1:length(mylist)){
  mylist[[i]][1]<-recursive_replace(mylist[[i]][1])
  mylist[[i]][1]<-gsub('\t *\r','\r',mylist[[i]][1])
}


df_list<-list()
for (i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  text<-gsub('ET-PU  MP  %FT','ET-PU     MP     %FT',text)
  text<-recursive_replace(text)
  df_list[[i]]<-cbind(#mylist[[i]][2],
      regmatches(mylist[[i]][2],r[[i]])[[1]][2],
      regmatches(mylist[[i]][2],yr[[i]]),
      read.delim(textConnection(text),
                                                header=F,
                                                strip.white=T,
                                                skip=2,
                                                stringsAsFactors=F)
  )


}


final_df_2005<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df_2005)<-c('Institution','year','Employee','Job.Title','Salary')
final_df_2005$Salary<-as.numeric(final_df_2005$Salary)
final_df_2005<-final_df_2005[(is.na(final_df_2005$Salary))==F,]
final_df_2005$Employee<-gsub('Z,',',',final_df_2005$Employee)
final_df_2005$et<-NA
final_df_2005$mp<-NA
final_df_2005$percent_ft<-NA
#Institution year Employee Job_title  Salary et mp percent_ft
final_df_2005$job.cat<-"other"
head(final_df_2005)
write.csv(final_df_2005,file="I:\\My Data Sources\\Data\\final_df_2005.csv")  #on campus

# 2003-2005  has 5 columns (like 2011), and should be read with read.delim like 2011

#################
#################
#################

# This works for: 2007, 
table(final_df_2007$et) table(final_df_2007$Institution)
r=list()
yr=list()
for (i in 1:length(mylist)){
  if (grepl("Eastern Wa Univ \\(",mylist[[i]][2])){ #I want to first try with parantheses, and if that fails, then use the idiosyncratic search for Eastern
    r[[i]]<-regexec("^[[:digit:]]{4} (.*) \\(",mylist[[i]][2])
    } else {
      if (grepl("Eastern Wa Univ [[:digit:]]{1}",mylist[[i]][2])){
      r[[i]]<-regexec("^[[:digit:]]{4} (.*) [[:digit:]]{1}",mylist[[i]][2]);print("Eastern")
  }else{
    r[[i]]<-regexec("^[[:digit:]]{4} (.*) \\(",mylist[[i]][2])
  }
  } #'?' makes it less greedy  and I'm not sure why it's not picking up eastern here.
  yr[[i]]<-regexec("^[[:digit:]]{4}",mylist[[i]][2])
}


df_list<-list()
for (i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  text<-gsub('ET-PU  MP  %FT','ET-PU     MP     %FT',text)
  text<-recursive_replace(text)
  df_list[[i]]<-cbind(#mylist[[i]][2],
    regmatches(mylist[[i]][2],r[[i]])[[1]][2],
    regmatches(mylist[[i]][2],yr[[i]]),
    read.delim(textConnection(text),
               header=F,
               strip.white=T,
               skip=2,
               stringsAsFactors=F)
  )
  
}

final_df_2007<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df_2007)<-c('Institution','year','Employee','Job.Title','et','mp','percent_ft','Salary')
final_df_2007<-final_df_2007[(is.na(final_df_2007$Salary))==F,]
final_df_2007<-final_df_2007[,c(1:4,8,5:7)]  # Institution year Employee Job_title  Salary et mp percent_ft
final_df_2007$job.cat<-"other"
head(final_df_2007)
write.csv(final_df_2007,file="I:\\My Data Sources\\Data\\final_df_2007.csv")  #on campus

########
#2009:

for (i in 1:length(mylist)){
  if (grepl("Eastern Wa Univ \\(",mylist[[i]][2])){ #I want to first try with parantheses, and if that fails, then use the idiosyncratic search for Eastern
    r[[i]]<-regexec("^[[:digit:]]{4} (.*) \\(",mylist[[i]][2])
  } else {
    if (grepl("Eastern Wa Univ [[:digit:]]{1}",mylist[[i]][2])){
      r[[i]]<-regexec("^[[:digit:]]{4} (.*) [[:digit:]]{1}",mylist[[i]][2]);print("Eastern")
    }else{
      r[[i]]<-regexec("^[[:digit:]]{4} (.*) \\(",mylist[[i]][2])
    }
  } #'?' makes it less greedy  and I'm not sure why it's not picking up eastern here.
  yr[[i]]<-regexec("^[[:digit:]]{4}",mylist[[i]][2])
}

df_list<-list()
for (i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  text<-gsub('ET-PU  MP  %FT','ET-PU     MP     %FT',text)
  text<-recursive_replace(text)
  df_list[[i]]<-cbind(#mylist[[i]][2],
                      regmatches(mylist[[i]][2],r[[i]])[[1]][2],
                      regmatches(mylist[[i]][2],yr[[i]]),
                      read.delim(textConnection(text),
                                                header=F,
                                                strip.white=T,
                                                skip=2,
                                                stringsAsFactors=F)
  )

}

final_df_2009<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df_2009)<-c('Institution','year','Employee','Job.Title','et','mp','percent_ft','Salary')
final_df_2009<-final_df_2009[(is.na(final_df_2009$Salary))==F,]
final_df_2009<-final_df_2009[,c(1:4,8,5:7)]  # Institution year Employee Job_title  Salary et mp percent_ft
final_df_2009$job.cat<-"other"
head(final_df_2009)
write.csv(final_df_2009,file="I:\\My Data Sources\\Data\\final_df_2009.csv")  #on campus


##########
##########
##########
##For 2011:  Note that Z is added to all last names

for(i in 1:length(mylist)){ #ideally this should be an apply funciton
  mylist[[i]][1]<-gsub('^\n|(\r\n){2,}','\r\n',mylist[[i]][1])
}

wid<-vector("list",length(mylist))  # this simply works for finding the name.  Now salary and title need distinguishing
  for(i in 1:length(mylist)){
    text<-as.character(mylist[[i]][1])
    title_start<-gregexpr('Job Title',text)
    sal_start<-gregexpr('2010 Gross Earnings',text)
    end_line<-gregexpr("(\r*\n)+",text)
    wid[[i]]<-c(title_start[[1]][1]-2,sal_start[[1]][1],sal_start[[1]][1]+21)

    }

wid[[1]]
wid[[36]]



n<-vector("integer",length(mylist))
t<-vector("integer",length(mylist))
s<-vector("integer",length(mylist))
for (i in 1:length(wid)){
  n[i]<-as.integer(wid[[i]][1]-2) #the 'minus' 1 moves the cursor to just before the beginning of the word
  t[i]<-as.integer(wid[[i]][2]-2) #the 'minus' 1 moves the cursor to just before the beginning of the word
  s[i]<-as.integer(wid[[i]][3]-2) #this moves 10 positions sooner in the line
}
n
t
s


#what follows below is a loop that addes a tab chara to a specific numerical position in mylist[[i]], and converts double spaces into single tabs
rhs<-'\\1\t'
###
###  The problem with this code is that it's inserting a tab before the first name, of the first record, after the column titles, thus pushing the first line to the right 1 too many collumns.  So, I need to have it igore the first carriage return ^(\r\n)...this is tricky because the caret here can mean either the front of the line or a negation.  I sorta want both.
####
#obtaining year for gregexpr and name of school
r=list()
yr=list()
for (i in 1:length(mylist)){
  if (grepl("Eastern",mylist[[i]][2])){ #I want to first try with parantheses, and if that fails, then use the idiosyncratic search for Eastern
    r[[i]]<-regexec("^[[:digit:]]{4} (.*) [[:digit:]]{1}",mylist[[i]][2]);print("Eastern")
  } else {
    r[[i]]<-regexec("^[[:digit:]]{4} (.*) \\(",mylist[[i]][2])
  }
  yr[[i]]<-regexec("^[[:digit:]]{4}",mylist[[i]][2])
} #'?' makes it less greedy  and I'm not sure why it's not picking up eastern here.


for (i in 1:length(mylist)){
  lhs1<-paste0('(\n.{', n[i],'})')
  lhs2<-paste0('(\n.{', t[i],'})')
  lhs3<-paste0('(\n.{', s[i],'})')
  mylist[[i]][1]<-gsub(lhs1,rhs,mylist[[i]][1])  #this adds a tab after last space before title.
  mylist[[i]][1]<-gsub(lhs2,rhs,mylist[[i]][1])  #this adds a tab 10 spaces before  end of line (salary)
  mylist[[i]][1]<-gsub(lhs3,rhs,mylist[[i]][1])  #this adds a tab 10 spaces before  end of line (salary)
  mylist[[i]][1]<-gsub('Earnings(\r)*\n\t','Earnings\r\n',mylist[[i]][1])
  mylist[[i]][1]<-recursive_replace(mylist[[i]][1])
}

df_list<-vector("list",length(mylist))
for(i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  df_list[[i]]<-cbind(#mylist[[i]][2],
                      regmatches(mylist[[i]][2],r[[i]])[[1]][2],
                      regmatches(mylist[[i]][2],yr[[i]]),
                      read.delim(textConnection(text),
                                                header=F,
                                                strip.white=T,
                                                skip=2,
                                                stringsAsFactors=F)
  )

}

sapply(df_list,length)####checks that colleges have 4 columns instead of 5

final_df_2011<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df_2011)<-c('Institution','year','Employee','Job.Title','Salary')
final_df_2011$Salary<-as.numeric(final_df_2011$Salary)
final_df_2011<-final_df_2011[(is.na(final_df_2011$Salary))==F,]
final_df_2011$Employee<-gsub('Z,',',',final_df_2011$Employee)
final_df_2011$et<-NA
final_df_2011$mp<-NA
final_df_2011$percent_ft<-NA
final_df_2011$year<-2010 #done because bloom has 2010, but calls it 2011
final_df_2011$job.cat<-"other"
head(final_df_2011)
str(final_df_2011)
#write.csv(final_df_2011,file="I:\\My Data Sources\\Data\\final_df_2011.csv")  #on campus
write.csv(final_df_2011, append=F,file = "./final_df_2011.csv")

df<-rbind(final_df_2011,final_df_2009,final_df_2007,final_df_2005,final_df_2003)
#write.csv(df, append=F,file = "I:\\My Data Sources\\Data\\df.csv") #on campus
write.csv(df, append=F,file = "./df.csv")
###The below merges the data frame with a small table for later merging with post 2010 data
ac<-read.csv(file="./scripts/agency_code.csv")
#ac<-read.csv(file="I://My Data Sources//Scripts//agency_code.csv")  #for campus

###### these should happen after all of 2003-2011 are merged but before merging with colleges_longForm
final_df <- merge(df,ac, by.x="Institution", by.y="Institute", all.x=TRUE)  #this gets the correct names of agencies
final_df<- (final_df[,c(10,11,3:4,9,2,5:8)])
head(final_df)

final_df<-rbind(final_df,colleges_longForm)   ##########this rbinds salary and finaldf2011
write.csv(final_df, file = "./final_df.csv")
#write.csv(final_df, append=F,file = "I:\\My Data Sources\\Data\\final_df.csv") #on campus
df$year<-as.Date(paste(df$year,"-06","-30",sep=""))

tbl<-as.data.frame(table(final_df$Salary,final_df$year))
head(tbl)
colnames(tbl)<-c('Salary','year','Freq')
tapply(tbl$Freq,tbl$year,sum)
plot(tapply(tbl$Freq,tbl$year,sum),)

tbl1<-table(final_df$job.cat[!is.na(final_df$Salary)],final_df$year[!is.na(final_df$Salary)])
tbl1<-as.data.frame(tbl1)
colnames(tbl1)<-c('category','year','Freq')



forPlot<-as.data.frame(tapply(tbl1$Freq,list(tbl1$category,tbl1$year),sum))


colnames(forPlot)<-c('x2010','x2011','x2012','x2013','x2014')

for (i in 1:nrow(forPlot)){  print(paste(rownames(forPlot[i,]),forPlot[i,5]-forPlot[i,1]))}

gather(forPlot,Category,year,x2010:x2014)












gsub('[[:digit:]]{4} (.*) \\(.*\\)','\\1',df$Institution)
strsplit(as.character(df$Institution),split='[[:digit:]] ')
summary(df)
table(is.na(df$Salary))
median(df$Salary)
plot(table(df$Salary[df$Salary>1000]))
abline(v=median(df$Salary),col='red')
abline(v=mean(df$Salary),col='blue')
(df[df$Salary>0&df$Salary<1,])




if(length(df_list[[i]])>4){
  ifelse(sum(is.na(df_list[[i]][,5]))!=nrow(df_list[[i]]),
         print("error in read.delim; data in extra column"),
         df_list[[i]]<-df_list[[i]][,-5])
}







####
# Document dictionary

"""
ET is Employee Type: 6 is faculty, 7 is non-faculty, 1 is classified by state merit rules, 2 is exempt from state merit rules
PU is Pay Unit: M is monthly, H is hourly, C is contracted, D is daily,
MP is months paid
%FT is percent of full-time
"""

"""


#######PROBLEMS.  2001-2009 HAS ODD 'FWF', or other odd column formats.  Yuck
# Several pages have different lines to 'skip'.

#2001 has tab deliminted data, name, title, salary, but many have 2 column sets!!!!!

#2003-2005 works like 2011

#2007-2009 works; columns resorted to 'institution, employee, title, salary, et-pu, mp,%ft'
#2011  works; dummy columns added to line up with 2009 columns##after running code for 2011 and making data frame, try: #table(final_df_2011[grep(' {2,}',final_df_2011$Employee,value=F),1])   ###note: a few institutions 3-4 have several thousand rows of salary less than 10$; several hundred < 1$
############
########
###





"""


adminOther.list<-grep("admin", df$Job.Title, ignore.case=T, value=F)
chancellor.list<-grep("CHANCELLOR", df$Job.Title, ignore.case=T, value=F)
childhood.list<-grep("childho", df$Job.Title, ignore.case=T, value=F)
communication.list<-grep("commun", df$Job.Title, ignore.case=T, value=F)
coordination.list<-grep("coord,", df$Job.Title, ignore.case=T, value=F)
counselor.list<-grep("counselo", df$Job.Title, ignore.case=T, value=F)
dean.list<-grep("dean|assistant d|ASSOC. DEAN", df$Job.Title, ignore.case=T)
director.list<-grep("dir", df$Job.Title, ignore.case=T) #, value=T)
exec.list<-c(grep("exec. d", df$Job.Title, ignore.case=T))
facilities.list<-grep("facilit|custo|electr|grounds|locks|maintan|mechanic", df$Job.Title, ignore.case=T, value=F)
faculty.list<-grep("faculty", df$Job.Title, ignore.case=T)
finance.list<-grep("financ|budget|capita|fiscal", df$Job.Title, ignore.case=T, value=F)
hour.list<-grep("hour", df$Job.Title, ignore.case=T, value=F)
HR.list<-grep("HR|benefits|human|payrol", df$Job.Title, ignore.case=T, value=F)
library.list<-grep("librar", df$Job.Title, ignore.case=T, value=F)
mail.list<-grep("mail", df$Job.Title, ignore.case=T, value=F)
manager.list<-c(grep("mgr", df$Job.Title, ignore.case=T), grep("manag", df$Job.Title, ignore.case=T))
media.list<-grep("media", df$Job.Title, ignore.case=T, value=F)
officeAssist.list<-grep("office assistant|PROGRAM ASSISTANT|ADMINISTRATIVE ASSIST", df$Job.Title, ignore.case=T)
president.list<-grep("presi|v.c.,|chief", df$Job.Title, ignore.case=T, value=F)
programCoord.list<-grep("program coord", df$Job.Title, ignore.case=T, value=F)
retail.list<-grep("retail", df$Job.Title, ignore.case=T, value=F)
secretary.list<-grep("secr|exec. a", df$Job.Title, ignore.case=T) #, value=T)
security.list<-grep("security", df$Job.Title, ignore.case=T, value=F)
specialist.list<-grep("spec", df$Job.Title, ignore.case=T, value=F)
supervisory.list<-grep("superv|spv", df$Job.Title, ignore.case=T, value=F)
support.list<-grep("supt", df$Job.Title, ignore.case=T, value=F)
vice.list<-grep("vice p|vp", df$Job.Title, ignore.case=T, value=F)

vChanc.list<-grep("VICE CHANCELLOR|V\\.C.", df$Job.Title, ignore.case=T, value=F)

df$job.cat<-factor(df$job.cat,
sort(c(
"admin (Other)",
"assistant",
"chancellor",
"childhood",
"communication",
"coordination",
"counselor",
"dean",
"director",
"executive",
"facilities",
"faculty",
"finance",
"hourly",
"HR",
"library",
"mail",
"manager",
"media",
"other",
"pres",
"program coordinator",
"retail",
"secretary",
"security",
"specialist",
"supervisory",
"support",
"vicepres",
"viceChanc"
)
))

##WARNING; BEWARE OF CHANGING ORDER BELOW, ELSE CATEGORIES WILL CHANGE

df$job.cat[adminOther.list]<-"admin (Other)"
df$job.cat[HR.list]<-"HR"
df$job.cat[security.list]<-"security"
df$job.cat[finance.list]<-"finance"
df$job.cat[facilities.list]<-"facilities"
df$job.cat[mail.list]<-"mail"
df$job.cat[media.list]<-"media"
df$job.cat[communication.list]<-"communication"
df$job.cat[coordination.list]<-"coordination"
df$job.cat[support.list]<-"support"
df$job.cat[library.list]<-"library"
df$job.cat[supervisory.list]<-"supervisory"
df$job.cat[counselor.list]<-"counselor"
df$job.cat[retail.list]<-"retail"

df$job.cat[programCoord.list]<-"program coordinator"
df$job.cat[director.list]<-"director"
df$job.cat[hour.list]<-"hourly"
df$job.cat[faculty.list]<-"faculty"
df$job.cat[dean.list]<-"dean"
df$job.cat[childhood.list]<-"childhood"
df$job.cat[manager.list]<-"manager"
df$job.cat[exec.list]<-"executive"
df$job.cat[secretary.list]<-"secretary"
df$job.cat[officeAssist.list]<-"assistant"
df$job.cat[chancellor.list]<-"chancellor"
df$job.cat[specialist.list]<-"specialist"
df$job.cat[president.list]<-"pres"
df$job.cat[vice.list]<-"vicepres"
df$job.cat[vChanc.list]<-"viceChanc"

director.salary<-df[director.list,]
dean.salary<-df[dean.list,]
sec.salary<-df[secretary.list,]
director.salary<-df[director.list,]



table(df$job.cat)













