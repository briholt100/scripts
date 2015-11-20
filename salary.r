library('stringr')
library('dplyr')
library('data.table')
library('tidyr')
library('ggplot2')
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



"
test<-fread("grep 'College' /home/brian/Projects/data/WaStEmployeeHistSalary.txt",sep='\t')

fread("grep 'Holt' /home/brian/Projects/data/addresses.csv")
"
#campus
#salary<-read.csv('../Data/WaStEmployeeHistSalary.txt',
                 sep='\t' ,stringsAsFactors=T,strip.white=T,na.strings=c('0',''))


#home
salary<-read.csv("../Data/WaStEmployeeHistSalary.txt",
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

job.cat<-"other"
salary<-cbind(salary, job.cat)


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





adminOther.list<-grep("admin", seattle$Job.Title, ignore.case=T, value=F)
chancellor.list<-grep("chance", seattle$Job.Title, ignore.case=T, value=F)
childhood.list<-grep("childho", seattle$Job.Title, ignore.case=T, value=F)
communication.list<-grep("commun", seattle$Job.Title, ignore.case=T, value=F)
coordination.list<-grep("coord,", seattle$Job.Title, ignore.case=T, value=F)
counselor.list<-grep("counselo", seattle$Job.Title, ignore.case=T, value=F)
dean.list<-grep("dean|assistant d|ASSOC. DEAN", seattle$Job.Title, ignore.case=T)
director.list<-grep("dir", seattle$Job.Title, ignore.case=T) #, value=T)
exec.list<-c(grep("exec. d", seattle$Job.Title, ignore.case=T))
facilities.list<-grep("facilit|custo|electr|grounds|locks|maintan|mechanic", seattle$Job.Title, ignore.case=T, value=F)
faculty.list<-grep("faculty", seattle$Job.Title, ignore.case=T)
finance.list<-grep("financ|budget|capita|fiscal", seattle$Job.Title, ignore.case=T, value=F)
hour.list<-grep("hour", seattle$Job.Title, ignore.case=T, value=F)
HR.list<-grep("HR|benefits|human|payrol", seattle$Job.Title, ignore.case=T, value=F)
library.list<-grep("librar", seattle$Job.Title, ignore.case=T, value=F)
mail.list<-grep("mail", seattle$Job.Title, ignore.case=T, value=F)
manager.list<-c(grep("mgr", seattle$Job.Title, ignore.case=T), grep("manag", seattle$Job.Title, ignore.case=T))
media.list<-grep("media", seattle$Job.Title, ignore.case=T, value=F)
officeAssist.list<-grep("office assistant|PROGRAM ASSISTANT|ADMINISTRATIVE ASSIST", seattle$Job.Title, ignore.case=T)
president.list<-grep("presi|v.c.,|chief", seattle$Job.Title, ignore.case=T, value=F)
programCoord.list<-grep("program coord", seattle$Job.Title, ignore.case=T, value=F)
retail.list<-grep("retail", seattle$Job.Title, ignore.case=T, value=F)
secretary.list<-grep("secr|exec. a", seattle$Job.Title, ignore.case=T) #, value=T)
security.list<-grep("security", seattle$Job.Title, ignore.case=T, value=F)
specialist.list<-grep("spec", seattle$Job.Title, ignore.case=T, value=F)
supervisory.list<-grep("superv|spv", seattle$Job.Title, ignore.case=T, value=F)
support.list<-grep("supt", seattle$Job.Title, ignore.case=T, value=F)
vice.list<-grep("vice p|vp", seattle$Job.Title, ignore.case=T, value=F)


seattle$job.cat<-factor(seattle$job.cat,
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

seattle$job.cat[adminOther.list]<-"admin (Other)"
seattle$job.cat[HR.list]<-"HR"
seattle$job.cat[security.list]<-"security"
seattle$job.cat[finance.list]<-"finance"
seattle$job.cat[facilities.list]<-"facilities"
seattle$job.cat[mail.list]<-"mail"
seattle$job.cat[media.list]<-"media"
seattle$job.cat[communication.list]<-"communication"
seattle$job.cat[coordination.list]<-"coordination"
seattle$job.cat[support.list]<-"support"
seattle$job.cat[library.list]<-"library"
seattle$job.cat[supervisory.list]<-"supervisory"
seattle$job.cat[counselor.list]<-"counselor"
seattle$job.cat[retail.list]<-"retail"
seattle$job.cat[specialist.list]<-"specialist"
seattle$job.cat[programCoord.list]<-"program coordinator"
seattle$job.cat[director.list]<-"director"
seattle$job.cat[hour.list]<-"hourly"
seattle$job.cat[faculty.list]<-"faculty"
seattle$job.cat[dean.list]<-"dean"
seattle$job.cat[childhood.list]<-"childhood"
seattle$job.cat[manager.list]<-"manager"
seattle$job.cat[exec.list]<-"executive"
seattle$job.cat[secretary.list]<-"secretary"
seattle$job.cat[officeAssist.list]<-"assistant"
seattle$job.cat[chancellor.list]<-"chancellor"
seattle$job.cat[president.list]<-"pres"
seattle$job.cat[vice.list]<-"vicepres"

director.salary<-seattle[director.list,]
dean.salary<-seattle[dean.list,]
sec.salary<-seattle[secretary.list,]
director.salary<-seattle[director.list,]

#Must change wide columns to tall, so that the 4 years 2011-2014 are in one variable, year

dt<-dean.salary%>%gather(year,Salary,-job.cat,-Job.Title,-Employee,-Agency,-Code,na.rm=T)
dt$year[dt$year=='X2011']<-as.Date
p<-ggplot(dt,aes(x=year,y=Salary))
p+geom_boxplot(notch=F)+
  ggtitle("Boxplot of Salaries for jobs category with 'Dean' in the title
          since 2011 in the Seattle District\n\nThis includes Associate Deans, Executive Deans, etc")


boxplot(dt$Salary~dt$year)

seattle$T1<-seattle$X2012-seattle$X2011
seattle$T2<-seattle$X2013-seattle$X2012
seattle$T3<-seattle$X2014-seattle$X2013

##
##
#heat Map. person via title, with color based on sum of salary
dt<-seattle%>%gather(year,Salary,-job.cat,-Job.Title,-Employee,-Agency,-Code,na.rm=T)
#dt<-seattle%>%gather(Time,Salary.Diff,T1,T2,T3,-job.cat,-Job.Title,-Employee,-Agency,-Code,na.rm=T)
dt$year<-as.character(dt$year)   #converting to date
dt$year<-gsub('X','',dt$year)
dt$year<-as.Date(dt$year,'%Y')
dt$year<-str_extract(dt$year, "[0-9]{4}")
tbl<-as.data.frame(tapply(dt$Salary,list(dt$job.cat,dt$year),mean,na.rm=T))
tbl<-cbind(rownames(tbl),tbl)
row.names(tbl)<-NULL
colnames(tbl)<-c('job.cat','2011','2012','2013','2014')
apply(tbl,1,plot)
##mean salary per job.cat, for each year.
tbl%>%gather(year,salary,-job.cat)%>%ggplot(aes(x=year,y=(salary)))+geom_point()+ggtitle("Mean salaries in Seattle, 2011-2014\nby 29 Job Categories")+facet_wrap(~job.cat)

tbl%>%gather(year,salary,-job.cat)%>%ggplot(aes(x=year,y=(salary)))+geom_errorbar(aes(ymin=0,ymax=300000))+geom_point()+ggtitle("Mean salaries in Seattle, 2011-2014\nby 29 Job Categories")+facet_wrap(~job.cat)

###for error bars, must calcualte the standard error, within subjects.


############
##This heatmap is a pretty good start
###########
#color_palette <- colorRampPalette(c("#3794bf", "#FFFFFF", "#df8640"))(length(dt$Salary.Diff) - 1)
p<-ggplot(dt,aes(y=Job.Title,x=job.cat))
p  +
  geom_tile(aes(fill = log(Salary)), colour = "white")   +
  #scale_fill_manual(values = color_palette) +
  scale_fill_gradient(low = "white", high = "steelblue") +
  facet_wrap(~ year,ncol=1) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text.y=element_blank())+
  ggtitle("Heatmap of salaries in Seattle. \nX-Axis are 29 Job Clusters while the\nY-axis has all job titles, \nbut have them hidden for aesthetic reasons")


p<-ggplot(dt,aes(x=year,y=Salary))
p+geom_boxplot()+ggtitle("Boxplot of all Salaries since 2011 in the Seattle District") +
  geom_point(col='red',cex=20,data=dt, x=mean(Salary2011$Salary,na.rm=T))


Salary2011<-filter(dt,grepl('dean',Job.Title,ignore.case=T),year=='X2011')




dt<-seattle%>%mutate(tot_sal =X2011+X2012+X2013+X2014)%>%group_by(Job.Title)%>%summarise(employees=n(),total=sum(tot_sal))%>%filter(total>10000)%>%arrange(total)

head(dt)

p<-ggplot(dt,aes(y=Job.Title,x=total))
p+
  geom_tile(aes(fill = (total)), colour = "ghostwhite")   + #scale_fill_manual(values = color_palette)+
  scale_fill_gradient(low = "ghostwhite", high = "steelblue") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text.y=element_blank())+
  ggtitle("Heatmap of salaries in Seattle. \nX-Axis are 29 Job Clusters while the\nY-axis has all job titles, \nbut have them hidden for aesthetic reasons")



#####
###overlaying heatmaps
p<-ggplot(dt,aes(y=Job.Title,x=job.cat,fill=Salary))

p  +
  geom_tile(aes(fill=year,color=Salary)) +
  #geom_tile(data=subset(dt, year == "2012-11-15"),aes(fill = (Salary)))   +
  scale_fill_gradient(low = "ghostwhite", high = "steelblue",bias=10) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text.y=element_blank())+
  ggtitle("Heatmap of salaries in Seattle. \nX-Axis are 29 Job Clusters while the\nY-axis has all job titles, \nbut have them hidden for aesthetic reasons")









##########
###grouping by title, include mean for each 4 years
dt<-seattle%>%group_by(Job.Title)%>%select(5:8)%>%summarise_each(funs(mean(.,na.rm=T,trim=.05)))%>%gather(key=Year,value,-Job.Title)
dt<-seattle%>%group_by(Job.Title)%>%select(5:8)%>%gather(key=Year,value,-Job.Title)



dt
p<-ggplot(dt[dt$Job.Title=='Faculty',],aes(x=Year,y=Job.Title))
p+geom_point()



