library('data.table')
library('ggplot2')
library('dplyr')
library('pastecs')
library('nlme')
library('Hmisc')
##the 'na' below is actually a 4
bogart<-data.frame(rbind(c('subj1',2.0,4,5.0,9.0),c('subj2',3,6,7,10),c('subj3',4,5,6,8),c('subj4',4,6,7,10),c('subj5',5,5,7,9)))
class(bogart)
colnames(bogart)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4')
bogart<-as.data.frame(bogart)

bogart[,2:5]<-apply(bogart[,2:5],2,function(x) as.numeric(x))
str(bogart)


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



m.bogart
#lci<-by(m.bogart$score,m.bogart$subject,FUN=sd)
#uci<-
p<-ggplot(m.bogart,aes(x=treatment,y=score,group=subject,color=subject))
p+stat_summary(fun.y=mean,geom='point',position = position_jitter(w = 0.15, h = 0.05)) +ylim(0, 12)
p+geom_line(position = position_jitter(w = 0.15, h = 0.15))+stat_summary(fun.data='mean_cl_normal',geom='errorbar',mult=5,color='blue')+ylim(0, 12)
p+geom_point(position = position_jitter(w = 0.3, h = 0.3))
p+geom_smooth(method='glm',level=.7)


"m.bogart<-m.bogart%>%mutate(mean=mean(score,na.rm=T),devi= score - mean(score,na.rm=T),sq_dev = devi^2,variance=var(score,na.rm=T))
m.bogart%>%group_by(subject)%>%summarise(n=n_distinct(treatment))
 mean(m.bogart[,3],na.rm=T) # this should be grand mean
sum( m.bogart[, 6]) # this should be grand sum of squres

by(m.bogart$score,m.bogart$subject,stat.desc)
"
data.for.plot<-m.bogart%>%group_by(subject,treatment)%>%summarise(count=n(),tx_mean=mean(score,na.rm=T))
p<-data.for.plot%>%ggplot(aes(treatment,subject))
p+geom_point(aes(size=tx_mean))+scale_size_area()

