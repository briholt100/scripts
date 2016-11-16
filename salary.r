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
                         cut2(colleges$TotSal,cuts= quantile(colleges$TotSal[colleges$job.cat=="Faculty"],na.rm=T,probs=seq(0,1,.2))),
                         cut2(colleges$TotSal,cuts= quantile(colleges$TotSal[colleges$job.cat!="Faculty"],na.rm=T,probs=seq(0,1,.2))))



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


sea_long<-sea_long[complete.cases(sea_long),]

#this shows the median salarys by job cat and quantile (median)
tapply(sea_long$Salary,list(sea_long$year,sea_long$job.cat,sea_long$Median),median,na.rm=T)
table(sea_long$year,sea_long$job.cat,sea_long$Median,useNA='ifany')

medianByGroup<-sea_long %>% group_by(year,job.cat,quant=Median) %>% summarise(MedSal=median(Salary,na.rm=T))

totalByGroup<-sea_long %>% group_by(year,job.cat,quant=Median) %>% summarise(count=n())


p<-ggplot(sea_long,aes(x=year,y=Salary))
p+geom_boxplot()+
  facet_grid(job.cat~Median)+
  #geom_line(data=enrol_df,aes(x=year,y=enrollments,color=1,group=1))+
  labs(title = "Seattle salary by median salary within job category")

p<-ggplot(medianByGroup,aes(x=year,y=MedSal))
p+geom_line(aes(group=quant,color=quant),size=1,linetype=2)+facet_grid(~job.cat)+
  geom_jitter(data=sea_long,aes(y=Salary, color = Median),alpha=.3,shape=20)+scale_shape_identity()

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(sea_long,aes(x=year))+geom_bar(aes(fill=as.factor(Median)))+facet_grid(~job.cat)+
  guides(fill = guide_legend(reverse = TRUE))+labs(title='Seattle employee count within each quantile')+scale_fill_grey(name="Quantile")+theme_bw()

