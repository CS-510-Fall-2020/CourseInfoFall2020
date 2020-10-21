# CS 510 midterm project
# A mathematical model of a small virus infection over discrete and continuous time models

install.packages("deSolve")
library(deSolve)


odeequations=function(t,y,parameters) 
{ 
  #uninfected target cells, infected target cells, virus
  Utc=y[1]; Itc=y[2]; Vir=y[3]; 
  #parameters
  p1=parameters[1]; p2=parameters[2]; p3=parameters[3]; p4=parameters[4]; 
  
  #differential equations
  dUtcdt=-p1*Vir*Utc;
  dItcdt=p1*Vir*Utc-p2*Itc;
  dVirdt=p3*Itc-p4*Vir;

  return(list(c(dUtcdt,dItcdt,dVirdt))); 
  
} 

#main

#initial number of uninfected target cells 
Utc0=1e8; 
#initial number of infected target cells
Itc0=0; 
#initial condition for free virus V
Vir0=10; 

Y0=c(Utc0, Itc0, Vir0); 

#values for model parameters
p1=1e-8;
p2=2;
p3=1e2;
p4=10;
parameters=c(p1,p2,p3,p4); 

timevec=seq(0,20,0.1); 

odeoutput=lsoda(Y0,timevec,odeequations,parameters);

#discrete time model

dt=.1; 
t.discrete=seq(0,20,by=dt);
Uvec=rep(0,length(t.discrete)); Ivec=Uvec; Vvec=Uvec; 
Uvec[1]=Utc0; Ivec[1]=Itc0; Vvec[1]=Vir0;

for (n in 1:(length(t.discrete)-1)) 
{
  Uvec[n+1]=Uvec[n]- dt*p1*Uvec[n]*Vvec[n];
  Ivec[n+1]=Ivec[n] + dt*(p1*Uvec[n]*Vvec[n]-p2*Ivec[n]);
  Vvec[n+1]=Vvec[n] + dt*(p3*Ivec[n]-p4*Vvec[n]);
}


#plot

#Uninfected plot
plot(odeoutput[,1],odeoutput[,2],type="l",lwd=2,
     xlab="Time (days)", ylab="", main ="Uninfected", sub = "Continous vs. Discrete",
     log="y",xlim=c(0,20),ylim=c(1,1e9), 
     col="green", col.main="deeppink",cex.main=2)
lines(t.discrete,Uvec,col="green",lwd=2,lty=2)

#Infected plot
plot(odeoutput[,1],odeoutput[,3],type="l",lwd=2,
     xlab="Time (days)",ylab="",main ="Infected",sub = "Continous vs. Discrete",
     log="y",xlim=c(0,20),ylim=c(1,1e9),
     col="red",col.main="deeppink",cex.main=2)
lines(t.discrete,Ivec,type="l",col="red",lwd=2,lty=2)

#Virus plot
plot(odeoutput[,1],odeoutput[,4],type="l",lwd=2,
     xlab="Time (days)",ylab="",main ="Virus",sub = "Continous vs. Discrete",
     log="y",xlim=c(0,20),ylim=c(1,1e9),
     col="blue",col.main="deeppink",cex.main=2)
lines(t.discrete,Vvec,type="l",col="blue",lwd=2,lty=2)



