library(rvest)
library(XML)
library(stringr)

###
# The following reads the first URL and scrapes the links for the
#  colleges, opens each, creates 1 big dataframe for that year.


d<-"http://lbloom.net/index"   # for "code book" see http://lbloom.net/dshsz.html
d_yr<-c('01','03','05','07','09','11')
d_pg<-".html"
page_list<-list()
for (i in 1:length(d_yr)){
     url<-paste0(d,d_yr[i],d_pg) # Gets all links in code using XML::getHTMLLink
     bloom<-htmlTreeParse(url,useInternalNodes=T) # for xpath to work below, 'T'
     page_list[[i]]<-bloom
}

searchTerms<- "//a[contains(text(),' Col ')] |
//a[contains(text(),'WSU')] |
//a[contains(text(),'Olympic Co')] |
//a[contains(text(),'Univ ')] "

links<-list()
for (i in 1:length(page_list)){
       # This pulls the <a> names of link
  links[[i]]<-cbind(xpathSApply(page_list[[i]],searchTerms,xmlValue),
                # This pulls the links themselves.
             getHTMLLinks(page_list[[i]],xpQuery=gsub(']',']/@href',searchTerms)))
}
links<-do.call('rbind',links)
str(links)

#######PROBLEM.  2001-2009 HAS ODD 'FWF', or other odd column formats.  Yuck
# Several pages have different lines to 'skip'.  fuck off



# go here https://www.youtube.com/watch?feature=player_detailpage&v=q8SzNKib5-4#t=945

#2009 has fwf data, but 6 columns: name, title,  ET-PU, MP, %FT, Salary
#...done....2011 has fwf data, name, title, salary
"""
############
########
###For 2009:
wid<-list()
#i=3
for(i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  title_start<-gregexpr('  [A-Z]',substr(text,102,200))
  emp_type_start<-gregexpr('   [0-9](M|D|C|H)',substr(text,102,200))
  num_col_start<-gregexpr('   [0-9]',substr(text,102,200))# this should pick up the last 4 cols
  end_point<-gregexpr('\\r\\n',substr(text,1,200))
  wid[[i]]<-c(title_start[[1]][1]-2,
              num_col_start[[1]][1]-title_start[[1]][1],
              num_col_start[[1]][2]-num_col_start[[1]][1],
              num_col_start[[1]][3]-num_col_start[[1]][2],
              8,#num_col_start[[1]][4]-num_col_start[[1]][3],
              end_point[[1]][2]-num_col_start[[1]][4]+20     )
}

##For 2011:  Note that Z is added to all last names
wid<-list()
for(i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  title_start<-gregexpr('  [A-Z]',substr(text,1,200))
  #name_width<-gregexpr('^+',test)  OY, THIS ISN'T EVEN NEEDED
  sal_start<-gregexpr(' [0-9]',substr(text,1,200))
  wid[[i]]<-c(title_start[[1]][1]-3,sal_start[[1]][1]-title_start[[1]][1]+5,40)
  ###Notice that sal_width might need to pick the 2nd element [[1]][2]
}
"""
#2001 has tab deliminted data, name, title, salary, but many have 2 column sets!!!!! fuck off lbloom
#2003 has tab deliminted data, name, title, salary; also astricks first letter first name
#2005 has mulit-tab deliminted data, name, title, salary
#2007 has fwf data, but 6 columns: name, title,  ET-PU, MP, %FT, Salary


#  Let's start with 2009 and move back, go back to 2001
links<-links[ grep("2009",links),]
links<-links[-c(1:3),]
links<-links[c(1:3),]

# The following loops through 'links', using the URL to read the html
# and pull the text out of the <pre> tag
# then adds it to 'mylist', a nested list
mylist<-list()
for (i in 1:nrow(links)){
  text<-links[i,2] %>% url %>% read_html() %>%
    html_nodes(xpath= '//pre')%>%
    html_text(trim=F) #this pulls out the actual pre text
  mylist[[i]]<-text  # This puts the text into each element
  mylist[[i]][2]<-links[i,1] # Puts agency info into the 2nd element of the list
}
str(mylist[1])
mylist<-mylist[1]

##For 2009:
text<-as.character(mylist[[i]][1])
recursive_replace<-function(text=text){
  text<-gsub(' {2}',' ',text)
  while (grepl(' {2}',text)){
    text<-gsub(' {2}','\t',text)
  }
  while (grepl('\t\t',text)){
    text<-gsub('\t\t','\t',text)
    print (grepl('\t\t',text))
  }
  return(text)
}

# The following loops through each element of 'mylist',
    #  adds a 4 column dataframe to newly created 'df_list'

######
# This works except for UW, b/c the last few columns are separated by 2 spaces
# which makes my recursive replace backfire in the first iteration.
s<-readLines(textConnection(mylist[[3]][1]))

#Do bunch of gsubs using recursive_replace

s<-recursive_replace(textConnection(mylist[[3]][1]))

s.df<-read.delim(textConnection(s),header=F,skip=2,strip.white=T,stringsAsFactors=F)

i=1
df_list<-list()
for (i in 2:length(mylist)){
  text<-as.character(mylist[[i]][1])
  text<-gsub('ET-PU  MP  %FT','ET-PU     MP     %FT',text)
  text<-recursive_replace(text=text)
  df_list[[i]]<-cbind(mylist[[i]][2],read.delim(textConnection(text),
              header=F,
              strip.white=T,
              skip=2)
              )
  if(length(df_list[[i]])>7){
    ifelse(sum(is.na(df_list[[i]][,8]))!=nrow(df_list[[i]]),
      print("error in read.delim; data in extra column"),
      df_list[[i]]<-df_list[[i]][,-8])
    }
}

#col.names=c('Employee','Job_title','et','mp','percent_ft','Salary'

final_df<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df)<-c('Institution','Employee','Job_title','et','mp','percent_ft','Salary')
final_df$Salary<-as.numeric(final_df$Salary)
str(final_df)
head(final_df)
tail(final_df)
final_df<-final_df[(is.na(final_df$Salary))==F,]
mean(as.numeric(final_df$Salary))
boxplot(final_df$Salary~final_df$Job_title)
