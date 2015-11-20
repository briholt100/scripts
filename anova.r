bogart<-(rbind(c('subj1',2.0,4.0,5.0,9.0),c('subj2',3,6,7,10),c('subj3',4,5,6,8),c('subj4',4,6,7,10),c('subj5',5,5,7,9)))
cols= c(2,3,4,5)
bogart[,cols]<-as.matrix(apply(bogart[,cols],2,function(x) as.integer(x)))

class(bogart)
colnames(bogart)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4')
bogart[,1]<-as.factor(as.character(bogart[,1]))
apply(bogart,2,class)

m.bogart<-melt(bogart,id=2:5,measure=as.numeric(2:5),value.name='score')

summary(aov(score ~ Var2 + Error(Var1/score), data=m.bogart))

> b1<-data.frame(b1)
> b1$sub<-c('a','b','c','d','e')
m.b1<-melt(b1,measure=1:4)

summary(aov(value~variable+ Error(sub/value),data=m.b1,))
