require(MonteCarlo)

#Define integrand
f <- function(x)(sin((sin(5*x^5+3*x^3-12*x)*cos(x^9+3*x)/(x^2+1))^2))

#Define integral function
integral <- function(upper,lower){
  dist = runif(upper,lower)
  x = sample(dist,1)
  y=x
  #returns 1 if tested location is under curve
  decision = y<=f(x) 
  return(list("decision"=decision))
}

#upper and lower bounds
upper_vec <- c(1)
lower_vec <-c(0)

#vectorize inputs
p_list <- list("upper"=upper_vec,"lower"=lower_vec)

#run MonteCarlo
erg = MonteCarlo(func=integral,nrep=50000,param_list=p_list,ncpus=1)
df = MakeFrame(erg)

#find proportion of points under curve
solution = length(df$decision[df$decision==1])/50000
#Since the range of all possible tested x and y has an area of 1, the proportion is our
#sought solution
solution