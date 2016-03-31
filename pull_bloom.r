##
# After links are made, the creation of 'mylist' is used,
# then followed by tailored read.table commands
##

library(rvest)
library(XML)
library(stringr)

###
# The following reads the first URL and scrapes the links for the
#  colleges, opens each, creates 1 big dataframe for that year.


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
str(links)

# The following loops through 'links', using the URL to read the html
# and pull the text out of the <pre> tag
# then adds it to 'mylist', a nested list
make_list<-function(links,year){
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

mylist<-make_list(links,'2011')
mylist_bak<-mylist
#mylist<-mylist_bak
str(mylist)


#######PROBLEM.  2001-2009 HAS ODD 'FWF', or other odd column formats.  Yuck
# Several pages have different lines to 'skip'.  fuck off

# go here https://www.youtube.com/watch?feature=player_detailpage&v=q8SzNKib5-4#t=945

#2001 has tab deliminted data, name, title, salary, but many have 2 column sets!!!!! fuck off lbloom
#2003 has tab deliminted data, name, title, salary; also astricks first letter first name
#2005 has mulit-tab deliminted data, name, title, salary
#2007 has fwf data, but 6 columns: name, title,  ET-PU, MP, %FT, Salary

#2011 almost works--needs to fix employee extra spaces; fwf data, name, title, salary  but et-pu, mp,%ft are added as NA to rbind with others
##after running code for 2011 and making data frame, try:
#table(final_df_2011[grep(' {2,}',final_df_2011$Employee,value=F),1])



#2009 works; columsn resorted to "institution, employee, title, salary, et-pu, mp,%ft"

############
########
###For 2009:

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

final_df_2009<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df_2009)<-c('Institution','Employee','Job_title','et','mp','percent_ft','Salary')
final_df_2009<-final_df_2009[(is.na(final_df_2009$Salary))==F,]
final_df_2009<-final_df_2009[,c(1:3,7,4:6)]
##########
##########
##########
##For 2011:  Note that Z is added to all last names
mylist<-mylist_bak
#I think the culprit is those \r\n multiples.  Maybe first do a recursive replace on all \r\n duplicates into 1, then proceed

for(i in 1:length(mylist)){ #ideally this should be an apply funciton
  mylist[[i]][1]<-gsub('(\r\n){2,}','\r\n',mylist[[i]][1])
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
for (i in 1:length(mylist)){
  lhs1<-paste0('(\n.{', n[i],'})')
  lhs2<-paste0('(\n.{', t[i],'})')
  lhs3<-paste0('(\n.{', s[i],'})')
  mylist[[i]][1]<-gsub(lhs1,rhs,mylist[[i]][1])  #this adds a tab after last space before title.
  mylist[[i]][1]<-gsub(lhs2,rhs,mylist[[i]][1])  #this adds a tab 10 spaces before  end of line (salary)
  mylist[[i]][1]<-gsub(lhs3,rhs,mylist[[i]][1])  #this adds a tab 10 spaces before  end of line (salary)
  mylist[[i]][1]<-gsub('Earnings\r\n\t','Earnings\r\n',mylist[[i]][1])
  mylist[[i]][1]<-recursive_replace(mylist[[i]][1])
}
substr(mylist[[1]][1],1,300)
###The code above is inconsistently creating tabs.  See i=4, 5, 6,7; check wid and the gsub 'n' position on notepad
##Item #6, eastern state has a case where there are no spaces between end of name and beginning of job title.
#But this does't explain why for that school, the job start number is '34' when on note pad it's 33.  job start number should be on '32' (33-1)

for ( i in 1:36)(print(paste(i,substr(mylist[[i]][1],1,s[i]+100))))


#Next, use do.call to perform this function on each element of mylist


###then consider a better recursive replacing of \t, using a base case of recurision?
i=1
text<-mylist[[i]][1]
head(read.delim(textConnection(text),
           header=F,
           strip.white=T,
           skip=1,
           stringsAsFactors=F),10)
wid[[36]]
n[36]
s[36]


if(length(df_list[[i]])>4){
  ifelse(sum(is.na(df_list[[i]][,5]))!=nrow(df_list[[i]]),
         print("error in read.delim; data in extra column"),
         df_list[[i]]<-df_list[[i]][,-5])
}

df_list<-vector("list",length(mylist))
for(i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  df_list[[i]]<-cbind(mylist[[i]][2],read.delim(textConnection(text),
                                                header=F,
                                                strip.white=T,
                                                skip=1,
                                                stringsAsFactors=F)
  )

}

sapply(df_list,length)####for some reason some of the colleges have 5 columns instead of 4

final_df_2011<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df_2011)<-c('Institution','Employee','Job_title','Salary')
final_df_2011$Salary<-as.numeric(final_df_2011$Salary)
final_df_2011<-final_df_2011[(is.na(final_df_2011$Salary))==F,]
final_df_2011$Employee<-gsub('Z,',',',final_df_2011$Employee)
final_df_2011$et<-NA
final_df_2011$mp<-NA
final_df_2011$percent_ft<-NA
head(final_df_2011)




df<-rbind(final_df_2009,final_df_2011)
str(df)
table(is.na(df$Salary))
median(df$Salary)
