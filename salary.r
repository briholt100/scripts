library('dplyr')
library('data.table')
library(tidyr)
test<-fread("grep 'College' /home/brian/Projects/data/WaStEmployeeHistSalary.txt",sep='\t')

fread("grep 'Holt' /home/brian/Projects/data/addresses.csv")


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
