library(dplyr)
library(XML)
theurl='http://americasmarkets.usatoday.com/2015/04/30/surprise-women-trump-men-on-ceo-pay/'

tables <- readHTMLTable(theurl)

n.rows <- unlist(lapply(tables, function(t) dim(t)[1]))

tables[[which.max(n.rows)]]
names<-as.matrix(tables[[1]][1,])
df<-data.frame(tables[[1]])
colnames(df)<-names
df<-df[c(-1),]
rownames(df)<-NULL
a=NULL
for (i in 1:length(df)){
  a<-cbind(a,as.character(df[,i]))
}
colnames(a)<-colnames(df)  
df<-(a)
df<-gsub("\\$|\\*","",df,ignore.case=T)
df[,4]<-gsub(" ","",df[,4],ignore.case=T)
df<-as.data.frame(df)
df[,4]<-as.numeric(as.character(df[,4]))

df[df[,4]>30 | df[,4]<21,]
