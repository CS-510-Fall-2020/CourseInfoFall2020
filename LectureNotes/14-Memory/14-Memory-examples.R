#### Example of indexing using different methods ####
library(microbenchmark)

data(mtcars)
force(mtcars)

microbenchmark(
  "[,11]"=mtcars[,11],
  "$carb"=mtcars$carb,
  "[[c(11)]]"=mtcars[[c(11)]],
  "[[11]][32]"=mtcars[[11]][32],
  ".subset2"=.subset2(mtcars,11)[32]
)

rm(mtcars)

#### Checking memory with the pryr package ####
# Please restart R before running for a clean workspace.
#install.packages("pryr",dependencies = TRUE)
library(pryr)

mem_used() # Check current memory usage

# Bind x to new vector of 1 million pseudorandom numbers.
x<-runif(1:1e6) # Create a vector 
object.size(x)  # Check size of x using utilities
object_size(x)  # Check size of x using pryr 
address(x)      # Check address of x
mem_used()      # Checks memory usage to this point.

# Bind x to a new object y
y<-list(x,x,x)
object_size(y) # Why is y the same size as x?
object.size(y) # Utilities reports the "correct" size...
mem_used()     # ... but is not reflective of the actual memory usage!

# Change a single element of x
x[20]<-140     # Replaces the 20th position of x with 140
object_size(x) # Does not change the size of x,
address(x)     # but the address has now changed! 
object_size(y) # Size of y has not changed.
address(y)     # Address of y has not, still points to old x.
y[[1]][20]     # Will return not 140, because it is still pointing to the old x.
mem_used()     # Why did changing one element of x increase memory useage by so much?

# Checking how memory changes with pryr
mem_change(z<-runif(1e8)) # Create a large vector of pseudorandom numbers
mem_change(rm(z))         # Remove the large vector
mem_used()                # Check the memory usage

# Garbage collection in R
gc()         # Runs garbage collection, reports use statistics and triggers
gcinfo(TRUE) # Reports whenever gc() runs, equivalent to gc(verbose=TRUE)

# Identifying and dealing with memory leaks: Example 1
mem_change(x <- runif(1e8))   # Create a really big x object
y <- list(x,x,x)  # Create list y based on x
mem_used()        # Check memory usage
mem_change(rm(x))             # Remove x
mem_used()        # Check again - it hasn't reduced in size)
rm(y)
mem_used()

# Identifying and dealing with memory leaks: Example 2
f1 <- function(){   # Simply returns the number 10. Defines x internally.
  x <- 1:1e6        # Creates a 4 MB object
  10
}
mem_change(h<-f1()) # x is released when the function ends, resulting in very little memory change.
object_size(h)

f2 <- function(){   # Defines internally the objects x (vector) and a~b (formula). 
  x <- 1:1e6
  a~b
}
mem_change(y<-f2()) # Defines the formula, which changes the memory a little.
object_size(y)      # But since the function captures the environment, it also captures x. 

f3 <- function(){   # Defines x internally and another nested function which returns 10.
  x <- 1:1e6
  function () 10
}
mem_change(z<-f3()) # Same story as above, defining the internal function changes little,
object_size(z)      # but since the function captures the environment, it also captures x. 

# Identifying and dealing with memory leaks: Example 3
g <- letters[1:26]
alphabet <- g[1]
tracemem(alphabet)
for (i in 2:length(g)){
  alphabet <- c(alphabet, g[i])
  print(object_size(alphabet))
}

# Preallocating space for alphabet and modifying in place prevents the leak.
g <- letters[1:26]
alphabet <- seq(1,26)
tracemem(alphabet)
for (i in 1:length(g)){
  alphabet[i] <- g[i]
  print(object_size(alphabet))
}


