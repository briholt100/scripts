library('dplyr')
library('data.table')

test<-fread("grep college /home/brian/Projects/data/WaStEmployeeHistSalary.txt",sep='\t')

fread("grep holt /home/brian/Projects/data/addresses.csv")


salary<-read.csv("/home/brian/Projects/data/WaStEmployeeHistSalary.txt",sep='\t' ,stringsAsFactors=T,strip.white=T,na.strings=c('0',''))

salary[,1]<-as.factor(salary[,1])
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
colleges[grep('lortz',colleges$Employee,ignore.case=T),c(2,5:8)]

