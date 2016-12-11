#######

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
#salary[56855,5]<-8732
#write.table(salary,'./Data/WaStEmployeeHistSalary.txt',sep='\t')
#write.table(salary,"/home/brian/Projects/Data/WaStEmployeeHistSalary.txt",sep='\t')
salary<-(rename(salary,Sal2014=Sal20141))
salary$job.cat<-"other"
str(salary)


colleges<-salary[grep('college|university|State Board for Comm and Tech Coll',salary$Agency,ignore.case=T),]
colleges<-droplevels(colleges)
ColNames<-colnames(colleges)
ColNames[1]<-"Code"
colnames(colleges)<-ColNames
collegeCodes<-sort(unique(colleges$Code))
head(colleges)

Agency_code<-unique(colleges[c("Code","Agency_Title")])

#creates a total across years
#colleges$TotSal<-apply(colleges[,5:8],1,sum,na.rm=T)


#convert job.cat from other.
#grep out faculty and non faculty, then split those two categories into above median and below

colleges$job.cat<-ifelse(grepl("facul|FTF|fac sub|pt-fac|pro-rata",colleges$job_title,ignore.case=T),"Faculty","Non-fac")

"""ApplyQuintiles <- function(x) {
  cut(x, breaks=c(quantile(colleges$TotSal, probs = seq(0, 1, by = 0.20))),
      labels=c("0-20","20-40","40-60","60-80","80-100"), include.lowest=TRUE)
}
colleges$Quintile <- sapply(colleges$TotSal, ApplyQuintiles)
table(colleges$Quintile)"""

"""I could apply quintiles by subsetting totsal by faculty non faculty, which would mean in calling those numbers they'd have to be conditional: quintiles when faculty is true, when not true, etc'"""


#colleges$Median<- ifelse(colleges$job.cat=="Faculty",
 #                        cut2(colleges$TotSal,cuts= quantile(colleges$TotSal[colleges$job.cat=="Faculty"],na.rm=T,probs=seq(0,1,.2))),
  #                       cut2(colleges$TotSal,cuts= quantile(colleges$TotSal[colleges$job.cat!="Faculty"],na.rm=T,probs=seq(0,1,.2))))




#seattle<-seattle[,c(1:4,9,11,5:8,10)]



#obvious fix of misname
colleges[grepl('ABAY, HALEFOM',colleges$employee_name) & colleges$job_title == 'FOOD SERVICE WORKER',c("Sal2014")]<-25900
colleges<-colleges[-45107,] #after grep('ABAY, HALEFOM',colleges$employee_name) to obtain record number 45107
colleges$TotSal<-apply(colleges[,5:8],1,sum,na.rm=T)
colleges<-colleges %>%
  gather(year,Salary,Sal2012:Sal2015)
#colleges_longForm<-gather(colleges,year,Salary,Sal2012:Sal2015)

levels(colleges$year)[levels(colleges$year)=="Sal2015"] <- "2015"
levels(colleges$year)[levels(colleges$year)=="Sal2012"] <- "2012"
levels(colleges$year)[levels(colleges$year)=="Sal2013"] <- "2013"
levels(colleges$year)[levels(colleges$year)=="Sal2014"] <- "2014"

colleges<-rbind(final_df,colleges)   ##########this rbinds salary and finaldf2011


#colleges_longForm$et<-NA
#colleges_longForm$mp<-NA
#colleges_longForm$percent_ft<-NA
#head(colleges_longForm)

#write.table(colleges_longForm,'./salaryByYear.txt',sep='\t')

seattle<-colleges[grep('seattle',colleges$Agency,ignore.case=T),  ]


#####cleanign up duplicate names with different job.cat

seattle<-seattle %>% group_by(employee_name) %>% #filter(grepl('^D',employee_name)) %>%
  mutate(job.cat = ifelse(any(grep("Faculty",job.cat)),"Faculty","Non-fac"))
#sea_long<-seattle
####continuing
sea_long<-gather(seattle,year,Salary,Sal2012:Sal2015)
sea_long$job.cat<-as.factor(sea_long$job.cat)

levels(sea_long$year)[levels(sea_long$year)=="Sal2015"] <- "2015"
levels(sea_long$year)[levels(sea_long$year)=="Sal2012"] <- "2012"
levels(sea_long$year)[levels(sea_long$year)=="Sal2013"] <- "2013"
levels(sea_long$year)[levels(sea_long$year)=="Sal2014"] <- "2014"

str(sea_long)

sea_long<-sea_long[complete.cases(sea_long),]
sea_long<-sea_long %>% group_by(employee_name) %>% mutate(TotSal=sum(Salary))
write.csv(sea_long, file = "./sea_long.csv")

totalSalary_df<-sea_long %>% select(employee_name,job.cat,Salary) %>% group_by(employee_name,job.cat) %>% summarise(totalSalary=sum(Salary))

#by(totalSalary_df,totalSalary_df$job.cat,function(x) median(totalSalary_df$totalSalary,na.rm=T))

#dplyr finiding quants by group/year
sea_long %>% group_by(job.cat,year) %>% summarise(q0=quantile(Salary,probs=0),
                                                  #q2=quantile(Salary,probs=.2),
                                                  #q25=quantile(Salary,probs=.25),
                                                  q33=quantile(Salary,probs=.334),
                                                  #q4=quantile(Salary,probs=.4),
                                                  q5=quantile(Salary,probs=.5),
                                                  #q6=quantile(Salary,probs=.6),
                                                  q66=quantile(Salary,probs=.667),
                                                  #q75=quantile(Salary,probs=.75),
                                                  #q8=quantile(Salary,probs=.8),
                                                  q10=quantile(Salary,probs=1))

df<-sea_long %>% group_by(job.cat,year) %>%
  mutate(quants=cut2(Salary,cuts=quantile(Salary,c(#.2,
                                                   .33,
                                                   .5,
                                                   .66,
                                                   #.8,
                                                   .999))))
levels(df$quants)

df<-df %>%
  mutate(quants = revalue(quants,  c("[   100,  9482)"= 'x00%',
                                     #"[  4300,  9482)"='x20%',
                                     "[  9482, 22300)"= 'x33%',
                                     "[ 22300, 39064)"='x50%',
                                     "[ 39064,115017)" ='x66%',
                                     #"[ 59300,115017)"='x80%',
                                     "[115017,117800]"='x99%')))

df %>% group_by(year,job.cat,quants) %>% summarise(Median=median(Salary))  %>%
  ggplot(aes(year,Median))+
  geom_line(aes(group=quants))+
  geom_text(aes(label=Median),hjust=.3, vjust=0,size=3,color='blue')+
  facet_grid(quants~job.cat,scales='free_y')+
  geom_jitter(data=df,aes(x=year,y=Salary),alpha=.1,shape=20)+
  labs(title="Salary changes by percentiles\nSalary amount is the median for\n year & percentile\n\nNOTICE THE Y AXIS SCALE CHANGES")



# a test of range on total salary:
totalSalary_df %>% group_by(job.cat,Median)  %>% select(totalSalary) %>%
  summarise(min = min(totalSalary),median= median(totalSalary),max=max(totalSalary),mean=mean(totalSalary))

totalByGroup<-sea_long %>% group_by(year,job.cat,quant=Median) %>% summarise(count=n())
medianByGroup<-sea_long %>% group_by(year,job.cat,quant=Median) %>% summarise(MedSal=median(Salary,na.rm=T))
meanByGroup<-sea_long %>% group_by(year,job.cat,quant=Median) %>% summarise(MeanSal=mean(Salary,na.rm=T))
#this shows the median salarys by job cat and quantile (median)
tapply(sea_long$Salary,list(sea_long$year,sea_long$job.cat,sea_long$Median),mean,na.rm=T)
table(sea_long$year,sea_long$job.cat,sea_long$Median,useNA='ifany')

p<-ggplot(sea_long,aes(x=year,y=Salary))
p+geom_boxplot()+geom_hline(data=meanByGroup,aes(yintercept=MeanSal,col='red'))+
  facet_grid(job.cat~Median)+
  #geom_line(data=enrol_df,aes(x=year,y=enrollments,color=1,group=1))+
  labs(title = "Seattle salary by median salary within job category")

p<-ggplot(medianByGroup,aes(x=year,y=MedSal))
p+geom_line(aes(group=quant),size=1,linetype=2)+facet_grid(~job.cat)+
  geom_jitter(data=sea_long,aes(y=Salary, color = Median),alpha=.3,shape=20)+scale_shape_identity()


deans<-seattle[grep('dean',seattle$Job,ignore.case=T,value=F),]
head(deans)

apply(deans[,5:8],2,mean,na.rm=T)
lortz<-colleges[grep('lortz',colleges$Employee,ignore.case=T),]

df<-read.table('clipboard',sep='\t',header=T)  #for reading in excel contents
df<-df %>%
  gather(FTE_Type,FTE,State.Supported:Student.Funded)

df$FTE<-as.numeric(gsub('"|,',"",df$FTE))

enrol_plot<-ggplot(df,aes(x=year,y=FTE))

enrol_plot+geom_point(aes(color=campus,shape=4))+
  geom_line(aes(color=campus,group=campus))+facet_grid(FTE_Type~campus)+
  scale_shape_identity()+
  scale_y_continuous(breaks=seq(0,6000,750))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))




sea_long %>% filter(grepl('^Dean',job_title,ignore.case=T),job.cat!="Faculty") %>% group_by(employee_name) %>% ggplot(aes(year,Salary))+geom_point(aes(group=employee_name))+geom_line(aes(group=employee_name))+facet_wrap(~employee_name)+  scale_y_continuous(labels = comma)+labs(title="Admins with 'dean' in title")+geom_text(aes(label=Salary),hjust=-.1, vjust=-1.2,size=2)
