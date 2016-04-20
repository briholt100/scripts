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
}

# This simply gives a user input to which year of interest.

select_year<-function(){
  year<-""
  choices<-c('2011', '2009', '2007', "2005", "2003")
 year<-readline(prompt= 'enter a following year: 2011, 2009, 2005, or 2003....\n')
  if (year %in% choices)
  {print(paste0('Thank you, pulling the data from year ',year));
    return(year)} else{
      print('Please try again.Select only from 2011, 2009, 2005, or 2003');
      select_year()}
}

# This makes the actual list of data, by year, that will make the final dataframe
make_list<-function(links=NULL,year=NULL){
  links<-get_links()  #though quick, would be nice to check to see if it's been read before
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
  return(mylist)
}


## This function is used for some years.  It removes dobule spaces and replaces
# with eventual single tabs, making read.delim functional

recursive_replace<-function(text=text){
  text<-gsub('([[:alpha:]]) {2}([[:alpha:]])','\1 \2',text)
  while (grepl(' {2}',text)){
    text<-gsub(' {2}','\t',text)
  }
  while (grepl('\t\t|\t \t',text)){
    text<-gsub('\t\t|\t \t','\t',text)
    print (grepl('\t\t|\t \t',text))
  }
  return(text)
}

mylist<-make_list()
mylist_bak<-mylist
#mylist<-mylist_bak
str(mylist)



## For 2003,2005

for (i in 1:length(mylist)){
  mylist[[i]][1]<-recursive_replace(mylist[[i]][1])
  mylist[[i]][1]<-gsub('\t *\r','\r',mylist[[i]][1])
}


df_list<-list()
for (i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  text<-gsub('ET-PU  MP  %FT','ET-PU     MP     %FT',text)
  text<-recursive_replace(text)
  df_list[[i]]<-cbind(mylist[[i]][2],read.delim(textConnection(text),
                                                header=F,
                                                strip.white=T,
                                                skip=2,
                                                stringsAsFactors=F)
  )

  if(length(df_list[[i]])>7){
    ifelse(sum(is.na(df_list[[i]][,8]))!=nrow(df_list[[i]]),
           print("error in read.delim; data in extra column"),
           df_list[[i]]<-df_list[[i]][,-8])
  }
}


final_df_2005<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df_2005)<-c('Institution','Employee','Job_title','Salary')
final_df_2005$Salary<-as.numeric(final_df_2005$Salary)
final_df_2005<-final_df_2005[(is.na(final_df_2005$Salary))==F,]
#final_df_2005$Employee<-gsub('Z,',',',final_df_2005$Employee)
final_df_2005$et<-NA
final_df_2005$mp<-NA
final_df_2005$percent_ft<-NA
head(final_df_2005)


# 2003-2005  has 5 columns (like 2011), and should be read with read.delim like 2011

# This works for: 2007, 2009:

df_list<-list()
for (i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  text<-gsub('ET-PU  MP  %FT','ET-PU     MP     %FT',text)
  text<-recursive_replace(text)
  df_list[[i]]<-cbind(mylist[[i]][2],read.delim(textConnection(text),
                                                header=F,
                                                strip.white=T,
                                                skip=2,
                                                stringsAsFactors=F)
  )

}

final_df_2009<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df_2009)<-c('Institution','Employee','Job_title','et','mp','percent_ft','Salary')
final_df_2009<-final_df_2009[(is.na(final_df_2009$Salary))==F,]
final_df_2009<-final_df_2009[,c(1:3,7,4:6)]
head(final_df_2009)
##########
##########
##########
##For 2011:  Note that Z is added to all last names
mylist<-mylist_bak


for(i in 1:length(mylist)){ #ideally this should be an apply funciton
  mylist[[i]][1]<-gsub('^\n|(\r\n){2,}','\r\n',mylist[[i]][1])
}

test<-vector("list",length(mylist))  # this simply works for finding the name.  Now salary and title need distinguishing
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
colnames(final_df_2011)<-c('header','Institution','Year','Employee','Job_title','Salary')
final_df_2011$Salary<-as.numeric(final_df_2011$Salary)
final_df_2011<-final_df_2011[(is.na(final_df_2011$Salary))==F,]
final_df_2011$Employee<-gsub('Z,',',',final_df_2011$Employee)
final_df_2011$et<-NA
final_df_2011$mp<-NA
final_df_2011$percent_ft<-NA
head(final_df_2011)




df<-rbind(final_df_2009,final_df_2011)

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
