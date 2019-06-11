% setup file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190611
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise4
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise4")
% ######################################################################################################################

nServer = 10;
nCustomer = 10000;
lambda = 8;
mu = 1;
[ b, nCustomerBlock, vecNumCustomerServe ] = startSim( nServer, nCustomer, lambda, mu )
