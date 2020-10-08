## Advection-diffusion model 

# Loads required libraries
#library(random)

# Sources required scripts
source("advect.R")
source("diffuse.R")

#### Defines parameters ####
D <- 1e-2        # Diffusion coefficient in m^2/s
delta.t <- 1e-3  # Time step size in s
end.time <- 1    # End simulation time in s
start.x <- 5.6
start.y <- -0.97

# Creates points to follow
num.dots <- 10000
dotsx <- rep(start.x,num.dots)
dotsy <- rep(start.y,num.dots)
dots.start <- matrix(c(dotsx,dotsy),num.dots,2)

# Reads in position (x,y) and velocity (Ux,Uy) data
x <- as.matrix(read.table("data/x.csv", header = FALSE, sep = ","))
y <- as.matrix(read.table("data/y.csv", header = FALSE, sep = ","))
Ux <- as.matrix(read.table("data/Ux.csv", header = FALSE, sep = ","))
Uy <- as.matrix(read.table("data/Uy.csv", header = FALSE, sep = ","))
Ux[is.na(Ux)] <- 0
Uy[is.na(Uy)] <- 0

t <- 0
dots <- dots.start

#### Simulation #### 
while(t <= end.time){
  dots <- advect(dots,x,y,Ux,Uy,0.5*delta.t)
  dots <- diffuse(dots,D,delta.t)
  dots <- advect(dots,x,y,Ux,Uy,0.5*delta.t)
  t <- t + delta.t
  print(paste("t =", t))
}
dots.end <- dots

plot(dots.end[, 1], dots.end[, 2], col = "black", pch = 19)
points(dots.start[, 1], dots.start[, 2], col = "red", pch = 19)


