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

#colleges_longForm<-gather(colleges,year,Salary,Sal2012:Sal2015)

#levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2011"] <- "2011"
#levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2012"] <- "2012"
#levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2013"] <- "2013"
#levels(colleges_longForm$year)[levels(colleges_longForm$year)=="X2014"] <- "2014"

#colleges_longForm$et<-NA
#colleges_longForm$mp<-NA
#colleges_longForm$percent_ft<-NA
#head(colleges_longForm)

write.table(colleges_longForm,'./salaryByYear.txt',sep='\t')

seattle<-colleges[grep('seattle',colleges$Agency,ignore.case=T),  ]


#####cleanign up duplicate names with different job.cat

seattle<-seattle %>% group_by(employee_name) %>% #filter(grepl('^D',employee_name)) %>% 
  mutate(job.cat = ifelse(any(grep("Faculty",job.cat)),"Faculty","Non-fac")) 

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
  

totalSalary_df<-sea_long %>% select(employee_name,job.cat,Salary) %>% group_by(employee_name,job.cat) %>% summarise(totalSalary=sum(Salary))

#by(totalSalary_df,totalSalary_df$job.cat,function(x) median(totalSalary_df$totalSalary,na.rm=T))

#dplyr finiding quants by group/year
sea_long %>% group_by(job.cat,year) %>% summarise(q0=quantile(Salary,probs=0),
                                                  q2=quantile(Salary,probs=.2),
                                                  #q25=quantile(Salary,probs=.25),
                                                  q4=quantile(Salary,probs=.4),
                                                  #q5=quantile(Salary,probs=.5),
                                                  q6=quantile(Salary,probs=.6),
                                                  q8=quantile(Salary,probs=.8),
                                                  q10=quantile(Salary,probs=1))


###
#the following median calculatino is based on total salary median over all years (so, first total salary across years, then make cuts)
###

totalSalary_df$Median<- ifelse(totalSalary_df$job.cat=="Faculty",
                               cut2(totalSalary_df$totalSalary[totalSalary_df$job.cat=="Faculty"],
                                    cuts= quantile(totalSalary_df$totalSalary[totalSalary_df$job.cat=="Faculty"],
                                                   na.rm=T,probs=seq(0,1,.2))),
                               cut2(totalSalary_df$totalSalary[totalSalary_df$job.cat!="Faculty"],
                                    cuts= quantile(totalSalary_df$totalSalary[totalSalary_df$job.cat!="Faculty"],
                                                   na.rm=T,probs=seq(0,1,.2))))
sea_long<-merge(sea_long,totalSalary_df)
sea_long<-sea_long %>% select(Code,Agency_Title,employee_name,job_title,job.cat,year,Salary,totalSalary,Median)



sea_long %>% group_by(job.cat,year) %>% 
  summarise(count=n(),min=min(Salary),max=max(Salary),
            `25%`=quantile(Salary, probs=0.25),
            `50%`=quantile(Salary, probs=0.5),
            `75%`=quantile(Salary, probs=0.75), 
            med=median(Salary),mean=mean(Salary))


quants<-
  sea_long %>% group_by(job.cat,year) %>% summarise(count=n(),min=min(Salary),max=max(Salary),
                                                  Quant20=quantile(Salary, probs=0.20),
                                                  Quant40=quantile(Salary, probs=0.40),
                                                  Quant60=quantile(Salary, probs=0.6),
                                                  Quant80=quantile(Salary, probs=0.80), 
                                                  med=median(Salary),mean=mean(Salary)) %>% 
  gather(quant,value,Quant20:Quant80)  

quants %>% ggplot(aes(year,value))+geom_line(aes(group=job.cat))+facet_grid(quant~job.cat)

  ggplot(aes(x=year,y=value))+
  #geom_line(aes(group=job.cat),size=1.2,linetype = "solid")+
  facet_grid(job.cat~quant)+
  geom_jitter(data=sea_long,aes(x=year,y=Salary),alpha=.15,shape=20)+
  labs(title = "Seattle salaries (each dot = a person) \n with the Mean of group Salary trendline within job category and tertile")

sea_long %>%
  group_by(job.cat,year) %>%
  ggplot(aes(x=year,y=Salary))+geom_jitter(aes(color= job.cat),alpha=.2,shape=20)+facet_grid(job.cat~Median)

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

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(sea_long,aes(x=year))+geom_bar(aes(fill=as.factor(Median)))+facet_grid(~job.cat)+
  guides(fill = guide_legend(reverse = TRUE))+labs(title='Seattle employee count within each quantile')+scale_fill_grey(name="Quantile")+theme_bw()

=======
p<-ggplot(sea_long,aes(x=year))
p+geom_bar(aes(fill=as.factor(Median)))+facet_grid(~job.cat)+
  guides(fill = guide_legend(reverse = TRUE))+scale_fill_discrete(name="Quantile")+labs(title='Seattle employee count within each quantile')
+
  scale_fill_brewer(palette=cbbPalette)

p+stat_count(aes(x=employee_name))+facet_grid(~job.cat)

  aes(fill=as.factor(Median)))+facet_grid(~job.cat)+
  guides(fill = guide_legend(reverse = TRUE))+scale_fill_discrete(name="Quantile")+labs(title='Seattle employee count within each quantile')

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
