library(dplyr)
library(tidyr)
library(XML)
theurl='http://americasmarkets.usatoday.com/2015/04/30/surprise-women-trump-men-on-ceo-pay/'

tables <- readHTMLTable(theurl)

n.rows <- unlist(lapply(tables, function(t) dim(t)[1]))

tables[[which.max(n.rows)]]

names<-as.matrix(tables[[1]][1,])

df<-data.frame(tables[[1]])

#Traditional Data tidying
names[,4]<-"CompInMil"

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

df %>% filter(CompInMil>20)




library(httr)
url="https://inside.seattlecolleges.com/enrollment/content/displayReport.aspx"
payload = {'col': '063', 'q': 'B343', 'qn': 'WINTER+14', 'nc': 'false', 'in': '', 'cr': ''}
payload_str = "&".join("%s=%s" % (k,v) for k,v in payload.items())

r<-GET("https://inside.seattlecolleges.com/",modify_url(url, query = "col=063&q=B343&qn=WINTER%2014&nc=false&in=&cr="), authenticate("user","!"))
r$url
r

paramlist=list("col=063","q=B343")
qlist=list("063","B343")
modify_url(url, query=qlist)





