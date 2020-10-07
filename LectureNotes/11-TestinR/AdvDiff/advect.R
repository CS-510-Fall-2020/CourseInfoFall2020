## Advection component
advect<-function(dots,x,y,Ux,Uy,delta.t){
  idx<-find.spot(dots[,1],x)
  idy<-find.spot(dots[,2],y)
  dots[,1]<-dots[,1]+Ux[idx]*delta.t
  dots[,2]<-dots[,2]+Uy[idy]*delta.t
  return(dots)
}

find.spot<-function(points,field) {
  idx<-rep(NA,length=length(points))
  for (j in 1:length(points)) idx[j] <- which.min((field - points[j])^2)
  return(idx)
}