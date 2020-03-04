library(tidyverse)
library(ggplot2)
library(dplyr)


df<- read.csv(file='../Data/Iowa.csv',header=T,stringsAsFactors = F)

df<- apply(df,2,function(x) gsub('-', NA,x))
df <- data.frame(df)
df1 <- df[,1:35]
df2<- df[,c(1,36:69)]
df3<- df[,c(1,70:103)]
colnames(df2) <- c("candidate",colnames(df1[-1]))
colnames(df3) <- colnames(df2)#what they should be

df3 <- data.frame(df3)
df3$Adams <- gsub("\\*","",df3$Adams)
df3$Adams <- as.integer(df3$Adams)
df3$candidate <- as.factor(df3$candidate)
df3[,2:35] <- apply(df3[,2:35],2,function(x) as.numeric(x))
df1[,2:35] <- apply(df1[,2:35],2,function(x) as.numeric(x))
df2[,2:35] <- apply(df2[,2:35],2,function(x) as.numeric(x))
df2$candidate <- as.factor(df2$candidate)

dif.df<- as.matrix( df1[,-1])-as.matrix(df3[,-1]) 
dif.df <- data.frame(dif.df)
candidate <- df2$candidate
dif.df <- cbind(candidate,dif.df)
dif.df$candidate <- as.factor(dif.df$candidate)


dif.df %>% gather(county,value,-candidate) %>% 
  group_by(county,candidate) %>% 
  summarise(sum=sum(value)) %>% filter(sum != 0) %>% 
  ggplot(aes(x=candidate,y=sum,color=county)) + 
  
  facet_wrap(~candidate)+
  geom_hline(yintercept=0)+
  geom_col()+theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ggtitle("delegate differences between original and corrected \nafter dropping zero differences")




df1

df3 %>% gather(county,delegates,-candidate) %>% 
  group_by(candidate,county) %>% 
  summarise(sum=sum(abs(delegates))) %>% 
  ggplot(aes(x=candidate,y=sum,color=candidate))+geom_col()+
  facet_wrap(~county)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
  



# using rules to create accurate count ------------------------------------

df2 %>% mutate(
  case_when(
    
  )
)


convert_delegate <- function(x) {
  df.temp<- data.frame(matrix(ncol=4,nrow=length(x)))
  df.temp[,1] <- x
  print(sum(df.temp[,1],na.rm=T))
  
  df.temp[,1]<- ifelse(is.na(x),0,x)
  df.temp[,2]<- round(df.temp[,1])
  df.temp[,3] <- (df.temp[,1]-df.temp[,2])
  if(unique(df.temp[,3]))
  if(sum(df.temp[,2]==0)){0}
  ifelse(
          sum(df.temp[,2])>0, 
          df.temp[which.min(df.temp[,3]),4] <- df.temp[which.min(df.temp[,3]),2]-1,
          df.temp[which.max(df.temp[,3]),4] <-  df.temp[which.max(df.temp[,3]),2]+1)
  
  print(df.temp)
}
apply(df2[,2:34],2,convert_delegate)





library(rvest)
url <- 'https://www.iowa-demographics.com/counties_by_population'
page<- read_html(url)
xpath.from.src <- "/html/body/div[3]/div[1]/div/table"
page %>% html_nodes(.,xpath=xpath.from.src)->table.out
iowa.df <-  table.out %>% html_table(fill = T)
iowa.df <- data.frame(iowa.df)
iowa.df <- iowa.df[-100,]
iowa.df[,1]  <- as.integer(iowa.df[,1])
iowa.df[,2]  <- gsub(" county","",ignore.case=T,iowa.df[,2])
iowa.df[,2]  <- as.factor(iowa.df[,2])
iowa.df[,3]<- as.numeric(gsub(",","",iowa.df$Population))
str(iowa.df)

abs.dif.df<- abs(dif.df[,-1])
abs.dif.df$candidate <-dif.df$candidate 

split.counties.df<- abs.dif.df %>% select(candidate,matches('Dubuq|Musca|Polk|Webs',.))
non.split.counties.df<- abs.dif.df %>% select(candidate,Adair:Dickinson,Guthrie:Johnson,Osceola,Scott:Warren,Woodbury)


split.counties.df[,2:4] %>% mutate(Dubuque.full=Reduce(f='+', .))->dubuque
split.counties.df[,5:9] %>% mutate(Muscatine.full=Reduce(f='+', .))->Muscatine
split.counties.df[,10:16] %>% mutate(Polk.full=Reduce(f='+', .))->polk
split.counties.df[,17:18] %>% mutate(Webster.full=Reduce(f='+', .))->Webster

merged.counties.df<- cbind(dubuque,Muscatine,polk,Webster) %>% select(ends_with("full")) %>% with(cbind(.,non.split.counties.df))

total.errors <- apply(merged.counties.df[,-5],2,sum)
total.errors <- data.frame(total.errors)
rownames(total.errors) <-  c("Dubuque","Muscatine","Polk"     ,"Webster",  
"Adair"         ,"Adams"         ,"Buena.Vista"   ,"Carroll",       
"Cherokee"      ,"Chickasaw"     ,"Dickinson"     ,"Guthrie"       
,"Hardin"        ,"Harrison"      ,"Jasper"        ,"Johnson"       
,"Osceola"       ,"Scott"         ,"Sioux"         ,"Warren"        
,"Woodbury")
  
county<- rownames(total.errors)
total.errors <- cbind(county,total.errors)
pop.errors <- iowa.df[,2:3] %>% left_join(total.errors,by =c("County" = "county")) 

pop.errors<- pop.errors[complete.cases(pop.errors),]

summary(pop.errors)

cor(pop.errors$Population,pop.errors$total.errors)
pop.errors.s<- data.frame(scale(pop.errors[,2:3]))
m1<- lm(data = pop.errors.s,total.errors~Population)
##one thought is to just caputre all errors, regardless of direction by converting to abs
summary(m1)
## but we do care about directino, so we should also keep track of sign +\-
## do both?  have one county column with errors summed, another with abs summed.


##join them back to unslpit counties
dif.df %>% select(matches('Dubuq|Musca|Polk|Webs',.))

 write.csv(dif.df,file='dif_counts_iowa.csv')
#dif.df <- read.csv(file='dif_counts_iowa.csv')





