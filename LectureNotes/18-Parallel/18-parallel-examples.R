#### Parallel computing examples ####
# Note: things are different between Mac/Linux and Windows computers. Be sure to run the correct
# code blocks for your platform!

#### Mac/Linux example using lapply ####
# Example from Wickham's Advanced R book, Optimization chapter: http://adv-r.had.co.nz/Profiling.html#parallelise

library(parallel)  # parallel package is part of base R, no need to install!

cores <- detectCores()
cores

pause <- function(i) {
  function(x) Sys.sleep(i)
}

system.time(
  lapply(1:8, pause(0.25))
)

system.time(
  mclapply(1:8, pause(0.25))
)

#### Windows example ####
# Example also from Wickham

library(parallel)

cores <- detectCores()
cores
cluster <- makePSOCKcluster(cores)

pause <- function(i) {
  function(x) Sys.sleep(i)
}

system.time(
  lapply(1:10, pause(0.25))
)

system.time(
  parLapply(cluster, 1:10, pause(0.25))
)

#### The foreach package ####
# foreach works independently of platform
# From foreach vignette: https://cran.r-project.org/web/packages/foreach/vignettes/foreach.html
library(foreach)
library(microbenchmark)
library(doParallel)

registerDoParallel(cores=4)

x <- foreach(i=1:3) %do% sqrt(i)
x

microbenchmark(
  foreach(i=1:30) %do% sqrt(i),
  foreach(i=1:30) %dopar% sqrt(i)
)

microbenchmark(
  foreach(i=1:3000) %do% sqrt(i),
  foreach(i=1:3000) %dopar% sqrt(i)
)


foreach(i=4:1, .combine='c') %do% {
  Sys.sleep(3 * i)
  i
}

foreach(i=4:1, .combine='c') %dopar% {
  Sys.sleep(3 * i)
  i
}