library(tidyverse)
library(lubridate)
evotes<- read.csv('../Data/electoral_votes.csv')
evotes$state <- factor(evotes$state)
df<-  read.csv('https://projects.fivethirtyeight.com/polls-page/president_polls.csv',stringsAsFactors = F,header=T)
str(df)
df %>% select(1:6,sample_size:methodology,start_date:election_date,internal,answer:pct) -> pp

pp[,11:13] <- lapply(pp[,11:13],mdy)
pp[,c(4:6,8:10,14,16:17)] <- lapply(pp[,c(4:6,8:10,14,16:17)],factor)

str(pp)
super.tues<- c( 'Alabama', 'Arkansas', 'California', 'Colorado', 'Maine', 'Massachusetts', 'Minnesota', 'North Carolina', 'Oklahoma', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia')

Mar10.primary <- c(
  'Idaho',
  'Michigan',
  'Mississippi',
  'Missouri',
  'North Dakota',
    'Washington')
tight.states <- c( 'Michigan',
'New Hampshire',
'Pennsylvania',
'Wisconsin',
'Florida',
'Minnesota',
'Nebraska',
'Nevada',
'Maine',
'Arizona',
'North Carolina',
'Colorado')
candidates<- unique(pp$candidate_name)

still.in<- candidates[c(1,2,3,20,4)]
drop.outs<- candidates[!candidates %in% still.in]

#pp %>% filter(state %in% tight.states) -> pp

#pp %>% filter(state %in% c(super.tues,"Maine CD-1","Maine CD-2")) -> pp
str(pp)
tapply(pp$pct,list(pp$candidate_name,pp$candidate_party,pp$state),mean, na.rm=T)


pp %>% select(state,candidate_party,candidate_name,pct) %>%
  filter(candidate_name %in% still.in) %>%
  group_by(state,candidate_name,candidate_party) %>%
  summarise(mean.pct=median(pct,na.rm = T)) %>%
  group_by(state,candidate_party) %>% top_n(2) %>%
  ggplot(aes(x=candidate_name,y=mean.pct,fill=candidate_name))+
  geom_col()+facet_wrap(~state)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

df %>% select(state,candidate_name,candidate_party,pct) %>%
  filter(candidate_name=="Donald Trump",state=='Maine') %>%
  summarise(mean.pct=mean(pct))

group_by(state) %>% top_n(1) %>% group_by(state,candidate_party) %>% summarise(n()) %>% full_join(evotes) %>% group_by(candidate_party) %>% summarise(total_ev=sum(ev))

national.avg<- pp %>% select(candidate_name,pct,state,end_date) %>% filter(state=='') %>% group_by(candidate_name) %>% summarise(mean.pct=mean(pct,na.rm=T)) %>% filter(candidate_name %in% still.in)

pp %>% select(candidate_name,candidate_party,state,end_date,pct) %>% filter(candidate_name %in% still.in) %>% filter(end_date>"2020-02-24") %>% filter(state %in% c("",Mar10.primary)) %>%
  group_by(candidate_name,candidate_party,end_date,state) %>% summarise(mean.pct=mean(pct,na.rm = T)) %>%
  ggplot(aes(x=end_date,y=mean.pct,color=candidate_name))+
  geom_jitter()+#geom_smooth(method='loess',se=F)+
  geom_line(linetype="dashed")+
#  geom_hline(data=national.avg,
 #            aes(yintercept=national.avg$mean.pct,
#                 group=national.avg$candidate_name,color=candidate_name),linetype="dotted")+
  #ylim(35,55)+
    ggtitle("National Polling for General Election\n(horizontal lines are candiate's national avg)\nEach point is an average of polling for that date")+
  xlab("closing date of poll")+
  ylab("average %")+
  facet_wrap(~state)
