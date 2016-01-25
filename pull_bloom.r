library(rvest)
library(XML)

###
#The following reads the first URL and scrapes the links for the colleges, opens each, creates 1 big dataframe for that year.


url<-"http://lbloom.net/index11.html" # use this to get all links in the code using XML package getHTMLLink
bloom<-htmlTreeParse(url,useInternalNodes=T)  # for the xpath to work below, True

searchTerms<- "//a[contains(text(),' Col ')] |
//a[contains(text(),'WSU')] |
//a[contains(text(),'Olympic Co')] |
//a[contains(text(),'Univ ')] "
links<-cbind(xpathSApply(bloom,searchTerms,xmlValue), # this pulls the <a> names of link
             getHTMLLinks(bloom,xpQuery=gsub(']',']/@href',searchTerms))) # this pulls the links themselves.


nrow(links)
head(links)

# The following loops through 'links', using the URL to read the html 
# and pull the text out of the <pre> tag
# then adds it to 'mylist', a nested list
mylist<-list()
for (i in 1:nrow(links)){
  text<-links[i,2] %>% url %>% read_html() %>% html_nodes (xpath= '//pre')%>%html_text(trim=F) #this pulls out the actual pre text
  mylist[[i]]<-text  # This puts the text into each element
  mylist[[i]][2]<-links[i,1] # Puts the agency information into the 2nd element of the list
}


# The following loops through each element of 'mylist', adds a 4 column dataframe to newly created 'df_list'
df_list<-list()
for (i in 1:length(mylist)){
  df_list[[i]]<-cbind(mylist[[i]][2],read.fwf(textConnection(mylist[[i]][1]),
                                         widths=c(32,32,81),
                                         skip=3,
                                         col.names=c('Employee','Job_title','Salary')
  ))

}
final_df<-do.call("rbind",df_list)  # this converts df_list into a dataframe.
colnames(final_df)<-c('Institution','Employee','Job_title','Salary')

