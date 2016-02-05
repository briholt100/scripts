library(rvest)
library(XML)

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


#...done....2011 has fwf data, name, title, salary
"""
############
#########
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
#2009 has fwf data, but 6 columns: name, title,  ET-PU, MP, %FT, Salary

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

##For 2009:
wid<-list()
for(i in 1:length(mylist)){
  text<-as.character(mylist[[i]][1])
  title_start<-gregexpr('  [A-Z]',substr(text,101,200))
  num_col_start<-gregexpr('   [0-9]',substr(text,101,200))  # this should pick up the last 4 cols
  end_point<-gregexpr('\\r\\n',substr(text,3,205))
  wid[[i]]<-c(title_start[[1]][1]-2,
              num_col_start[[1]][1]-title_start[[1]][1],
              num_col_start[[1]][2]-num_col_start[[1]][1],
              num_col_start[[1]][3]-num_col_start[[1]][2],
              8,
              19     )

}

trial<-read.fwf(textConnection(mylist[[1]]),widths=wid[[1]],skip=2,strip.white=T)
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
colnames(final_df)<-c('Institution','Employee','Job_title','Salary')
final_df$Salary<-as.numeric(final_df$Salary)
str(final_df)
head(final_df)
tail(final_df)
final_df<-final_df[(is.na(final_df$Salary))==F,]
mean(as.numeric(final_df$Salary))
boxplot(final_df$Salary~final_df$Job_title)
