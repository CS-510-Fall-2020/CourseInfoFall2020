# Quick example from RStudio's article: 
# https://support.rstudio.com/hc/en-us/articles/218221837-Profiling-with-RStudio

library(profvis)

#### Run these lines first #####
times <- 4e5
cols <- 150
data <-
  as.data.frame(x = matrix(rnorm(times * cols, mean = 5),
                           ncol = cols))
data <- cbind(id = paste0("g", seq_len(times)), data)

#### First Profiling example #####
profvis({
  # Store in another variable for this run
  data1 <- data
  
  # Get column means
  means <- apply(data1[, names(data1) != "id"], 2, mean)
  
  # Subtract mean from each column
  for (i in seq_along(means)) {
    data1[, names(data1) != "id"][, i] <-
      data1[, names(data1) != "id"][, i] - means[i]
  }
})

#### Second profiling example ####
profvis({
  data1 <- data
  # Four different ways of getting column means
  means <- apply(data1[, names(data1) != "id"], 2, mean)
  means <- colMeans(data1[, names(data1) != "id"])
  means <- lapply(data1[, names(data1) != "id"], mean)
  means <- vapply(data1[, names(data1) != "id"], mean, numeric(1))
})