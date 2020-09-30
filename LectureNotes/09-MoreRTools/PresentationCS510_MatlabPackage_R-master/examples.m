%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THIS FILE INSTANTIATES USES OF THE MATLAB PACKAGE FOR R IN MATLAB%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ceil()
% FUNCTION: this function will round up to the nearest integer
ceil(3.14159)

%% floor()
% FUNCTION: this function will round down to the nearest integer
floor(3.14159)

%% zeros(), ones() and eye()
% FUNCTION: this function will generate 0,1 and identity matrices

  % squared 3x3 zero matrix
  zero(3)
  % 4x4 identity matrix
  eye(4)
  % 2x3 one matrix
  ones(2,3)

%% hilb(), magic()
% FUNCTION: constructs a squared hilbert matrix or a squared magic matrix
  
  % constructs a 3x3 hilbert matrix
  hilb(3)
  % constructs a 3x3 magic matrix
  magic(4)

%% factor() [factors() in R matlab package]
% FUNCTION: this function will factorise an integer into primes
factors(71400)

%% fileparts()
% FUNCTION: parses a path into path, filename and file extension
fileparts("/home/user/me/file.txt")

%% fullfile()
% FUNCTION: constructs a path string from components
fullfile("","home","user","me","file.txt")

%% find()
% FUNCTION: finds and returns position of either elements conforming to a specified logical expression or, if none specified, to non-zero elements

  % returns the positions of elements 1 and 4
  find(c(0,0,1,0,4))
  % returns the positions of elements greater than 3
  find(c(0,0,1,0,4)>3)
  
%% fliplr(), flipud() and rot90
% FUNCTION: flips matrices either left/right (lr) or upside/down (ud)

  % flips magic(3) left/right
  fliplr(magic(3))
  % flips magic(3) upside/down
  flipud(magic(3))
  % rotates magic(3) by 90 degrees to the left
  rot90(magic(3))

%% isempty(), isprime()
% FUNCTION: verifies if an object is: empty, prime
  
  % check if [1,] has at least one empty element
  isempty(array(NA,c(1,0)))
  % check if 17 is a prime number
  isprime(17)

%% linspace(a,b,c), logspace(a,b,c)
% FUNCTION: returns a vector of c items ranging from a to b, linearly or logarithmically spaced
linspace(4,85,3)

%% mod(a,b) and rem(a,b)
% FUNCTION: provides modulus and remainder after division of a by b
mod(43,3)

%% ndims(), numel(), size()
% FUNCTION: provides the number of dimensions, elements or size
  
  % the number of dimensions of 3x3 matrix (i.e. 2)  
  ndims(magic(3))
  % the number of elements of 3x3 matrix (i.e. 9)
  numel(magic(3))
  % the size of a 3x3 matrix (i.e. 3 by 3)
  size(magic(3))

%% nextpow2()
% FUNCTION: provides the smallest power of 2 s.t. 2^(nextpow2(n))>n
nextpow2(31)

%% primes()
% FUNCTION: generates a list all smaller primes
primes(5)

%% reshape(a,b)
% FUNCTION: reshapes matrix a into the dimensions of b
reshape(magic(4),2,8)

%% tic() and toc()
% FUNCTION: tic() and toc() will display the timelapse between their two iterations
tic()
toc()