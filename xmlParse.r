doc<-xmlTreeParse("I:\\work\\Lifespan\\ch.2.1.med WebCT 07012015 190950\\QIZ_5553724_M\\data\\ch.2.1.med.xml")
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
xmlSApply(root[[1]][[3]][[3]],xmlValue)



root[[1]][[3]]
xmlValue(root[[1]][[4]])  #question# 2.1.9 [[4]]; [[2]] = 2.1.5


xmlValue(root[[1]][[2]][[2]]) #first question text and answers 2nd node, 2 element
xmlSApply(root[[1]][[2]][[2]],xmlValue)
xmlValue(root[[1]][[2]][[1]][[5]])  #difficulty =2, first question (3rd node, 5th element)

#2nd question
xmlValue(root[[1]][[3]][[2]])

#3rd
xmlSApply(root[[1]][[3]][[3]],xmlValue)

#4
xmlSApply(root[[1]][[4]][[3]],xmlValue)

#34
xmlSApply(root[[1]][[35]][[3]],xmlValue)

#36
xmlSApply(root[[1]][[37]][[3]],xmlValue)
