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
names[,4]<-'CompInMil'

colnames(df)<-names

df<-df[c(-1),]
rownames(df)<-NULL
a=NULL
for (i in 1:length(df)){
  a<-cbind(a,as.character(df[,i]))
}
colnames(a)<-colnames(df)

df<-(a)
df<-gsub('\\$|\\*','',df,ignore.case=T)
df[,4]<-gsub(' ','',df[,4],ignore.case=T)
df<-as.data.frame(df)
df[,4]<-as.numeric(as.character(df[,4]))

df[df[,4]>30 | df[,4]<21,]

df %>% filter(CompInMil>20)


library(RCurl)
library(httr)
url<-'https://inside.seattlecolleges.edu/enrollment/content/displayReport.aspx?col=063&q=B563&qn=Winter%2016&nc=false&in=&cr= HTTP/1.1'

r<-GET(url,authenticate(user,pass),verbose())


r<-GET('https://inside.seattlecolleges.edu/enrollment/content/displayReport.aspx?col=063&q=A233&qn=Winter%2003&nc=false&in=&cr=',authenticate(user,pass),verbose())

url='https://inside.seattlecolleges.edu/enrollment/content/displayReport.aspx'

college <- '063'
quarter <- 'B233'
quartName<- 'Winter 13'
ExcludeCancelled <- 'false'
itemNumber<-''
credit<-''

qlist=list(col=college,q=quarter,qn=quartName, nc =  ExcludeCancelled ,'in'=itemNumber,cr=credit)
r<-GET( modify_url(url, query = qlist, username=user,password = pass),httpauth = 1L)

r<-GET( url,  query = qlist, authenticate(user,pass,'basic'),verbose())
objects(r)
content(r)$date
r$url
r$content




urlEnrol<-'https://inside.seattlecolleges.edu/default.aspx?svc=enrollment&page=enrollment'

body = list("ctl08$ddlCollegeView" = "063", "ctl08_ddlQuarterView" = "B453")
r<-POST( urlEnrol, body=body, encode = 'form', authenticate(user,pass,'basic'), verbose())

saveXML(content(r),file = "/home/brian/Projects/data/enrollPostTest.xml")







url<-'https://inside.seattlecolleges.edu/enrollment/content/displayReport.aspx?col=063&q=B453&qn=Winter%2015&nc=false&in=&cr='

<form name="form1" method="post" action="default.aspx?svc=enrollment&amp;page=enrollment" id="form1">


  <select name="ctl08$ddlCollegeView" id="ctl08_ddlCollegeView">
  <option value="062">Central</option>
  <option selected="selected" value="063">North</option>
  <option value="064">South</option>
  <option value="065">SVI</option>

  </select>


  <select name="ctl08$ddlQuarterView" id="ctl08_ddlQuarterView">
  <option value="B343">Winter 14</option>
  <option value="B344">Spring 14</option>
  <option value="B451">Summer 14</option>
  <option value="B452">Fall 14</option>
  <option value="B453">Winter 15</option>
  <option value="B454">Spring 15</option>
  <option value="B561">Summer 15</option>
  <option value="B562">Fall 15</option>
  <option selected="selected" value="893">Winter 1999</option>

  </select>



  <a onclick="clickChoice.reportChoice='all';return ValidateAndOpenWindow2('ctl08_lblItemRequired', 'ctl08_lblCollegeRequired', 'ctl08_txtItemNum', 'ctl08_optAll', 'ctl08_optSingle', 'ctl08_optClassList', 'ctl08_optElearn', 'ctl08_ddlCollegeView', 'ctl08_ddlQuarterView', 'ctl08_chkNonCancelled', '0', 'enrollment/content/displayReport.aspx', 900, 600);" id="ctl08_optAll" class="btnViewReport" href='javascript:WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions("ctl08$optAll", "", false, "", "enrollment/content/#", false, true))'>View Report</a>




  b2 <- "http://httpbin.org/post"
POST(b2, body = "A simple text string")
POST(b2, body = list(x = "A simple text string"))
POST(b2, body = list(y = upload_file(system.file("CITATION"))))
POST(b2, body = list(x = "A simple text string"), encode = "json")