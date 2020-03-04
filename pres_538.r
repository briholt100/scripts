library(tidyverse)
evotes<- read.csv('../Data/electoral_votes.csv')
evotes$state <- factor(evotes$state)
df<- read.csv('../Data/presidential_polls.csv',header=T)
str(df)
df %>% select(1:6,sample_size:methodology,start_date:election_date,internal,answer:pct) -> pp
super.tues<- c( 'Alabama', 'Arkansas', 'California', 'Colorado', 'Maine', 'Massachusetts', 'Minnesota', 'North Carolina', 'Oklahoma', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia')
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

still.in<- candidates[c(1,2,3,4,20)]
drop.outs<- candidates[!candidates %in% still.in]

pp %>% filter(state %in% tight.states) -> pp

pp %>% filter(state %in% c(super.tues,"Maine CD-1","Maine CD-2")) -> pp
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
