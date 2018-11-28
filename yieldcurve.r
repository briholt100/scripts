library('ustyc')
library('ggplot2')
library('tidyr')
library('dplyr')
library('tibble')
yc<-getYieldCurve()#year=2018)
#yc<-getYieldCurve()
yc$df$dates<-as.Date(rownames(yc$df))#,format = "%Y/%m/%d")
yc->yc.full
yc$df<-subset(yc.full$df,yc.full$df$dates > as.Date(as.character("2018-10-1")))
yc$df$dates<-as.Date(rownames(yc$df))#,format = "%Y/%m/%d")


p<-ggplot(yc$df,aes(dates,y=yc$df$BC_3MONTH))
p+labs(y='rates')+scale_colour_manual(values=c("red","green","blue","black"))+
  geom_point(col='blue')+
  geom_point(aes(y=yc$df$BC_30YEAR),col='red')+
  geom_point(aes(y=yc$df$BC_1MONTH),col='black')+
  geom_smooth(data=yc$df,aes(dates,BC_30YEAR))

df1<-yc$df %>% tail(700)
plot(df1$BC_1MONTH~df1$dates,type='l',ylim=c(0,6))
lines(df1$BC_3MONTH~df1$dates,type='l',col='red')
lines(df1$BC_10YEAR~df1$dates,type='l',col='blue')
lines(df1$BC_30YEAR~df1$dates,type='l',col='green')
#abline(v=2016-11-6,col='red')


yc$df %>% tail(700) %>% gather(bond,rate,-dates) %>% filter(bond == "BC_30YEAR" | bond == "BC_20YEAR"| bond == "BC_3MONTH"
) %>% ggplot(aes(x=dates,y=rate,color=bond)) + geom_line() +geom_vline(xintercept = as.numeric(as.Date("2016-11-06")))
