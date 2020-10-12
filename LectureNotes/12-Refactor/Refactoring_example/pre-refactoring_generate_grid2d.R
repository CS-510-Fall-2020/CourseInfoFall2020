# Generates grid for use with Constraint IB Method IBAMR
# GtD = gap to diameter ratio between hairs
# dist = distance from antennule
# theta = angle of center hair with positive x-axis
#
# To run this R script on Bridges, enter the following commands: 
# - module add R
# - R   ## This will start R!##
# - source('generate_grid2d.R')  ## Follow prompts if installing packages
# - quit
# - n


# Install packages. You should only have to run these once!
#install.packages("useful",dependencies = TRUE, repos='http://cran.us.r-project.org')
#install.packages("pracma",dependencies = TRUE, repos='http://cran.us.r-project.org')

#### Loads required packages ####
require(pracma)
require(useful)

startrun=1
endrun=1

#### Defines functions ####
## Creates and plots hairs with circle (if plotting is turned on)
# hairxCenterx = x position of center of hair
# hairxCentery = y position of center of hair
# L = length of computational domain
# dx = spacing of points inside hair
circle<-function(center,radius,L,dx){
	x_grid = seq(-(radius+0.01),radius+0.01,by=dx)
	y_grid = seq(-(radius+0.01),radius+0.01,by=dx)
	whole_grid = meshgrid(x_grid,y_grid)
	
	THETA=c(seq(0,2*pi,length=250),0)
	RHO=array(1,length(THETA))*radius
	Z = array(1,length(RHO))*0
	nap<-matrix(c(THETA,RHO),nrow=length(THETA),ncol=2)
	points<-pol2cart(RHO,THETA)
	points<-as.data.frame(points)
	
	In<-inpolygon(whole_grid$X,whole_grid$Y,points$x,points$y,boundary=FALSE)
	Xin<-whole_grid$X[In]
	Yin<-whole_grid$Y[In]
	
	X<-Xin+center[1]
	Y<-Yin+center[2]
	circ<-data.frame(X,Y)
	return(circ)
}

## Main function to create hairs
## sets other necessary parameters that are internal to the function
## Takes th and GtD from allpara text file and sets these features 
## for each run number. 
# th = theta, angle of hair array relative to x positive axis
# GtD = gap-to-diameter ratio of hairs in the array
# number = simulation number in set
makehairs<-function(th,GtD,number){
  
  #th=0
  np = 3
  L = 2.0         # length of computational domain (m)
  N = 4096        # number of Cartesian grid meshwidths at the finest level of the AMR grid
  dx = (2.0*L)/(N*np)  # Cartesian mesh width (m)
  # Notes ~ Rule of thumb: 2 boundary points per fluid grid point. 
  #        vertex pts too far apart: flow thru boundary, too close: numerical weirdness
  NFINEST = 5  # NFINEST = 4 corresponds to a uniform grid spacing of h=1/64
  kappa_target = 1.0e-2        # target point penalty spring constant (Newton)
  
  #hdia = (3/8)*0.01     # Diameter of hair
  #adia = 10*hdia     # Diameter of flagellum
  hdia <- 0.002     # Diameter of hair
  adia <- 0.1     # Diameter of flagellum
  
  th2 = (th/180)*pi      # Angle off positive x-axis in radians
  #GtD = 1.0      # Gap width to diameter ratio
  dist = 2*hdia     # Distance between antennule and hair 
  mindGap = (0.5*adia)+(0.5*hdia)+dist  # Calculate distance between hair centers
  width = GtD*hdia+hdia
  
  #### Calculates center positions (x,y) of each hair ####
  hair1Centerx <- mindGap * cos(th2)
  hair1Centery <- mindGap * sin(th2)
  
  hair2Centerx <- hair1Centerx - width * sin(th2)
  hair2Centery <- hair1Centery + width * cos(th2)
  
  hair3Centerx <- hair1Centerx + width * sin(th2)
  hair3Centery <- hair1Centery - width * cos(th2)
  
  hair4Centerx <- hair1Centerx + width * cos(th2 + (30/180) * pi)
  hair4Centery <- hair1Centery + width * sin(th2 + (30/180) * pi)
  
  hair5Centerx <- hair1Centerx + width * cos(th2 - (30/180) * pi)
  hair5Centery <- hair1Centery - width * sin(-th2 + (30/180) * pi)
  
  hair6Centerx <- hair2Centerx + width * cos(th2 + (30/180) * pi)
  hair6Centery <- hair2Centery + width * sin(th2 + (30/180) * pi)
  
  hair7Centerx <- hair3Centerx + width * cos(th2 - (30/180) * pi)
  hair7Centery <- hair3Centery - width * sin(-th2 + (30/180) * pi)
  
  hair8Centerx <- hair7Centerx + width * cos(th2 - (30/180) * pi)
  hair8Centery <- hair7Centery - width * sin(-th2 + (30/180) * pi)
  
  #### Produces points within defined hairs ####
  
  # Antennule
  ant<-circle(c(0,0),0.5*adia,L,dx);  # Produces points that define antennule
  aN<-size(ant$X,2)                   # Records number of points inside antennule
  plot(Y~X,data=ant,xlim=c(-0.5,0.5),ylim=c(-0.5,0.5),pch=19) #Plots antennule
  
  # Hair 1
  h1<-circle(c(hair1Centerx,hair1Centery),0.5*hdia,L,dx)
  h1N<-size(h1$X,2)
  disp(h1N)
  points(Y~X,data=h1,pch=19)
  
  # Hair 2
  h2<-circle(c(hair2Centerx,hair2Centery),0.5*hdia,L,dx)
  h2N<-size(h2$X,2)
  points(Y~X,data=h2,pch=19)
  
  # Hair 3
  h3<-circle(c(hair3Centerx,hair3Centery),0.5*hdia,L,dx)
  h3N<-size(h3$X,2)
  points(Y~X,data=h3,pch=19)
  
  # Hair 4
  h4<-circle(c(hair4Centerx,hair4Centery),0.5*hdia,L,dx)
  h4N<-size(h4$X,2)
  points(Y~X,data=h4,pch=19)
  
  # Hair 5
  h5<-circle(c(hair5Centerx,hair5Centery),0.5*hdia,L,dx)
  h5N<-size(h5$X,2)
  points(Y~X,data=h5,pch=19)
  
  # Hair 6
  h6<-circle(c(hair6Centerx,hair6Centery),0.5*hdia,L,dx)
  h6N<-size(h6$X,2)
  points(Y~X,data=h6,pch=19)
  
  # Hair 7
  h7<-circle(c(hair7Centerx,hair7Centery),0.5*hdia,L,dx)
  h7N<-size(h7$X,2)
  points(Y~X,data=h7,pch=19)
  
  # Hair 8
  h8<-circle(c(hair8Centerx,hair8Centery),0.5*hdia,L,dx)
  h8N<-size(h8$X,2)
  points(Y~X,data=h8,pch=19)
  
  #### Write points to vertex file ####
  
  totalN<-aN+h1N+h2N+h3N+h4N+h5N+h6N+h7N+h8N  # Calculates total number of points (first line of vertex file)
  
  filename<-paste("hairs",number,".vertex",sep="")   # Defines file name
  if(file.exists(filename)) file.remove(filename)  # Deletes file with that name if it exists
  cat(as.character(totalN),sep="\n",file=filename,append=TRUE)
  for (i in 1:aN){
  cat(c(as.character(ant$X[i])," ",as.character(ant$Y[i]),"\n"),file=filename,sep="",append=TRUE)
  }
  for (i in 1:h1N){
  cat(c(as.character(h1$X[i])," ",as.character(h1$Y[i]),"\n"),file=filename,sep="",append=TRUE)
  }
  for (i in 1:h2N){
  cat(c(as.character(h2$X[i])," ",as.character(h2$Y[i]),"\n"),file=filename,sep="",append=TRUE)
  }
  for (i in 1:h3N){
  cat(c(as.character(h3$X[i])," ",as.character(h3$Y[i]),"\n"),file=filename,sep="",append=TRUE)
  }
  for (i in 1:h4N){
    cat(c(as.character(h4$X[i])," ",as.character(h4$Y[i]),"\n"),file=filename,sep="",append=TRUE)
  }
  
  for (i in 1:h5N){
    cat(c(as.character(h5$X[i])," ",as.character(h5$Y[i]),"\n"),file=filename,sep="",append=TRUE)
  }
  
  for (i in 1:h6N){
    cat(c(as.character(h6$X[i])," ",as.character(h6$Y[i]),"\n"),file=filename,sep="",append=TRUE)
  }
  
  for (i in 1:h7N){
    cat(c(as.character(h7$X[i])," ",as.character(h7$Y[i]),"\n"),file=filename,sep="",append=TRUE)
  }
  
  for (i in 1:h8N){
    cat(c(as.character(h8$X[i])," ",as.character(h8$Y[i]),"\n"),file=filename,sep="",append=TRUE)
  }
  a<-c(aN,0,0)
  h1<-c(h1N,hair1Centerx,hair1Centery)
  h2<-c(h2N,hair2Centerx,hair2Centery)
  h3<-c(h3N,hair3Centerx,hair3Centery)
  h4<-c(h4N,hair4Centerx,hair4Centery)
  h5<-c(h5N,hair5Centerx,hair5Centery)
  h6<-c(h6N,hair6Centerx,hair6Centery)
  h7<-c(h7N,hair7Centerx,hair7Centery)
  h8<-c(h8N,hair8Centerx,hair8Centery)
  write.csv(data.frame(a,h1,h2,h3,h4,h5,h6,h7,h8),file=paste("hairs",number,".csv",sep=""),row.names = FALSE)

}

##### Input parameter definitions ####

parameters<-read.table("allpara_165.txt")
names(parameters)<-c("angle","gap","Re")

for (i in startrun:endrun) makehairs(parameters$angle[i],parameters$gap[i],i)