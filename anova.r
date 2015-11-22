library('data.table')
library('dplyr')
library('pastecs')
bogart<-data.frame(rbind(c('subj1',2.0,4.0,5.0,9.0),c('subj2',3,6,7,10),c('subj3',4,5,6,8),c('subj4',4,6,7,10),c('subj5',5,5,7,9)))
class(bogart)
colnames(bogart)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4')
bogart<-as.data.frame(bogart)

bogart[,2:5]<-apply(bogart[,2:5],2,function(x) as.numeric(x))
str(bogart)
m.bogart<-melt(bogart,measure=2:5,variable='treatment',value.name='score')

summary(aov(score ~ treatment + Error(subject/score), data=m.bogart))


m.bogart<-mutate(m.bogart,devi= score - mean(score),sq_dev = devi^2)
sum(m.bogart[,5])

by(m.bogart$score,m.bogart$treatment,stat.desc)

