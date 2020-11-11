# Lattice Examples: from https://www.statmethods.net/advgraphs/trellis.html
library(lattice)
attach(mtcars)

# create factors with value labels
gear.f<-factor(gear,levels=c(3,4,5),
               labels=c("3gears","4gears","5gears"))
cyl.f <-factor(cyl,levels=c(4,6,8),
               labels=c("4cyl","6cyl","8cyl"))

# kernel density plot
densityplot(~mpg,
            main="Density Plot",
            xlab="Miles per Gallon")

# kernel density plots by factor level
densityplot(~mpg|cyl.f,
            main="Density Plot by Number of Cylinders",
            xlab="Miles per Gallon")

# kernel density plots by factor level (alternate layout)
densityplot(~mpg|cyl.f,
            main="Density Plot by Numer of Cylinders",
            xlab="Miles per Gallon",
            layout=c(1,3))

# boxplots for each combination of two factors
bwplot(cyl.f~mpg|gear.f,
       ylab="Cylinders", xlab="Miles per Gallon",
       main="Mileage by Cylinders and Gears",
       layout=c(1,3)
      )
       
       
# scatterplots for each combination of two factors
xyplot(mpg~wt|cyl.f*gear.f,
     main="Scatterplots by Cylinders and Gears",
     ylab="Miles per Gallon", xlab="Car Weight")
       
# 3d scatterplot by factor level
cloud(mpg~wt*qsec|cyl.f,
     main="3D Scatterplot by Cylinders")
       
# dotplot for each combination of two factors
dotplot(cyl.f~mpg|gear.f,
       main="Dotplot Plot by Number of Gears and Cylinders",
         xlab="Miles Per Gallon")
       
# scatterplot matrix
splom(mtcars[c(1,3,4,5,6)],
     main="MTCARS Data")