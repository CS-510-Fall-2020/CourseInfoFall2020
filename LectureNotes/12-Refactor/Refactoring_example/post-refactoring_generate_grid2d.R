# Generates grid for use with Constraint IB Method IBAMR
# GtD = gap to diameter ratio between hairs
# dist = distance from antennule
# theta = angle of center hair with positive x-axis
#
# To run this R script on Bridges, enter the following commands: 
# - module add R
# - R   ## This will start R!##
# - source('generate_grid2d.R')  ## Follow prompts if installing packages
# - quit()
# - n

#### Loads required packages ####

packages <- c("pracma", "useful")

package.check <- lapply(
  packages,
  FUN <- function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE, repos='http://cran.us.r-project.org')
      library(x, character.only = TRUE)
    }
  }
)

#### Defines required parameters #### 
nohairs <- 8  # number of hairs in the array
plotit <- 0  # plot the hairs? yes = 1, no = 0
startrun <- 1
endrun <- 1
parameter_set <- 165

#### Defines functions ####

## Creates a circle full of appropriately spaced points
# center = x,y position of center of circle
# radius = radius in m of circle
# dx = distance points should be apart in m
circle <- function(center, radius, dx){
  x_grid <- seq(-(radius + 0.01), radius + 0.01, by = dx)
  y_grid <- seq(-(radius + 0.01), radius + 0.01, by = dx)
  whole_grid <- meshgrid(x_grid, y_grid)
  
  THETA <- c(seq(0, 2 * pi, length = 250), 0)
  RHO <- array(1, length(THETA)) * radius
  Z <- array(1, length(RHO)) * 0
  nap <- matrix(c(THETA, RHO), nrow = length(THETA), ncol = 2)
  points <- pol2cart(RHO, THETA)
  points <- as.data.frame(points)
  
  In <- inpolygon(whole_grid$X, whole_grid$Y, points$x, points$y, boundary = FALSE)
  Xin <- whole_grid$X[In]
  Yin <- whole_grid$Y[In]
  
  X <- Xin + center[1]
  Y <- Yin + center[2]
  circ <- data.frame(X, Y)
  return(circ)
}

## Creates and plots hairs with circle (if plotting is turned on)
# hairxCenterx = x position of center of hair
# hairxCentery = y position of center of hair
# dx = spacing of points inside hair
# no = number for label of hair
# plotit = turns plotting on ==1, turns plotting off ==0
plotahair <- function(hairxCenterx, hairxCentery, hdia, dx, no, plotit){
  h1 <- circle(c(hairxCenterx, hairxCentery), 0.5 * hdia, "dx")
  if(plotit == 1){
    points(hairxCenterx, hairxCentery, pch = 19, cex = 2.5)
    text(hairxCenterx, hairxCentery, labels = no, col = "red")
  }
  return(h1)
}

## Main function to create hairs
## sets other necessary parameters that are internal to the function
## Takes th and GtD from allpara text file and sets these features 
## for each run number. 
# th = theta, angle of hair array relative to x positive axis
# GtD = gap-to-diameter ratio of hairs in the array
# number = simulation number in set
# nohairs = number of hairs in the array
# plotit = turns plotting function on ==1 or off ==0 (default)
makehairs <- function( th, GtD, number, nohairs, plotit = 0){
  
  #### Sets internal parameters ####
  L <- 2.0         # length of computational domain (m)
  N <- 4096        # number of Cartesian grid meshwidths at the finest level of the AMR grid
  np <- 3         # number of points in a domain unit
  dx <- (2.0 * L) / (N * np)  # Cartesian mesh width (m)
  hdia <- 0.002     # Diameter of hair
  adia <- 0.1     # Diameter of flagellum
  th2 <- (th / 180) * pi      # Angle off positive x-axis in radians
  dist <- 2 * hdia     # Distance between antennule and hair 
  mindGap <- (0.5 * adia) + (0.5 * hdia) + dist  # Calculate distance between hair centers
  width <- (GtD * hdia) + hdia
  
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
  ant <- circle(c(0, 0), 0.5 * adia, dx);  # Produces points that define antennule
  aN <- size(ant$X, 2)                   # Records number of points inside antennule
  if(plotit == 1){ 
    plot(0, 0, xlim = c(-0.5, 0.5), ylim = c(-0.5,0.5), pch = 19, cex = 4) #Plots antennule
    text(0, 0, labels = "Ant", col = "red")
  }
  # Each hair
  for (i in 1:nohairs){
    hairx <- eval(as.name(paste("hair", i, "Centerx", sep = "")))
    hairy <- eval(as.name(paste("hair", i, "Centery", sep = "")))
    h <- plotahair(hairx, hairy, hdia, dx, i, plotit)
    assign(paste("h", i, sep = ""), h)
  }
  hN <- size(h$X, 2)
  disp(paste("Array number: ", number, ", number of points per hair: ", hN, sep = ""))
  
  #### Write points to vertex file ####
  totalN <- aN + nohairs * hN  # Calculates total number of points (first line of vertex file)
  
  filename <- paste("hairs", number, ".vertex", sep = "")   # Defines file name
  if(file.exists(filename)) file.remove(filename)  # Deletes file with that name if it exists
  cat(as.character(totalN), sep = "\n", file = filename, append = FALSE)
  # Writes antennule points
  write.table(ant,file=filename, sep=" ", append=TRUE, col.names = FALSE, row.names = FALSE, quote=FALSE)
  # Writes hair points
  for (k in 1:nohairs){
    hair <- eval(as.name(paste("h", k, sep = "")))
    write.table(hair, file = filename, sep = " ", append = TRUE, 
                col.names = FALSE, row.names = FALSE, quote = FALSE)
  }
  
  #### Creating CSV file with hair center (x,y) positions ####
  allhairs <- data.frame("a" = c(aN, 0, 0))
  names(allhairs) <- "a"
  for (i in 1:nohairs){
    hairx <- eval(as.name(paste("hair", i, "Centerx", sep = "")))
    hairy <- eval(as.name(paste("hair", i, "Centery", sep = "")))
    allhairs <- cbind(allhairs, "h" = c(hN, hairx, hairy))
  }
  write.csv(allhairs, file = paste("hairs", number, ".csv", sep = ""), row.names = FALSE)
  
} # Ends makehair function

##### Input parameter definitions ####

parameters <- read.table(paste("allpara_",parameter_set,".txt",sep = ""))
names(parameters) <- c("angle", "gap", "Re")

# Produces each vertex and csv file for each simulation in the set 
# starting at startrun and ending at endrun.
for (j in startrun:endrun) makehairs(parameters$angle[j], parameters$gap[j], j, nohairs, plotit)
