## Diffusion function
diffuse<-function(dots,D,delta.t){
  #require(random)
  #randos<-randomNumbers(n=length(dots[,1]),min=0,max=2*pi)
  randos<-runif(n=length(dots[,1]),min=0,max=2*pi)
  dist <- sqrt(4*D*delta.t)
  dots[,1]<-dots[,1]+dist*cos(randos)
  dots[,2]<-dots[,2]+dist*sin(randos)
  return(dots)
}