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

##For 2011:
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
#2003 has tab deliminted data, name, title, salary
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
############
#########
"""
text<-as.character(mylist[1])
r<-gregexpr('\\\\r\\\\n[A-Z]*, \\*[A-Z]* [A-Z]*\\\\t',text)
regmatches(text,emp_type_start)
"""
grepexpr('')
##For 2009:
wid<-list()
i=3
spaces<-gregexpr('[[:alnum:]] {4,}[[:alnum:]]',substr(text,1,102))
s<-regmatches(text,spaces)

#The following does appear to split the columns by spaces numbering more than 4
space_list<-list()
for (i in 1:length(spaces[[1]])){
  space_list[i]<-(substr(text,spaces[[1]][i],
               spaces[[1]][i]+
                 attr(spaces[[1]],'match.length')[i]))
}


last<-regexec('([[:print:]]*,)',substr(text,100,400))
regmatches(text,last)

last<-gregexpr('([[:print:]]*,){1}',text)
lst<-regmatches(text,last)
Emp_name<-gregexpr('(\\n[A-Z]+[ -]*[A-Z]*,)',text,perl=T)
Emp_name<-gregexpr('[[:print:]]*  ',text,perl=T)

employee<-regmatches(text,Emp_name)
employee


, [A-Z]* [[:graph:]]* [A-Z]{0,2})


Emp_name<-gregexpr('\\n([[:print:]]*[A-Z]{1}), [[:graph:]]* [[:graph:]]* [A-Z]{0,2}  ',
                   text
                   )
employee<-regmatches(text,Emp_name)
employee





for(i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  white_space<-gregexpr(white,text)
  attr(white_space[[1]], 'match.length')[1]

  ########check stringr
  w<-regmatches(text,white_space)
  title_start<-gregexpr(paste0(title_string,),text)
  title<-regmatches(text,title_start)
title
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
wid
i=1
trial<-read.fwf(textConnection(mylist[[i]]),widths=wid[[i]],skip=2,strip.white=T)
head(trial)



# The following loops through each element of 'mylist',
    #  adds a 4 column dataframe to newly created 'df_list'


df_list<-list()
for (i in 1:length(mylist)){
  df_list[[i]]<-cbind(mylist[[i]][2],read.fwf(textConnection(mylist[[i]][1]),  # fwf also applies
                                         header=F,
                                         strip.white=T,
                                         widths=wid[i],
                                         skip=2,
                                         col.names=c('Employee','Job_title','et','mp','percent_ft','Salary')
  ))

}
final_df<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df)<-c('Institution','Employee','Job_title','et','mp','percent_ft','Salary')
final_df$Salary<-as.numeric(final_df$Salary)
str(final_df)
head(final_df)
tail(final_df)
final_df<-final_df[(is.na(final_df$Salary))==F,]
mean(as.numeric(final_df$Salary))
boxplot(final_df$Salary~final_df$Job_title)
