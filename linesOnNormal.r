line<-function(m=0,x=1,b=0){m*x+b}
standard.dev<-3
norm<-function(x) {(1/sqrt(2*pi))*exp(-.5*(x^2))}
norm(standard.dev)

data<-rnorm(1e5)
plot(density(data))

#abline(v=standard.dev,col=standard.dev)
#abline(v=-standard.dev,col=standard.dev)
#draw vert lines
segments(y0=0,x0=-standard.dev,y1=norm(standard.dev),x1=-standard.dev,col=standard.dev,lty=standard.dev)
segments(y0=0,x0=standard.dev,y1=norm(standard.dev),x1=standard.dev,col=standard.dev,lty=standard.dev)
#draw Horiz lines
segments(y0=norm(standard.dev),x0=-standard.dev,y1=norm(standard.dev),x1=standard.dev,col=standard.dev,lty=standard.dev)

