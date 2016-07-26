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
        , download.file(fileUrl, '../Data/WaStEmployeeHistSalary.txt', method='auto')
        , "file exists")




#test<-fread("grep 'College' /home/brian/Projects/data/WaStEmployeeHistSalary.txt",sep='\t')

#fread("grep 'Holt' /home/brian/Projects/data/addresses.csv")

#campus
#salary<-read.csv('../Data/WaStEmployeeHistSalary.txt1',                 sep='\t' ,stringsAsFactors=T,strip.white=T,na.strings=c('0',''))


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
str(salary)

salary$job.cat<-"other"



colleges<-salary[grep('college|university|State Board for Comm and Tech Coll',salary$Agency,ignore.case=T),]
colleges<-droplevels(colleges)
collegeCodes<-sort(unique(colleges$Code))
head(colleges)

Agency_code<-unique(colleges[c("Code","Agency")])


colleges_longForm<-gather(colleges,year,Salary,X2011:X2014)

levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2011"] <- "2011"
levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2012"] <- "2012"
levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2013"] <- "2013"
levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2014"] <- "2014"
colleges_longForm$et<-NA
colleges_longForm$mp<-NA
colleges_longForm$percent_ft<-NA
head(colleges_longForm)

write.table(colleges_longForm,'./salaryByYear.txt',sep='\t')


seattle<-salary[grep('seattle',salary$Agency,ignore.case=T),]
seattle<-droplevels(seattle)
str(seattle)

deans<-seattle[grep('dean',seattle$Job,ignore.case=T,value=F),]
head(deans)

apply(deans[,5:8],2,mean,na.rm=T)
lortz<-colleges[grep('lortz',colleges$Employee,ignore.case=T),]






