items<-rep(LETTERS,2)[1:30]
lengths<-c(13.375,13.5,13.625,13.75,14,14.25,13.375,13.375,13.875,13.875,13.75,14,13.375,13.5,14,13.75,13.875,13.5,13.5,14,14,14,13.5,14.25,14.5,13.5,13.675,14.25,14.375,14.5)

bathroom<-data.frame(items,lengths)
summary(bathroom)
str(bathroom)

coord<-data.frame(
c(0.0,0.0,0,32,0,52,0,79,0,85,16,0,16,16,16,32,16,40,16,60,16,85,32,0,32,16,32,40,32,79,32,85,48,0,48,16,48,32,48,79,48,85,64,20,64,16,64,40,64,60,85,0,85,16,85,48,85,60,85,85))

length(coord[seq(1,60,2),])
coord[seq(2,60,2),]
bathroom<-data.frame(bathroom,coord[seq(1,60,2),],coord[seq(2,60,2),])
colnames(bathroom)<-c("items","drop","X","Y")

plot(bathroom[,2:4])
bathlm<-lm(drop~X+Y,data=bathroom)
library(ggplot2)
