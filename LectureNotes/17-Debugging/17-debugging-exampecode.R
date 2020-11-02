# Some debugging example code

#### Interactive Debugging ####
# Trying RStudio's debugger
x <- function(a) y(b)
y <- function(b) z(c)
z <- function(c) w(d)
w <- function(d) "a" + d

x(10)
traceback()

# Source the post-refactored code from 12-Refactor/Refactoring_example folder. 
# Be sure to reset your working directory!
options(error = recover)

#### Non-interactive debugging ####

# Dump and quite with dump.frames in batch code. Put this in your batch code!
dump_and_quit <- function() {
  # Save debugging info to file las.dump.rda
  dump.frames(to.file = TRUE)
  # Quits R with error status
  q(status = 1)
}
options(error = dump_and_quit)

# When it fails, it will write to the file "last.dump.rda", which you can then look at:
load("last.dump.rda")
debugger()

#### Exception Handling ####

# try() example
f1 <- function(x) {
  try(log(x))
  10
}
f1("a")

# try() as a longer example:
try({
  a <- 1
  b <- "x"
  a + b
})

# try() as capturing a class state:
success <- try(1 + 2)
failure <- try("a" + "b")
class(success)
class(failure)

# try() with error suppression
blerp <- function(x) x + 1
blerp("a")
try(blerp("a"), silent = TRUE)

# tryCatch() example: 
show_condition <- function(code) {
  tryCatch(code, 
           error = function(c) "error",
           warning = function(c) "warning",
           message = function(c) "message"
	)
}
show_condition(stop("!"))
show_condition(warning("?!"))
show_condition(message("?"))

