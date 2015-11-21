bogart<-data.frame(rbind(c('subj1',2.0,4.0,5.0,9.0),c('subj2',3,6,7,10),c('subj3',4,5,6,8),c('subj4',4,6,7,10),c('subj5',5,5,7,9)))
class(bogart)
colnames(bogart)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4')
bogart<-as.data.frame(bogart)
subject<-as.factor(c("sub1","sub2","sub3","sub4","sub5"))
tx1<-as.numeric(bogart[,2])
tx2<-as.numeric(bogart[,3])
tx3<-as.numeric(bogart[,4])
tx4<-as.numeric(bogart[,5])
bogart1<-data.frame(cbind(I(subject),tx1, tx2 ,tx3, tx4))

bogart[,2:5]<-apply(bogart[,2:5],2,function(x) as.numeric(x))
for (i in 2:length(bogart)){bogart[,i]<-as.integer(bogart[,i])}
apply(bogart1,2,class)
colnames(bogart1)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4')
bogart1$subject<-subject
write.csv(bogart1,file='./Data/BogartAnova.csv')
bogart1<-read.csv(file='./Data/BogartAnova.csv',stringsAsFactors=F)


bogart$subject<-as.factor(as.character(bogart$subject))



> b1<-data.frame(b1)
> b1$sub<-c('a','b','c','d','e')
m.b1<-melt(b1,measure=1:4)

summary(aov(value~variable+ Error(sub/value),data=m.b1,))





bogart<-as.data.frame(rbind(c(1,2.0,4.0,5.0,9.0),c(2,3,6,7,10),c(3,4,5,6,8),c(4,4,6,7,10),c(5,5,5,7,9)))
colnames(bogart)<-c('subject','tx1', 'tx2' ,'tx3', 'tx4')
rownames(bogart)<-c("sub1","sub2","sub3","sub4","sub5")
apply(bogart,2,class)
bogart<-bogart[,2:5]
sum(bogart)

m.bogart<-melt(bogart,measure=2:5,variable='treatment',value.name='score')

summary(aov(score ~ treatment + Error(as.factor(subject)/score), data=m.bogart))


