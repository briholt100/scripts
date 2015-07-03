library(XML)
#setwd("I:\\work\\Lifespan\\ch.2.1.med WebCT 07012015 190950\\QIZ_5553724_M\\data")
#windater
setwd("I:\\work\\Lifespan\\ch4 WebCTtest\\QIZ_5553724_M\\data")
dir()

doc<-xmlTreeParse("./ch.2.1.med.xml" ,useInternalNodes=F)

#doc<-xmlTreeParse("./ch4.xml",useInternalNodes=F)
root<-xmlRoot(doc)
xmlName(root)
xmlSize(root[[1]])
xmlName(root[[1]])
xmlAttrs(root[[1]])
xmlSApply(root[[1]][[2]],xmlName)
xmlSApply(root[[1]][[2]],xmlSize)

#get node names under root 1: 37 (36 questions)
xmlSApply(root[[1]],xmlName)


#get node names under 2nd node under root 1 : 8, 2nd one "presentation"
xmlSApply(root[[1]][[2]],xmlName)

#get node names under 2nd node under root 1 : 8, 2nd one "presentation"
xmlSApply(root[[1]][[3]],xmlValue)




xpathSApply(root[[1]],"//mattext[@texttype='text/html']",xmlValue)  #does an escape / be needed?
xmlChildren(root[[1]][[2]][["presentation"]][["flow"]][["material"]])




xpathSApply(root[[1]][[2]][["presentation"]],"//mattext[@texttype='text//html']",xmlValue)




getNodeSet(root[[1]],'//presentation/*/mattext[@texttype="text/html"]')

difficulty<-sapply(getNodeSet(root[[1]],'//*/qmd_levelofdifficulty'),xmlValue) #obtains level of difficulty
questions<-sapply(getNodeSet(root[[1]],'//presentation/flow/material/mattext'),xmlValue)  #question
choices<-sapply(getNodeSet(root[[1]],'//presentation/flow/response_lid//mattext'),xmlValue)   #choices
answers<-sapply(getNodeSet(root[[1]],'//*/setvar[. > 1]/..//varequal'),xmlValue) #obtains answers; note the backing up a node




j=1
for (i in 1:20){
  writeLines (questions[i])
    writeLines(choices[j])
    writeLines(choices[j+1])
    writeLines(choices[j+2])
    writeLines(choices[j+3])
    print ("new set here mother fucker_____--------------------------------")
    j=j+4
  writeLines(c("answer: ",answers[i]))
  writeLines(c("diff: ",difficulty[i]))
}



write.table(Q, file = "output.csv", row.names = FALSE, append = FALSE, col.names = TRUE, sep = ", ")
