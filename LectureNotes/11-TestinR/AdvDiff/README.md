# Advection-diffusion simulation 

## About the simulation

This project simulates the advection and diffusion of odor molecules in a 2D space using a Markov-chain Monte Carlo, agent-based model. Odor molecules are simulated as points with a 2D space and stepped forward using the Crank-Nicholson method. Advection is based on fluid velocity vector fields provided by the user. Diffusion is simulated by a random walk the distance of the step being the root-mean squared distance of diffusion (based on the diffusion coefficient, D) in a pseudo-random direction based on a unit circle and an angle selected by R's runif() function.

## Code Inputs

Requires the following inputs: 

 - User set diffusion coefficient, D, on line 11 of simulate_advdiff.R
 - User set time step, delta.t, on line 12 of simulate_advdiff.R.
 - User set end time, end.time, on line 13 of simulate_advdiff.R.
 - User set starting position of all odor molecules (lines 14 and 15 of simulate_advdiff.R).
 - Fluid velocity vector fields (x, y positions, and u, v components of velocity) in the data/ folder.

## Code Outputs

It will return a plot of the starting and ending positions of each odor molecule and write a csv file of these positions in results/.

## To run the simulation

 1. Open the R Project. 
 2. Create a "results/" folder in the top directory. 
 3. Make changes to the inputs as desired. 
 4. source("src/simulate_advdiff.R", chdir = TRUE)
 
