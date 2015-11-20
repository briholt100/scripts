
bogart<-rbind(c('subj1',2,4,5,9),c('subj2',3,6,7,10),c('subj3',4,5,6,8),c('subj4',4,6,7,10),c('subj5',5,5,7,9))
bogart1<-as.data.frame(apply(bogart[,2:5],2,as.numeric))
class(bogart1)
rownames(bogart1)<-c('subj1','subj2','subj3','subj4','subj5')
colnames(bogart1)<-c(,'tx1', 'tx2' ,'tx3', 'tx4')
apply(bogart1,2,class)

sum(bogart1)
m.bogart<-melt(bogart1,id.vars=1:4,value.name='score')

summary(aov(score ~ Var2 + Error(Var1/score), data=m.bogart))



