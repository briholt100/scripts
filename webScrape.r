install.packages("XML")
library(XML)
theurl='http://americasmarkets.usatoday.com/2015/04/30/surprise-women-trump-men-on-ceo-pay/'

tables <- readHTMLTable(theurl)

n.rows <- unlist(lapply(tables, function(t) dim(t)[1]))

tables[[which.max(n.rows)]]
names<-as.matrix(tables[[1]][1,])
df<-data.frame(tables[[1]])
colnames(df)<-names

class(df[,4])