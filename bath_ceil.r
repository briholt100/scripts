items<-rep(LETTERS,2)[1:30]
lengths<-c(13.375,13.5,13.625,13.75,14,14.25,13.375,13.375,13.875,13.875,13.75,14,13.375,13.5,14,13.75,13.875,13.5,13.5,14,14,14,13.5,14.25,14.5,13.5,13.675,14.25,14.375,14.5)

#bathroom<-read.csv(file='bathroom.csv',colClasses=c("factor","numeric","numeric","numeric"))

spot<-rep(letters,2)[1:30]
spot[27:30]<-c('aa','bb','cc','dd')
drop<-c(13.375,13.500,13.675,13.750,14.000,14.250,13.375,13.750,13.875,13.875,13.750,14.000,13.375,13.500,
14.000,13.750,13.875,13.500,13.500,14.000,14.000,14.000,13.500,14.250,14.500,13.500,13.675,14.250,14.375,14.500)
X<-c(0,0,0,0,0,0,16,16,16,16,16,16,32,32,32,32,32,48,48,48,48,48,64,64,64,85,85,85,85,85)
Y<-c(0,16,32,52,79,85,0,16,32,40,60,85,0,16,40,70,85,0,16,32,79,85,16,40,75,0,16,48,60,85)


bathroom<-data.frame(spot,drop,X,Y)
summary(bathroom)
str(bathroom)

plot(bathroom[,2:4])
plot(bathroom[,3:2])
abline(lm(drop~X, data=bathroom),col='blue')
abline(lm(drop~Y, data=bathroom),col='red')

plot(bathroom[,3:4])
abline(lm(X~Y, data=bathroom),col='red')
abline(lm(X~drop, data=bathroom),col='blue')
plot(bathroom[,c(2,4)])
abline(lm(Y~X, data=bathroom),col='red')
abline(lm(Y~drop, data=bathroom),col='blue')




bathlm<-lm(drop~Y,data=bathroom)
summary(bathlm)
library(ggplot2)
library(scatterplot3d)
library(tidyr)
library(dplyr)


bathroom %>% gather() %>% head()

bathroom[,-1] %>%  gather(-drop ,key='var',value='value')%>%
  ggplot(aes(x=value,y=drop,color=drop))+
  stat_smooth() + geom_point()+
  scale_colour_gradient(low='blue',high='red')


p<-ggplot(data=bathroom,aes(x=X,y=Y,label = spot))

p+geom_point(aes(color=round(drop-min(drop),3)),size=5)+
scale_colour_gradient(low='blue',high='red')+
geom_text(aes(label=round(drop-min(drop),3)),nudge_x=5)+theme(legend.title=element_blank())+ggtitle("Rise in inches from lowest point")+geom_abline(aes(intercept=13.49,slope=.00825))


p3D<-scatterplot3d(bathroom$X,   # x axis
                bathroom$Y,     # y axis
                bathroom$drop,    # z axis
                main="bathroom",
                col.axis="blue",
                color = rgb(red=(15:1/30),blue=(30:1/30),green=0),zlim=c(0,16),
                angle=24,
                type='h',
                xlab="hallway",ylab="adjacent wall",zlab="drop from ceiling to level")

p3D$plane3d(bathlm,col='red')

par(mfrow=c(1,3))
for (i in 2:4){plot(density(bathroom[,i]))}
