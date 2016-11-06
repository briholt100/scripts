#######
#  Need to pull the sbctc data

library('lme4')
library('nlme')
library('stringr')
library('plyr')
library('dplyr')
library('data.table')
library('tidyr')
library('ggplot2')
library('Hmisc')
library('XML')
library('httr')
library('rvest')
#####
#set wd
####
#Campus
#wrkdir<-'I:/My Data Sources/'
#Home
wrkdir<-'/home/brian/Projects/scripts'

setwd(wrkdir)

fileUrl <- 'http://fiscal.wa.gov/WaStEmployeeHistSalary.txt'

if (!file.exists("../Data")) {
  dir.create("../Data")
  }

######
# Check if data already exists; if not, download it.
######

#do a join of wrkdir with data/textFile.

ifelse (!file.exists('../Data/WaStEmployeeHistSalary.txt')
        , download.file(fileUrl, '../Data/WaStEmployeeHistSalary2015.txt', method='auto')
        , "file exists")




#test<-fread("grep 'College' /home/brian/Projects/data/WaStEmployeeHistSalary.txt",sep='\t')

#fread("grep 'Holt' /home/brian/Projects/data/addresses.csv")

#campus
#salary<-read.csv('../Data/WaStEmployeeHistSalary2015.txt',                 sep=',' ,stringsAsFactors=T,strip.white=T,na.strings=c('0',''))
#note, that a file by the name .txt1 also exists, \t delim

#home
salary<-read.csv("../Data/WaStEmployeeHistSalary.txt", #use .txt1 for campus
                 sep='\t' ,stringsAsFactors=T,strip.white=T,na.strings=c('0',''))

##convert variables to factors or numeric
salary[,1]<-as.factor(salary[,1])
##This, in one step, removes commas from salary data and converts to numeric
salary[,5:8]<-sapply(salary[,5:8], FUN = function(x) as.numeric(gsub(",","",x)))
#
# below is the money earned by Pete at Edmonds.  For some reason, the main file shows he worked at edmonds but received no money; I then saved it
salary[56855,5]<-8732
#write.table(salary,'./Data/WaStEmployeeHistSalary.txt',sep='\t')
#write.table(salary,"/home/brian/Projects/Data/WaStEmployeeHistSalary.txt",sep='\t')
salary<-(rename(salary,Sal2014=Sal20141))
str(salary)

salary$job.cat<-"other"



colleges<-salary[grep('college|university|State Board for Comm and Tech Coll',salary$Agency,ignore.case=T),]
colleges<-droplevels(colleges)
ColNames<-colnames(colleges)
ColNames[1]<-"Code"
colnames(colleges)<-ColNames
collegeCodes<-sort(unique(colleges$Code))
head(colleges)

Agency_code<-unique(colleges[c("Code","Agency_Title")])

#creates a total across years
colleges$TotSal<-apply(colleges[,5:8],1,sum,na.rm=T)


#convert job.cat from other.
#grep out faculty and non faculty, then split those two categories into above median and below

colleges$job.cat<-ifelse(grepl("facul|FTF|fac sub|pt-fac|pro-rata",colleges$job_title,ignore.case=T),"Faculty","Non-fac")
"""
ApplyQuintiles <- function(x) {
  cut(x, breaks=c(quantile(colleges$TotSal, probs = seq(0, 1, by = 0.20))),
      labels=c("0-20","20-40","40-60","60-80","80-100"), include.lowest=TRUE)
}
colleges$Quintile <- sapply(colleges$TotSal, ApplyQuintiles)
table(colleges$Quintile)"""

"""I could apply quintiles by subsetting totsal by faculty non faculty, which would mean in calling those numbers they'd have to be conditional: quintiles when faculty is true, when not true, etc'"""


colleges$Median<- ifelse(colleges$job.cat=="Faculty",
                         cut2(colleges$TotSal,cuts= quantile(colleges$TotSal[colleges$job.cat=="Faculty"],na.rm=T,probs=seq(0,1,.33))),
                         cut2(colleges$TotSal,cuts= quantile(colleges$TotSal[colleges$job.cat!="Faculty"],na.rm=T,probs=seq(0,1,.33))))



seattle<-colleges[grep('seattle',colleges$Agency,ignore.case=T),  ]
seattle<-seattle[,c(1:4,9,11,5:8,10)]
sea_long<-gather(seattle,year,Salary,Sal2012:Sal2015)

colleges_longForm<-gather(colleges,year,Salary,Sal2012:Sal2015)

levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2011"] <- "2011"
levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2012"] <- "2012"
levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2013"] <- "2013"
levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2014"] <- "2014"

"""levels(sea_long$year)[levels(sea_long$year)=="Sal2015"] <- "2015"
levels(sea_long$year)[levels(sea_long$year)=="Sal2012"] <- "2012"
levels(sea_long$year)[levels(sea_long$year)=="Sal2013"] <- "2013"
levels(sea_long$year)[levels(sea_long$year)=="Sal2014"] <- "2014"
"""
colleges_longForm$et<-NA
colleges_longForm$mp<-NA
colleges_longForm$percent_ft<-NA
head(colleges_longForm)

write.table(colleges_longForm,'./salaryByYear.txt',sep='\t')


sea_long$job.cat<-as.factor(sea_long$job.cat)
str(sea_long)
deans<-seattle[grep('dean',seattle$Job,ignore.case=T,value=F),]
head(deans)

apply(deans[,5:8],2,mean,na.rm=T)
lortz<-colleges[grep('lortz',colleges$Employee,ignore.case=T),]

enrollments<-c(18880,  18643,  19118,	19262) #enrollments for 2012-2015
year<-c("x2012","x2013","x2014","x2015")
year<-as.factor(year)
enrol_df<-data.frame(year,enrollments)

levels(enrol_df$year)[levels(enrol_df$year)=="x2015"] <- "2015"
levels(enrol_df$year)[levels(enrol_df$year)=="x2012"] <- "2012"
levels(enrol_df$year)[levels(enrol_df$year)=="x2013"] <- "2013"
levels(enrol_df$year)[levels(enrol_df$year)=="x2014"] <- "2014"

sea_long<-sea_long[complete.cases(sea_long),]


p<-ggplot(sea_long,aes(x=year,y=Salary))
p+geom_boxplot()+
  facet_grid(job.cat~Median)+
  geom_line(data=enrol_df,aes(x=year,y=enrollments,color=1,group=1))+
  labs(title = "Seattle salary by median salary within job category")

facTertial<-as.data.frame(quantile(colleges$TotSal[colleges$job.cat=="Faculty"],na.rm=T,probs=seq(0,1,.33)))

#to see a line of mean salary (or median, might need to do a tapply into a dataframe, use that in the layer)

p+geom_jitter(data=sea_long[sea_long$job.cat == "Faculty",],aes(color=job.cat))+
#  geom_line(data=enrol_df,aes(x=year,y=enrollments,group=1))+
  geom_line(data=sea_long[sea_long$job.cat == "Faculty",],aes(x=year, y = median(Salary,na.rm=T)))


table(sea_long$job.cat,sea_long$job_title)
