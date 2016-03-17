sb<-mylist[[36]][1]
wid<-vector("list",length(sb))
for(i in 1:length(sb)){
  text<-as.character(sb[[i]][1])
  title_start<-gregexpr(' Job Title',text)
  sal_start<-gregexpr('2010 Gross',text)
  sal_end<-gregexpr('2010 Gross',text)
  wid[[i]]<-c(title_start[[1]][1]-1,
              sal_start[[1]][1]-title_start[[1]][1]+2,
              60)
  ###Notice that sal_width might need to pick the 2nd element [[1]][2]
}
wid[[1]]
sb<-mylist[[36]][1]
#sb<-readLines(textConnection(sb))
n<-as.integer(wid[[1]][1]-2)
lhs<-paste0('(\n.{', n,'}) ')
rhs<-'\\1\t'


for (i in 1:length(sb)){
  #sb[i]<-gsub("(\n.{31}) ",'\\1\\t',sb[i])
  sb[i]<-gsub(lhs,rhs,sb[i])
}

read.delim(textConnection(sb),stringsAsFactors=F,strip.white=T)
