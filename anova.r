library('data.table')
library('ggplot2')
library('dplyr')
library('pastecs')
library('nlme')
##the 'na' below is actually a 4
bogart<-data.frame(rbind(c('subj1',2.0,4,5.0,9.0),c('subj2',3,6,7,10),c('subj3',4,5,6,8),c('subj4',4,6,7,10),c('subj5',5,5,7,9)))
class(bogart)
colnames(bogart)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4')
bogart<-as.data.frame(bogart)

bogart[,2:5]<-apply(bogart[,2:5],2,function(x) as.numeric(x))
str(bogart)

bogart<-cbind(bogart,apply(bogart[,2:5],1,sum),apply(bogart[,2:5],1,mean),apply(bogart[,2:5],1,var))
colnames(bogart)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4','sum','mean','var')
bogart
grand.mean<-sum(bogart[,2:5])/20

#Below is a very ugly way of calculating the squared deviances of each subject
a=0
sq_dev=""
for (i in 1:nrow(bogart)){
  for (j in 2:5){
    a<-((bogart[i,j]-bogart[i,7])^2)+a
  }
  sq_dev=c(sq_dev,a)
  print(paste("this is the sum of squared devaiations:  ",a))
  a=0
}

bogart<-cbind(bogart,as.numeric(sq_dev[2:6]))
colnames(bogart)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4','sum','mean','Var','SS')
#calcs the SS for each subject
bogart$calc.Var<-bogart$SS/3
sum(bogart$SS)
sum(bogart$calc)



m.bogart<-melt(bogart,measure=2:5,variable='treatment',value.name='score')

summary(aov(score ~ treatment + Error(subject/score), data=m.bogart))

####this looks most similar to Bogart's text
summary(aov(score ~ treatment + Error(subject), data=m.bogart))

# baseline model
base<-(lme(score~1, random=~1|subject/treatment,method='ML',data=m.bogart))
#
model<-(lme(score~treatment, random=~1|subject/treatment,method='ML',data=m.bogart))
anova(base,model)

summary(model)

"m.bogart<-m.bogart%>%mutate(mean=mean(score,na.rm=T),devi= score - mean(score,na.rm=T),sq_dev = devi^2,variance=var(score,na.rm=T))
m.bogart%>%group_by(subject)%>%summarise(n=n_distinct(treatment))
mean(m.bogart[,3],na.rm=T) # this should be grand mean
sum( m.bogart[, 6]) # this should be grand sum of squres

by(m.bogart$score,m.bogart$subject,stat.desc)
"
data.for.plot<-m.bogart%>%group_by(subject,treatment)%>%summarise(count=n(),tx_mean=mean(score,na.rm=T))
p<-data.for.plot%>%ggplot(aes(treatment,subject))
p+geom_point(aes(size=tx_mean))+scale_size_area()

