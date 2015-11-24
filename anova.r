library('data.table')
library('ggplot2')
library('dplyr')
library('pastecs')
##the 'na' below is actually a 4
bogart<-data.frame(rbind(c('subj1',2.0,4,5.0,9.0),c('subj2',3,6,7,10),c('subj3',4,5,6,8),c('subj4',4,6,7,10),c('subj5',5,5,7,9)))
class(bogart)
colnames(bogart)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4')
bogart<-as.data.frame(bogart)

bogart[,2:5]<-apply(bogart[,2:5],2,function(x) as.numeric(x))
str(bogart)
m.bogart<-melt(bogart,measure=2:5,variable='treatment',value.name='score')

summary(aov(score ~ treatment + Error(subject/score), data=m.bogart))

"m.bogart<-m.bogart%>%mutate(mean=mean(score,na.rm=T),devi= score - mean(score,na.rm=T),sq_dev = devi^2,variance=var(score,na.rm=T))
m.bogart%>%group_by(subject)%>%summarise(n=n_distinct(treatment))
mean(m.bogart[,3],na.rm=T) # this should be grand mean
sum( m.bogart[, 6]) # this should be grand sum of squres

by(m.bogart$score,m.bogart$subject,stat.desc)
"
data.for.plot<-m.bogart%>%group_by(subject,treatment)%>%summarise(count=n(),tx_mean=mean(score,na.rm=T))
p<-data.for.plot%>%ggplot(aes(treatment,subject))
p+geom_point(aes(size=tx_mean))+scale_size_area()

