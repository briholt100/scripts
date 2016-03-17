sb<-mylist[[1]][1]
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

n<-vector("integer",length(sb))
for (i in 1:length(wid)){
  n[i]<-as.integer(wid[[i]][1]-1) #the 'minus' 1 moves the cursor to just before the beginning of the word
  }
n

rhs<-'\\1\t'
for (i in 1:length(sb)){
  lhs<-paste0('(\n.{', n[i],'})')
  sb[[i]][1]<-gsub(lhs,rhs,sb[[i]][1])  #this works.  
  sb[[i]][1]<-recursive_replace(text=sb[[i]][1])
 }

tail(read.delim(textConnection(as.character(sb[1])),stringsAsFactors=F,strip.white=T,skip=1),30)
sb

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
