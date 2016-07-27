items<-rep(LETTERS,2)[1:30]
lengths<-c(13.375,13.5,13.625,13.75,14,14.25,13.375,13.375,13.875,13.875,13.75,14,13.375,13.5,14,13.75,13.875,13.5,13.5,14,14,14,13.5,14.25,14.5,13.5,13.675,14.25,14.375,14.5)

#bathroom<-read.csv(file='bathroom.csv',colClasses=c("factor","numeric","numeric","numeric"))

spot<-bathroom[,1]
drop<-c(13.375,13.500,13.675,13.750,14.000,14.250,13.375,13.750,13.875,13.875,13.750,14.000,13.375,13.500,
14.000,13.750,13.875,13.500,13.500,14.000,14.000,14.000,13.500,14.250,14.500,13.500,13.675,14.250,14.375,14.500)
X<-c(0,0,0,0,0,0,16,16,16,16,16,16,32,32,32,32,32,48,48,48,48,48,64,64,64,85,85,85,85,85)
Y<-c(0,16,32,52,79,85,0,16,32,40,60,85,0,16,40,70,85,0,16,32,79,85,16,40,75,0,16,48,60,85)


bathroom<-data.frame(spot,drop,X,Y)
summary(bathroom)
str(bathroom)

colnames(bathroom)<-c("spot","drop","X","Y")

plot(bathroom[,2:4])
bathlm<-lm(drop~X+Y,data=bathroom)
summary(bathlm)
library(ggplot2)
library(scatterplot3d)
p<-ggplot(data=bathroom,aes(x=X,y=Y))

p+geom_point(aes(color=drop),size=9)+
scale_colour_gradient(low='blue',high='red')+
geom_smooth(method = "lm", se = FALSE)


p3D<-scatterplot3d(bathroom$X,   # x axis
                bathroom$Y,     # y axis
                bathroom$drop,    # z axis
                main="3-D Scatterplot bathroom",
                color="blue",zlim=c(0,16))

p3D$plane3d(bathlm)
