library(tidyr)
df<-read.csv('/home/brian/Projects/data/outfile.csv',sep='\t',strip.white=T)
df$mailstop<-gsub(" ","",df$mailstop)
df$name<-gsub(", II"," II",df$name)
df[duplicated(df$name),]
"split<-strsplit(as.character(df$name),", ")
split
table(lapply(split,length)==2)"
df<-separate(df, name, c("LastName", "FirstName"), ", ",remove=T)




head(df)

pt<-grep('Faculty|ibrar|ounsel',df$emp_status,value=F)

df_fac<-df[pt,]
df_fac<-droplevels(df_fac)

dean<-grep('ean',df_fac$emp_status,value=F)
df_fac<-df_fac[-dean,]

df_fac[df_fac$campus=='North Campus',]
head(df_fac[df_fac$campus=='North Campus',])

write.table(df_fac,"/home/brian/Projects/data/fac_contacts.csv",row.names=F,sep="\t")

