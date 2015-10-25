library(tidyr)
df<-read.csv('/home/brian/Projects/data/outfile.csv',sep='\t',strip.white=T)
df$mailstop<-gsub(" ","",df$mailstop)
df$name<-gsub(", II"," II",df$name)
df[duplicated(df$name),]
#"split<-strsplit(as.character(df$name),", ")
#split
#table(lapply(split,length)==2)"
df<-separate(df, name, c("LastName", "FirstName"), ", ",remove=T)

pt<-grep('Faculty|ibrar|ounsel',df$emp_status,value=F)

df_fac<-df[pt,]

#remove dean,manager,eastern fac
dean<-grep('ean|Manager, Library Technical Services|Compliance & Faculty Development Specialist|Rave Test|Eastern',df_fac$emp_status,value=F)
df_fac<-df_fac[-dean,]
#remove sccc
sccc<-grep('CCC',df_fac$LastName,value=F)
df_fac<-df_fac[-sccc,]

df_fac<-droplevels(df_fac)
##create new column for just PT, FT, or PHL?
df_fac$status<-'other'
df_fac$status[grep("PT.*Fac|Adjunct",df_fac$emp_status, value=F)]<-"PT"
df_fac$status[grep("ounse",df_fac$emp_status, value=F)]<-"Counselor"
df_fac$status[grep("Emeritus",df_fac$emp_status, value=F)]<-"Emeritus"
df_fac$status[grep("ibrar",df_fac$emp_status, value=F)]<-"Librarian"
df_fac$status[grep("FT.*Fac",df_fac$emp_status, value=F)]<-"FT"
df_fac$status[df_fac$status=='other']<-"FT"
df_fac$status[df_fac$LastName=='Bates']<-"Librarian"
table(df_fac$status)

df_fac[df_fac$campus=='North Campus',c(1:2,8)]
head(df_fac[df_fac$campus=='North Campus',])
df_fac<-df_fac[,c(1,2,8,5,4,6:7,3)]
write.table(df_fac,"/home/brian/Projects/data/fac_contacts.csv",quote=F,row.names=F,sep="\t")

