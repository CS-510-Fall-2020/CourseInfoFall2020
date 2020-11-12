library(ggplot2)

ggplot(mtcars, aes(x=mpg,y=hp,col=cyl)) +         # Defining data and aesthetic mapping
  geom_point() +                                  # Defining geometric object
  xlab("Miles per gallon") + ylab("Horsepower") + # Guides: labeling axes
  xlim(0,40) + ylim(0,350) +                      # Scales: setting x and y limits
  labs(color="Cylinders")                         # Guides: setting title of legend

PlantGrowth<-PlantGrowth
head(PlantGrowth)

# Data: long versus wide format
Loblolly<-Loblolly # Original data set is in long format

library(reshape2)
Loblolly.wide<-dcast(Loblolly,Seed~age,value.var="height") # Reshape to wide format
Loblolly.long<-melt(Loblolly.wide) # Reshape back to long format

# Mapping: Changing aesthetic attributes

ggplot(mtcars, aes(x = mpg, y = hp, color = as.factor(cyl))) + geom_point()    # Maps correctly 
ggplot(mtcars, aes(x = mpg, y = hp)) + geom_point(color = cyl)      # Maps incorrectly 
ggplot(mtcars, aes(x = mpg, y = hp)) + geom_point(aes(color = cyl)) # Maps correctly

# Store in p:
p <- ggplot(mtcars, aes(x=mpg,y=hp)) #Note: it will not plot for you if you assign it to a variable

p + geom_point(color="red") # Color points red
p + geom_point(color="red",size = 4) # Make points four times normal size
p + geom_point(color="red", shape=21) # Changes to shape pch = 21
p + geom_point(color="red",alpha=0.5) # Sets transparency to 50%

# Geoms: Applying different geometric objects 
ggplot(PlantGrowth, aes(x=group,y=weight)) + geom_boxplot() # box plot
ggplot(PlantGrowth, aes(x=group,y=weight)) + geom_violin()  # violin plot

# Scales: changing scales 
faithfuld <- faithfuld
p2 <- ggplot(faithfuld, aes(x = eruptions, y = waiting)) + 
  geom_raster(aes(fill = density), interpolate = T)
library(viridis) # The Viridis package
p2 + scale_fill_viridis(option="A") #Options are A-E

library(RColorBrewer) # The R Color Brewer package
p2 + scale_fill_distiller(palette = "OrRd") 
# Use scale_fill_distiller() for conitnuous scales and scale_fill_brewer() for discrete scales

# Guides: changing labels and legends

# Set custom breaks and labels
p + geom_point(aes(color = cyl, size=hp)) + 
  scale_x_continuous(breaks=c(10, 20, 30), labels=c("OK", "Good", "Great!")) + 
  scale_y_continuous(breaks=c(100, 200, 300), labels=c("Whimpy", "Meh", "Powerful!"))

# Remove a legend
p + geom_point(aes(color = cyl)) + guides(color=FALSE)
p + geom_point(aes(color = cyl)) + theme(legend.position = "none")

# Change legend position: top
p + geom_point(aes(color = cyl)) + labs(color="Cylinders") + theme(legend.position = "top") 

# For more advanced changes to plots, see theme().

# For a cleaner plot area:
p + geom_point(aes(color = cyl)) + theme_bw()

