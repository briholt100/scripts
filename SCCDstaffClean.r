library(tidyr)
df<-read.csv('/home/brian/Projects/data/outfile.csv',sep='\t',strip.white=T)
df$mailstop<-gsub(" ","",df$mailstop)
df$name<-gsub(", II"," II",df$name)
split<-strsplit(as.character(df$name),", ")
split
split[table(lapply(split,length)>2)]



head(df)

pt<-grep('Faculty|ibrar|ounsel',df$emp_status,value=F)

df_fac<-df[pt,]
df_fac<-droplevels(df_fac)
sort(table((df_fac$mailstop))>100)
length(df_fac$emp_status)
grep('ibrar|ounse|aculty',df_fac$emp_status,value=T)

tail(df_fac)
dean<-grep('ean',df_fac$emp_status,value=F)
df_fac<-df_fac[-dean,]

df_fac[df_fac$campus=='North Campus',]
extract(df, name, c("LastName", "FirstName"), ", ")



