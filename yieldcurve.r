library('Quandl')
library('ggplot2')
library('tidyr')
yc<-Quandl('USTREASURY/YIELD')
str(yc)
head(yc)
yc %>% gather(bond,rate, -Date) %>% 
  filter(bond == '3 YR' |bond ==  '2 YR'|bond == '5 YR'|bond == '1 YR'|bond == '7 YR')  %>%
  arrange(desc(Date)) %>% 
  tail(100) %>% 
  ggplot(aes(x=Date,y=rate,color=bond)) + 
  geom_line() 
  




yc$






library('ustyc')
library('dplyr')
library('tibble')
yc<-getYieldCurve()#year=2018)
#yc<-getYieldCurve()
yc$df$dates<-as.Date(rownames(yc$df))#,format = "%Y/%m/%d")
yc->yc.full
#yc$df<-subset(yc.full$df,yc.full$df$dates > as.Date(as.character("2018-10-1")))
yc$df$dates<-as.Date(rownames(yc$df))#,format = "%Y/%m/%d")


p<-ggplot(yc$df,aes(dates,y=yc$df$BC_3MONTH))
p+labs(y='rates')+scale_colour_manual(values=c("red","green","blue","black"))+
  geom_point(col='blue')+
  geom_point(aes(y=yc$df$BC_30YEAR),col='red')+
  geom_point(aes(y=yc$df$BC_1MONTH),col='black')+
  geom_smooth(data=yc$df,aes(dates,BC_30YEAR))+
  geom_vline(xintercept = as.numeric(as.Date("2016-11-06")),linetype='dashed')+
  geom_hline(yintercept = .81)+
  geom_vline(xintercept = as.numeric(as.Date("2003-06-19")),linetype='dashed')
  

df1<-yc$df %>% tail(700)
plot(df1$BC_1MONTH~df1$dates,type='l',ylim=c(0,6))
lines(df1$BC_3MONTH~df1$dates,type='l',col='red')
lines(df1$BC_10YEAR~df1$dates,type='l',col='blue')
lines(df1$BC_30YEAR~df1$dates,type='l',col='green')
abline(v=as.numeric(as.Date("2016-11-06")),col='black',lty=3)



yc$df %>% 
  #tail(700) %>% 
  filter(dates > as.numeric(as.Date("2003-06-01")) & dates < as.numeric(as.Date("2010-06-01"))) %>% 
  #filter(BC_3MONTH > .5 & BC_3MONTH< .83) %>% 
  gather(bond,rate,-dates) %>% 
  filter(bond == "BC_30YEAR" | bond == "BC_20YEAR"| bond == "BC_3MONTH") %>% 
  ggplot(aes(x=dates,y=rate,color=bond)) + 
  geom_line() +
  geom_vline(xintercept = as.numeric(as.Date("2016-11-06")),linetype='dashed')

yc$df %>% select(BC_3MONTH,dates) %>% filter(dates > as.numeric(as.Date("2004-03-01")) & dates < as.numeric(as.Date("2004-06-01"))) %>% ggplot(aes(x=dates,y=BC_3MONTH))+geom_line()
yc$df %>%  filter(dates > as.numeric(as.Date("2003-03-01")) & dates < as.numeric(as.Date("2008-06-01"))) %>%   gather(bond,rate,-dates) %>% ggplot(aes(x=dates,y=rate,color=bond))+geom_line()+geom_vline(xintercept = as.numeric(as.Date("2004-04-01")),linetype='dashed')

yc$df %>% tail() %>% gather(bond,rate,-dates) %>% arrange(desc(dates)) %>% ggplot(aes(x=dates,y=rate,color=bond))+geom_line()

see package directlabels https://stackoverflow.com/questions/29357612/plot-labels-at-ends-of-lines