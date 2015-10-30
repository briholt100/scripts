library(tidyr)
df<-read.csv('/home/brian/Projects/data/outfile.csv',sep='\t',strip.white=T)
df$mailstop<-gsub(" ","",df$mailstop)
df$name<-gsub(", II"," II",df$name)
df[duplicated(df$name),]
#"split<-strsplit(as.character(df$name),", ")
#split
#table(lapply(split,length)==2)"
df<-separate(df, name, c("LastName", "FristName"), ", ",remove=T)
df$mailstop<-as.factor(df$mailstop)
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

keys<- c("FT.*Fac","PT.*Fac|Adjunct","ounse","Emeritus", "ibrar" )
values<- c("FT", "PT","Counselor","Emeritus", "Librarian")
df_fac$status<-'other'
for (i in 1:nrow(df_fac)){
  for (j in 1:length(keys)){
    if (grepl(keys[j],df_fac$emp_status[i])){
    df_fac$status[i]<-values[j]
    }
  }
}






df_fac$status[grep("PT.*Fac|djunct",df_fac$emp_status, value=F)]<-"PT"
df_fac$status[grep("ounse",df_fac$emp_status, value=F)]<-"Counselor"
df_fac$status[grep("Emeritus",df_fac$emp_status, value=F)]<-"Emeritus"
df_fac$status[grep("ibrar",df_fac$emp_status, value=F)]<-"Librarian"
df_fac$status[grep("FT.*Fac",df_fac$emp_status, value=F)]<-"FT"
df_fac$status[df_fac$status=='other']<-"FT"
df_fac$status[df_fac$LastName=='Bates']<-"Librarian"
table(df_fac$status)




"
system.time (c(df_fac$status[grep("PT.*Fac|djunct",df_fac$emp_status, value=F)]<-"PT",
df_fac$status[grep("ounse",df_fac$emp_status, value=F)]<-"Counselor",
df_fac$status[grep("Emeritus",df_fac$emp_status, value=F)]<-"Emeritus",
df_fac$status[grep("ibrar",df_fac$emp_status, value=F)]<-"Librarian",
df_fac$status[grep("FT.*Fac",df_fac$emp_status, value=F)]<-"FT"))"

df_fac<-df_fac[,c(1,2,8,5,4,6:7,3)]
write.table(df_fac,"/home/brian/Projects/data/fac_contacts.csv",quote=F,row.names=F,sep="\t")



##
# munging of AFnonFee

AFTnonFee<-read.csv('/home/brian/Projects/data/AFTnonFee.csv',stringsAsFactors=T,sep=',',strip.white=T)
AFTnonFee

AFTnonFee[,c(2,3,4,5,6,10:12,15:20,24:26)]<-sapply(AFTnonFee[,c(2,3,4,5,6,10:12,15:20,24:26)],as.character)
AFTnonFee$mailstop<-as.factor(AFTnonFee$mailstop)
AFTnonFee$Pref.State<-as.factor(AFTnonFee$Pref.State)
sapply(AFTnonFee,class)

#fill in work department via mailstop



