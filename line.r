curve(x**2,xlim=c(-10,10),ylim=c(-10,10))

df<-data.frame(cbind(-5,5))
colnames(df)<-c("x","y")
df<-rbind(df,c(6,-1))
df<-rbind(df,c(3,2),c(1,5))

df

p<-c(df[1,1],df[1,2])
q<-c(df[2,1],df[2,2])
a.slope<-slope(p[1],p[2],q[1],q[2])

plot(p[1],p[2],xlim=c(-7,7),ylim=c(-10,10),main=c(paste("slope: ",a.slope[1,1]),paste("Y-int: ",a.slope[1,2])))
points(q[1],q[2])


abline(v=0, col="black")#, lty="dotted")
abline(h=0, col="black")#, lty="dotted")



abline(v=(seq(-10,10,1)), col="lightgray", lty="dotted")
abline(h=(seq(-10,10,1)), col="lightgray", lty="dotted")

abline(a=a.slope[1,2],b=a.slope[1,1],col='blue')



slope<-function(x1,y1,x2,y2){
  b<-(y2-y1)/(x2-x1)
  a<-y2-b*x2
  cbind(b,a)
}