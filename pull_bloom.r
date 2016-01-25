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
mylist<-list()
for (i in 1:nrow(links)){
  text<-links[i,2] %>% url %>% read_html() %>% html_nodes (xpath= '//pre')%>%html_text(trim=F) #this pulls out the actual pre text
  mylist[[i]]<-text
  mylist[[i]][2]<-links[i,1]
}

df<-list()
for (i in 1:length(mylist)){
  df[[i]]<-cbind(mylist[[i]][2],read.fwf(textConnection(mylist[[i]][1]),
                                         widths=c(32,32,81),
                                         skip=3,
                                         col.names=c('Employee','Job_title','Salary')
  ))

}
final_df<-do.call("rbind",df)