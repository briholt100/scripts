library('Quandl')
library('ggplot2')
library('ustyc')
library('dplyr')
library('tibble')
library('tidyr')

yc<-Quandl('USTREASURY/YIELD')
str(yc)
head(yc)
names.yc<-names(yc)


names(yc)<-gsub("([0-9]{1,2}) ([A-Z]{2})","\\2\\1",names.yc)
today<-yc %>%
  arrange(desc(Date)) %>%
  head(10) %>%
  gather(bond,rate, -Date) %>%
  arrange(desc(Date)) %>%
  head(12) %>%
  arrange(desc(rate))
today
yc %>%
  arrange(desc(Date)) %>%
  head(5) %>%
  gather(bond,rate, -Date) %>%
  filter(#bond == '1 MO' |bond == '2 MO' |bond == '3 MO' |
    bond == '6 MO' |
      bond == '3 YR' |
      bond ==  '2 YR'|
      bond == '5 YR'|
      bond == '1 YR'|
      bond == '7 YR')  %>% with(plot(rate~Date,data = . ))

yc %>%
  arrange(desc(Date)) %>%
  head(105) %>%
  gather(bond,rate, -Date) %>%
  group_by(bond,Date) %>%
  filter(Date>"2020-02-01") %>%
  filter(grepl('YR',bond)) %>%
  filter(nchar(bond)<4|bond=='YR30') %>%
  ggplot(aes(x=Date,y=rate,color=bond)) +
  geom_line() +
  geom_point(data=today, aes(y = today$rate))+geom_text(data=today,aes(label=bond),hjust=0, vjust=-.8)




yc %>%
  arrange(desc(Date)) %>%
  head(10) %>%
  mutate(one=YR7-YR1,six=YR7-MO6,two=YR7-YR2) %>%
  select(one,six,two,Date) %>%
  gather(key=bond,value=rate,-Date) %>% group_by(bond, Date) %>%
  ggplot(aes(x=Date,y=rate,color=bond))+geom_line()


yc<-getYieldCurve(year=2019)
#yc<-getYieldCurve()
yc$df$dates<-as.Date(rownames(yc$df))#,format = "%Y/%m/%d")
yc->yc.full
#yc$df<-subset(yc.full$df,yc.full$df$dates > as.Date(as.character("2018-10-1")))
yc$df$dates<-as.Date(rownames(yc$df))#,format = "%Y/%m/%d")
read.csv(url('http://data.treasury.gov/feed.svc/DailyTreasuryYieldCurveRateData'))

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