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

plot(yc$df$BC_1MONTH~yc$df$dates,type='l',ylim=c(0,6))
lines(yc$df$BC_3MONTH~yc$df$dates,type='l',col='red')
lines(yc$df$BC_10YEAR~yc$df$dates,type='l',col='blue')
lines(yc$df$BC_30YEAR~yc$df$dates,type='l',col='green')


yc$df %>% gather(bond,rate,-dates) %>% filter(bond == "BC_30YEAR" | bond == "BC_20YEAR"| bond == "BC_3MONTH"
) %>% ggplot(aes(x=dates,y=rate,color=bond)) + geom_line()
