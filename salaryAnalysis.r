######
#campus
#setwd(".\\My Data Sources\\")
#final_df<-read.csv( file = "./Data/final_df.csv")
final_df<-read.csv( file = "./scripts/final_df.csv")


adminOther.list<-grep("admin", final_df$Job.Title, ignore.case=T, value=F)
academic.list<-grep("ACADEMIC EMPLOYEE|ACADEMIC EMP|ACAD EMP", final_df$Job.Title, ignore.case=T, value=F)
chancellor.list<-grep("CHANCELLOR", final_df$Job.Title, ignore.case=T, value=F)
childhood.list<-grep("childho", final_df$Job.Title, ignore.case=T, value=F)
communication.list<-grep("commun", final_df$Job.Title, ignore.case=T, value=F)
coordination.list<-grep("coord,|EXT COORD", final_df$Job.Title, ignore.case=T, value=F)
counselor.list<-grep("counselo", final_df$Job.Title, ignore.case=T, value=F)
dean.list<-grep("dean|assistant d|ASSOC. DEAN", final_df$Job.Title, ignore.case=T)
director.list<-grep("dir", final_df$Job.Title, ignore.case=T) #, value=T)
exec.list<-c(grep("exec. d", final_df$Job.Title, ignore.case=T))
facilities.list<-grep("facilit|custod|electr|grounds|locks|maintan|mechanic", final_df$Job.Title, ignore.case=T, value=F)
faculty.list<-grep("faculty|professor|moonlight|ftf |ptf |prof|LECTURER|instructor", final_df$Job.Title, ignore.case=T)
finance.list<-grep("financ|budget|capita|fiscal", final_df$Job.Title, ignore.case=T, value=F)
food.list<-grep("food", final_df$Job.Title, ignore.case=T, value=F)
hour.list<-grep("hour", final_df$Job.Title, ignore.case=T, value=F)
HR.list<-grep("HR|benefits|human|payrol", final_df$Job.Title, ignore.case=T, value=F)
library.list<-grep("librar", final_df$Job.Title, ignore.case=T, value=F)
mail.list<-grep("mail", final_df$Job.Title, ignore.case=T, value=F)
manager.list<-c(grep("mgr", final_df$Job.Title, ignore.case=T), grep("manag", final_df$Job.Title, ignore.case=T))
media.list<-grep("media", final_df$Job.Title, ignore.case=T, value=F)
nurse.list<-grep("NURSE", final_df$Job.Title, ignore.case=T, value=F)
officeAssist.list<-grep("office assistant|PROGRAM ASSISTANT|ADMINISTRATIVE ASSIST", final_df$Job.Title, ignore.case=T)
president.list<-grep("presi|v.c.,|chief", final_df$Job.Title, ignore.case=T, value=F)
programCoord.list<-grep("program coord|PRGM COORD", final_df$Job.Title, ignore.case=T, value=F)
retail.list<-grep("retail", final_df$Job.Title, ignore.case=T, value=F)
secretary.list<-grep("secr|exec. a", final_df$Job.Title, ignore.case=T) #, value=T)
security.list<-grep("security", final_df$Job.Title, ignore.case=T, value=F)
specialist.list<-grep("spec", final_df$Job.Title, ignore.case=T, value=F)
gradstudent.list<-grep("STIPEND GRAD", final_df$Job.Title, ignore.case=T, value=F)
supervisory.list<-grep("superv|spv", final_df$Job.Title, ignore.case=T, value=F)
support.list<-grep("supt", final_df$Job.Title, ignore.case=T, value=F)
vice.list<-grep("vice p|vp", final_df$Job.Title, ignore.case=T, value=F)

vChanc.list<-grep("VICE CHANCELLOR|V\\.C.", final_df$Job.Title, ignore.case=T, value=F)

final_df$job.cat<-factor(final_df$job.cat,
                   sort(c(
                     "admin (Other)",
                     "academic (Other)",
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
                     "food",
                     "gradStudent",
                     "hourly",
                     "HR",
                     "library",
                     "mail",
                     "manager",
                     "media",
                     "nurse",
                     "other",
                     "pres",
                     "program coordinator",
                     "retail",
                     "secretary",
                     "security",
                     "specialist",
                     "supervisory",
                     "support",
                     "vicepres",
                     "viceChanc"
                   )
                   ))

##WARNING; BEWARE OF CHANGING ORDER BELOW, ELSE CATEGORIES WILL CHANGE

final_df$job.cat[adminOther.list]<-"admin (Other)"
final_df$job.cat[academic.list]<-"academic (Other)"
final_df$job.cat[HR.list]<-"HR"
final_df$job.cat[security.list]<-"security"
final_df$job.cat[nurse.list]<-"nurse"
final_df$job.cat[finance.list]<-"finance"
final_df$job.cat[facilities.list]<-"facilities"
final_df$job.cat[mail.list]<-"mail"
final_df$job.cat[media.list]<-"media"
final_df$job.cat[communication.list]<-"communication"
final_df$job.cat[coordination.list]<-"coordination"
final_df$job.cat[support.list]<-"support"
final_df$job.cat[library.list]<-"library"
final_df$job.cat[supervisory.list]<-"supervisory"
final_df$job.cat[counselor.list]<-"counselor"
final_df$job.cat[retail.list]<-"retail"
final_df$job.cat[food.list]<-"food"
final_df$job.cat[gradstudent.list]<-"gradStudent"
final_df$job.cat[programCoord.list]<-"program coordinator"
final_df$job.cat[director.list]<-"director"
final_df$job.cat[hour.list]<-"hourly"
final_df$job.cat[faculty.list]<-"faculty"
final_df$job.cat[dean.list]<-"dean"
final_df$job.cat[childhood.list]<-"childhood"
final_df$job.cat[manager.list]<-"manager"
final_df$job.cat[exec.list]<-"executive"
final_df$job.cat[secretary.list]<-"secretary"
final_df$job.cat[officeAssist.list]<-"assistant"
final_df$job.cat[chancellor.list]<-"chancellor"
final_df$job.cat[specialist.list]<-"specialist"
final_df$job.cat[president.list]<-"pres"
final_df$job.cat[vice.list]<-"vicepres"
final_df$job.cat[vChanc.list]<-"viceChanc"

director.salary<-final_df[director.list,]
dean.salary<-final_df[dean.list,]
sec.salary<-final_df[secretary.list,]
director.salary<-final_df[director.list,]
final_df$Code<-as.factor(final_df$Code)

unique(final_df[c("Code","Agency")])

uniList<-list("375|370|376|360|365|380")

colleges_df<-final_df[grepl(uniList,final_df$Code)==F,1:8]
write.table(colleges_df, file = "I:\\www\\quickshare\\colleges_df.csv", sep="\t" ,qmethod = "double", col.names = TRUE,)


write.table(final_df, file = "I:\\www\\quickshare\\final_df.csv",sep='\t')
write.table(final_df[,1:8], file = "I:\\www\\quickshare\\final_df.csv",sep='\t')


table(colleges_df$job.cat)
tail(sort(table(colleges_df$Job.Title[colleges_df$job.cat=='other'])),40)




final_df$year<-as.factor(final_df$year)
df$year<-as.Date(paste(df$year,"-06","-30",sep=""))

tbl<-as.data.frame(table(final_df$Salary,final_df$year))
head(tbl)
colnames(tbl)<-c('Salary','year','Agency','Freq')
tapply(tbl$Freq,list(tbl$Agency,tbl$year),sum)
#This previous one works.  Needs to now break down by job category



plot(tapply(tbl$Freq,tbl$year,sum),)

tbl1<-table(final_df$job.cat[!is.na(final_df$Salary)],final_df$year[!is.na(final_df$Salary)])
tbl1<-as.data.frame(tbl1)
colnames(tbl1)<-c('category','year','Freq')



forPlot<-as.data.frame(tapply(tbl1$Freq,list(tbl1$category,tbl1$year),sum))


colnames(forPlot)<-c('x2010','x2011','x2012','x2013','x2014')

for (i in 1:nrow(forPlot)){  print(paste(rownames(forPlot[i,]),forPlot[i,5]-forPlot[i,1]))}

gather(forPlot,Category,year,x2010:x2014)


tapply(final_df$Salary[final_df$Salary>1500],final_df$year[final_df$Salary>1500],mean,na.rm=T)



tapply(final_df$Salary,list(final_df$Agency,final_df$year),mean,na.rm=T)







dt<-seattle%>%gather(year,Salary,-job.cat,-Job.Title,-Employee,-Agency,-Code,na.rm=T)
#dt<-seattle%>%gather(Time,Salary.Diff,T1,T2,T3,-job.cat,-Job.Title,-Employee,-Agency,-Code,na.rm=T)
dt$year<-as.character(dt$year)   #converting to date
dt$year<-gsub('X','',dt$year)
dt$year<-as.Date(dt$year,'%Y')
dt$year<-str_extract(dt$year, "[0-9]{4}")


#dt<-dean.salary%>%gather(year,Salary,-job.cat,-Job.Title,-Employee,-Agency,-Code,na.rm=T)
dt$year[dt$year=='X2011']<-as.Date
p<-ggplot(dt,aes(x=year,y=Salary))
p+geom_boxplot(notch=F)+
  ggtitle("Boxplot of Salaries for jobs category with 'Dean' in the title
          since 2011 in the Seattle District\n\nThis includes Associate Deans, Executive Deans, etc")


##
##
#heat Map. person via title, with color based on sum of salary

#ggplot object sorted by some fuction, like median, or standard dev.
p<-ggplot(dt,aes(x=reorder(job.cat,Salary,FUN=median), y=Salary,group=job.cat))

p+geom_boxplot()+theme(axis.text.x = element_text(angle = 90, hjust = 1))+facet_wrap(~year)

p<-dt%>%filter(Salary >95000)%>%ggplot(aes(x=year,y=Salary,id=Job.Title))
p+geom_boxplot()+facet_wrap(~Job.Title)

#creats a long df for each job title (employee not tracked)
longData<-dt%>%group_by(job.cat,year)%>%
  transmute(Salary=Salary,SalSum=sum(Salary,na.rm=T),mean=mean(Salary,na.rm=T),deviation=Salary-mean(Salary,na.rm=T),count=n(),SS=deviation^2,var=SS/count)%>%
  arrange(-desc(job.cat))


p<-longData%>%ggplot(aes(x=year,y=Salary,group=job.cat))
p+geom_smooth(aes(group = 1),method='glm',level=.95)+facet_wrap(~job.cat)

longData

#the following will create a df that includes the sd and se for longData.
longData.summary<-longData%>%group_by(job.cat,year)%>%summarise(mean=mean(Salary),sd=sd(Salary),N=n())%>%mutate(se=sd/sqrt(N))

p<-ggplot(longData.summary,aes(x=year,y=mean,group=job.cat))


p+geom_smooth()+facet_wrap(~job.cat)+geom_errorbar(aes(ymin=mean-se,ymax=mean+se))



p+geom_boxplot()
p+geom_line()+stat_summary(aes(group=1),geom='point',fun.y=mean)+facet_wrap(~job.cat) +stat_smooth(aes(group = 1),method = "lm", se = T)

longData%>%group_by(job.cat)%>%summarise(mean=mean(Salary,na.rm=T),)

tbl$count<-(table(dt$job.cat))

tbl<-as.data.frame(tapply(dt$Salary,list(dt$job.cat,dt$year),mean,na.rm=T))
tbl<-cbind(rownames(tbl),tbl)
row.names(tbl)<-NULL
colnames(tbl)<-c('job.cat','2011','2012','2013','2014')
tbl$count<-(table(dt$job.cat))
head(dt)
tbl
<-cbind(tbl,dt%>%group_by(job.cat)%>%summarise(average=mean(Salary,na.rm=T),variance=var(Salary,na.rm=T))%>%select(average,variance))







##mean salary per job.cat, for each year.
tbl%>%gather(year,salary,-job.cat)%>%ggplot(aes(x=year,y=(salary)))+geom_point()+ggtitle("Mean salaries in Seattle, 2011-2014\nby 29 Job Categories")+ stat_summary(fun.data = "mean_cl_boot", colour = "red")+facet_wrap(~job.cat)+geom_smooth(aes(group = 1))

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

p  + #facet_wrap(~year)+
  geom_tile(aes(color=Salary)) +
  #geom_tile(data=subset(dt, year == "2012-11-15"),aes(fill = (Salary)))   +
  #scale_fill_gradient(low = "ghostwhite", high = "steelblue") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text.y=element_blank())+
  ggtitle("Heatmap of salaries in Seattle. \nX-Axis are 30 Job Clusters while the\nY-axis has all job titles, \nbut have them hidden for aesthetic reasons")










#########################
############################
#Downloading by agency by agency, year by year

temp <- tempfile()
download.file("http://www.ofm.wa.gov/persdetail/2011/2011persdetail.zip",temp)

zipFileInfo <- unzip(temp, list=TRUE)
for (agency in 1:nrow(zipFileInfo)) {
  print (zipFileInfo[agency,1])
  #so, from here, for each agency, I'd want to read.text and ideally pull out specific queries
}


data <- read.table(unz(temp, "a1.dat"))
unlink(temp)

#reading webpages  NOTE, each year of webpages look a bit different
#some have 4 columns (including a percent FT)
#some have duplicate names with different titles, so for example reg sal and moonlight
url<-'http://lbloom.net/secc01.html'
url<-"http://lbloom.net/index11.html" # use this to get all links in the code using XML package getHTMLLinks(htmlCode)
con = url(url)
htmlCode = readLines(con)
close(con)
strsplit(htmlCode[58:2944],'\\t')[2][2]

listing<-strsplit(htmlCode[59:2942],'\\t') #this crops off comments
df<-ldply(listing)
colnames(df)<-c('name','title','salary')

getHTMLLinks(htmlCode)
test<-readHTMLList(htmlCode)[[1]]
#The following comes up with 36 universitie sand colleges using index
count=0
tempDF<-data.frame()

count=0
tempDF<-data.frame()
for (i in 1:length(htmlCode)){
  if (grepl(' col |univ|wsu|college|-//college',htmlCode[i],ignore.case=T)){

    #so if true, then I'd like to open the page and scrape the page data
    #once scraped, clean data
    #add to table/df

    print (htmlCode[i])
    count=count + 1
  }
  else print("no match")
}



url<-"http://lbloom.net/index11.html" # use this to get all links in the code using XML package getHTMLLink
bloom<-htmlTreeParse(url,useInternalNodes=T)  # for the xpath to work below, True

searchTerms<- "//a[contains(text(),' Col ')] |
//a[contains(text(),'WSU')] |
//a[contains(text(),'Olympic Co')] |
//a[contains(text(),'Univ ')] "
links<-cbind(xpathSApply(bloom,searchTerms,xmlValue), # this pulls the <a> names of link
             getHTMLLinks(bloom,xpQuery=gsub(']',']/@href',searchTerms))) # this pulls the links themselves.


nrow(links)
head(links)
mylist<-list()
for (i in 1:nrow(links)){
  text<-links[i,2] %>% url %>% read_html() %>% html_nodes (xpath= '//pre')%>%html_text(trim=F) #this pulls out the actual pre text
  mylist[[i]]<-text
  mylist[[i]][2]<-links[i,1]
}

df<-list()
for (i in 1:length(mylist)){
  df[[i]]<-cbind(mylist[[i]][2],read.fwf(textConnection(mylist[[i]][1]),
                                         widths=c(32,32,81),
                                         skip=3,
                                         col.names=c('Employee','Job_title','Salary')
  ))

}
final_df<-do.call("rbind",df)

####---------------
"""links1<-url %>% read_html( ) %>% xml_nodes(xpath=searchTerms)  #using Rvest creates node set
tmp<-html_attrs(links1)# creates a nested but named list; each element has 2 sub elements "target" and 'href', which is what we want.
links[11,2] %>% url %>% read_html() %>% html_node() %>% magrittr::extract('pre')
#This takes the 11th link and extracts the full 'pre' table. fwf does NOT work on this..yet
"""
####---------------




#write(htmlCode[name:end],'../data/htmlCode.txt')
#tst<-read.fwf('../data/htmlCode.txt',widths = c(32, 33, 81),header=F,row.names=NULL,skip=1,col.names=c('name','title','salary'))
txt<-unlist(htmlCode[name:end])
tst<-read.fwf(txt,widths = c(32, 33, 81),header=F,row.names=NULL,skip=0,col.names=c('name','title','salary'))

##read about 'connection', reading a url(url) okay, but need to skip several lines (find 'name or pre' and skip to that)
#http://stackoverflow.com/questions/29663107/using-read-fwf-with-https


#

x<-readLines(con=url(links[4,2]),skipNul=T)
x<-x[grep('Name',x,value=F)+2:grep('</pre>',x,value=F)-5]

df<-data.frame(name = substr(x,1,32),
               title = substr(x, 33,80),
               sal = substr(x, 81, 105))
get_pull(x)


