library(XML)
#setwd("I:\\work\\Lifespan\\ch.2.1.med WebCT 07012015 190950\\QIZ_5553724_M\\data")
#windater
#setwd("I:\\work\\Lifespan\\ch4 WebCTtest\\QIZ_5553724_M\\data")
#dater
#setwd("/media/brian/dater_bridge2/work/Lifespan/quizzes/ch10/QIZ_5553724_M/data")
dir()

doc<-xmlTreeParse("./ch10.xml" ,useInternalNodes=F)

root<-xmlRoot(doc)
xmlName(root)
xmlSize(root[[1]])
xmlName(root[[1]])
xmlAttrs(root[[1]][[1]])
xmlSApply(root[[1]][[2]],xmlName)
xmlSApply(root[[1]][[2]],xmlSize)

#get node names under root 1: 37 (36 questions)
xmlSApply(root[[1]],xmlName)


#get node names under 2nd node under root 1 : 8, 2nd one "presentation"
xmlSApply(root[[1]][[2]],xmlName)

#get node names under 2nd node under root 1 : 8, 2nd one "presentation"
xmlSApply(root[[1]][[3]],xmlValue)




xpathSApply(root[[1]],"//mattext[@texttype='text/html']",xmlValue)  #does an escape / be needed?
xmlChildren(root[[1]][["item@title"]])



getNodeSet(root[[1]],'//presentation/*/mattext[@texttype="text/html"]')

difficulty<-sapply(getNodeSet(root[[1]],'//*/qmd_levelofdifficulty'),xmlValue) #obtains level of difficulty
questions<-sapply(getNodeSet(root[[1]],'//presentation/flow/material/mattext'),xmlValue)  #question
choices<-sapply(getNodeSet(root[[1]],'//presentation/flow/response_lid//mattext'),xmlValue)   #choices
answers<-sapply(getNodeSet(root[[1]],'//*/setvar[. > 1]/..//varequal'),xmlValue) #obtains answers; note the backing up a node
section<-sapply(getNodeSet(root[[1]],'//*/qtimetadatafield/fieldlabel[. = "QuestionID"]/..//fieldentry'),xmlValue)  #obtain section 1,2, or 3
section<-substr(section,4,4)

output=""
j=1
for (i in 1:length(questions)){
  #output<-paste(output,"new set here--------------------------------",sep='\n')
  correct<-as.integer(answers[i])
  #print (correct)
  #output<-paste(output,'\n',"answer: ", answers[i],sep='')
  #output<-paste(output,'\n',sep='')
  output<-paste(output,"diff: ", difficulty[i],sep='\t')
  output<-paste(output,"section: ",section[i],sep='\t')
  output<-paste(output,questions[i],sep='\t')

  a_i<-" ~"  #answer identifier
  ifelse (correct == 1, a_i<-' =', a_i<-" ~")
  output<-paste(output,choices[j],sep=paste(' {',a_i))
  #print (paste('',choices[j],sep=paste(' {',a_i)))

  ifelse (correct == 2,a_i<-' =',a_i<-" ~")
  output<-paste(output,choices[j+1],sep=a_i)
  #print (paste('',choices[j+1],sep=paste(a_i)))

  ifelse (correct == 3,a_i<-' =',a_i<-" ~")
  output<-paste(output,choices[j+2],sep=a_i)
  ##print (paste('',choices[j+2],sep=paste(a_i)))

  ifelse (correct == 4,a_i<-' =',a_i<-" ~")
  output<-paste(output,choices[j+3],sep=a_i)
  ##print (paste('',choices[j+3],sep=paste(a_i)))

  output<-paste(output,'}',sep='')
  output<-paste(output,'\n\n\n',sep='')
  j=j+4

}


write.table(output, file = "output.csv", append = FALSE, sep = ", ")