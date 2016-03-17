sb<-mylist
wid<-vector("list",length(sb))
for(i in 1:length(sb)){
  text<-as.character(sb[[i]][1])
  title_start<-gregexpr('Job Title',text)
  sal_start<-gregexpr('2010 Gross',text)
  sal_end<-gregexpr('2010 Gross',text)
  wid[[i]]<-c(title_start[[1]][1]-2,  # the 'minus 2' accounts for some carraiage return, hidden characters at front of line.
              #sal_start[[1]][1]-title_start[[1]][1],
              60)
  }
wid[[1]]
sb<-mylist[[36]][1]
#sb<-readLines(textConnection(sb))
n<-as.integer(wid[[1]][1]-1) #the 'minus' 1 moves the cursor to just before the beginning of the word
lhs<-paste0('(\n.{', n,'})')
rhs<-'\\1\t'


for (i in 1:length(sb)){
  sb[i]<-gsub(lhs,rhs,sb[i])  #this works.  
  sb[i]<-recursive_replace(text=sb[i])
 }

tail(read.delim(textConnection(sb),stringsAsFactors=F,strip.white=T,skip=1),30)
sb

if '\t\t|\t \t' turn to \t

recursive_replace<-function(text=text){
  text<-gsub('([[:alpha:]]) {2}([[:alpha:]])','\1 \2',text)
  while (grepl(' {2}',text)){
    text<-gsub(' {2}','\t',text)
  }
  while (grepl('\t\t|\t \t',text)){
    text<-gsub('\t\t|\t \t','\t',text)
    print (grepl('\t\t|\t \t',text))
  }
  return(text)
}
