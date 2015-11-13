library('dplyr')
library('data.table')
library(tidyr)
#####
#set wd
####
#Campus
setwd('I:/My Data Sources/')
#Home

fileUrl <- 'http://fiscal.wa.gov/WaStEmployeeHistSalary.txt'
if (!file.exists("Data")) {
  dir.create("Data")
  }

######
# Check if data already exists; if not, download it.
######

if (!file.exists(fileUrl)) {
  download.file(fileUrl, './Data/WaStEmployeeHistSalary.txt', method='auto')
}



test<-fread("grep 'College' /home/brian/Projects/data/WaStEmployeeHistSalary.txt",sep='\t')

fread("grep 'Holt' /home/brian/Projects/data/addresses.csv")

#campus
salary<-read.csv('./Data/WaStEmployeeHistSalary.txt',
                 sep='\t' ,stringsAsFactors=T,strip.white=T,na.strings=c('0',''))


#home
salary<-read.csv("/home/brian/Projects/data/WaStEmployeeHistSalary.txt",
                 sep='\t' ,stringsAsFactors=T,strip.white=T,na.strings=c('0',''))
#
# below is the money earned by Pete at Edmonds.  For some reason, the main file shows he worked at edmonds but received no money; I then saved it
#salary[56855,5]<-8732
#write.csv(salary,"/home/brian/Projects/data/WaStEmployeeHistSalary.txt",sep='\t')

##convert variables to factors or numeric
salary[,1]<-as.factor(salary[,1])
##This, in one step, removes commas from salary data and converts to numeric
salary[,5:8]<-sapply(salary[,5:8], FUN = function(x)as.numeric(gsub(",","",x)))
#
# below is the money earned by Pete at Edmonds.  For some reason, the main file shows he worked at edmonds but received no money; I then saved it
#salary[56855,5]<-8732
#write.csv(salary,'./Data/WaStEmployeeHistSalary.txt',sep='\t')
#write.csv(salary,"/home/brian/Projects/data/WaStEmployeeHistSalary.txt",sep='\t')
str(salary)

colleges<-salary[grep('college',salary$Agency,ignore.case=T),]
colleges<-droplevels(colleges)
str(colleges)

seattle<-salary[grep('seattle',salary$Agency,ignore.case=T),]
seattle<-droplevels(seattle)
str(seattle)

deans<-seattle[grep('dean',seattle$Job,ignore.case=T,value=F),]
head(deans)

apply(deans[,5:8],2,mean,na.rm=T)
lortz<-colleges[grep('lortz',colleges$Employee,ignore.case=T),]

#Must change wide columns to tall, so that the 4 years 2011-2014 are in one variable, year

dt<-lortz%>%gather(year,value,-Job.Title,-Employee,-Agency,-Code,na.rm=T)
plot(dt$year,dt$value)



#What comes below is from a different script attempting to wrangle the job title list
"


adminOther.list<-grep("admin", sccd.salary$Job.Title, ignore.case=T, value=F)
chancellor.list<-grep("chance", sccd.salary$Job.Title, ignore.case=T, value=F)
childhood.list<-grep("childho", sccd.salary$Job.Title, ignore.case=T, value=F)
communication.list<-grep("commun", sccd.salary$Job.Title, ignore.case=T, value=F)
coordination.list<-grep("coord,", sccd.salary$Job.Title, ignore.case=T, value=F)
counselor.list<-grep("counselo", sccd.salary$Job.Title, ignore.case=T, value=F)
dean.list<-grep("dean|assistant d|ASSOC. DEAN", sccd.salary$Job.Title, ignore.case=T)
director.list<-grep("dir", sccd.salary$Job.Title, ignore.case=T) #, value=T)
exec.list<-c(grep("exec. d", sccd.salary$Job.Title, ignore.case=T))
facilities.list<-grep("facilit|custo|electr|grounds|locks|maintan|mechanic", sccd.salary$Job.Title, ignore.case=T, value=F)
faculty.list<-grep("faculty", sccd.salary$Job.Title, ignore.case=T)
finance.list<-grep("financ|budget|capita|fiscal", sccd.salary$Job.Title, ignore.case=T, value=F)
hour.list<-grep("hour", sccd.salary$Job.Title, ignore.case=T, value=F)
HR.list<-grep("HR|benefits|human|payrol", sccd.salary$Job.Title, ignore.case=T, value=F)
library.list<-grep("librar", sccd.salary$Job.Title, ignore.case=T, value=F)
mail.list<-grep("mail", sccd.salary$Job.Title, ignore.case=T, value=F)
manager.list<-c(grep("mgr", sccd.salary$Job.Title, ignore.case=T), grep("manag", sccd.salary$Job.Title, ignore.case=T))
media.list<-grep("media", sccd.salary$Job.Title, ignore.case=T, value=F)
officeAssist.list<-grep("office assistant|PROGRAM ASSISTANT|ADMINISTRATIVE ASSIST", sccd.salary$Job.Title, ignore.case=T)
president.list<-grep("presi|v.c.,|chief", sccd.salary$Job.Title, ignore.case=T, value=F)
programCoord.list<-grep("program coord", sccd.salary$Job.Title, ignore.case=T, value=F)
retail.list<-grep("retail", sccd.salary$Job.Title, ignore.case=T, value=F)
secretary.list<-grep("secr|exec. a", sccd.salary$Job.Title, ignore.case=T) #, value=T)
security.list<-grep("security", sccd.salary$Job.Title, ignore.case=T, value=F)
specialist.list<-grep("spec", sccd.salary$Job.Title, ignore.case=T, value=F)
supervisory.list<-grep("superv|spv", sccd.salary$Job.Title, ignore.case=T, value=F)
support.list<-grep("supt", sccd.salary$Job.Title, ignore.case=T, value=F)
vice.list<-grep("vice p|vp", sccd.salary$Job.Title, ignore.case=T, value=F)


sccd.salary$job.cat<-factor(sccd.salary$job.cat,
sort(c(
"admin (Other)",
"assistant",
"chancellor",
"childhood",
"communication",
"coordination",
"counselor",
"dean",
"director",
"executive",
"facilities",
"faculty",
"finance",
"hourly",
"HR",
"library",
"mail",
"manager",
"media",
"other",
"pres",
"program coordinator",
"retail",
"secretary",
"security",
"specialist",
"supervisory",
"support",
"vicepres"
)
))

##WARNING; BEWARE OF CHANGING ORDER BELOW, ELSE CATEGORIES WILL CHANGE

sccd.salary$job.cat[adminOther.list]<-"admin (Other)"
sccd.salary$job.cat[HR.list]<-"HR"
sccd.salary$job.cat[security.list]<-"security"
sccd.salary$job.cat[finance.list]<-"finance"
sccd.salary$job.cat[facilities.list]<-"facilities"
sccd.salary$job.cat[mail.list]<-"mail"
sccd.salary$job.cat[media.list]<-"media"
sccd.salary$job.cat[communication.list]<-"communication"
sccd.salary$job.cat[coordination.list]<-"coordination"
sccd.salary$job.cat[support.list]<-"support"
sccd.salary$job.cat[library.list]<-"library"
sccd.salary$job.cat[supervisory.list]<-"supervisory"
sccd.salary$job.cat[counselor.list]<-"counselor"
sccd.salary$job.cat[retail.list]<-"retail"
sccd.salary$job.cat[specialist.list]<-"specialist"
sccd.salary$job.cat[programCoord.list]<-"program coordinator"
sccd.salary$job.cat[director.list]<-"director"
sccd.salary$job.cat[hour.list]<-"hourly"
sccd.salary$job.cat[faculty.list]<-"faculty"
sccd.salary$job.cat[dean.list]<-"dean"
sccd.salary$job.cat[childhood.list]<-"childhood"
sccd.salary$job.cat[manager.list]<-"manager"
sccd.salary$job.cat[exec.list]<-"executive"
sccd.salary$job.cat[secretary.list]<-"secretary"
sccd.salary$job.cat[officeAssist.list]<-"assistant"
sccd.salary$job.cat[chancellor.list]<-"chancellor"
sccd.salary$job.cat[president.list]<-"pres"
sccd.salary$job.cat[vice.list]<-"vicepres"

director.salary<-sccd.salary[director.list,]
dean.salary<-sccd.salary[dean.list,]
sec.salary<-sccd.salary[secretary.list,]
director.salary<-sccd.salary[director.list,]

"
