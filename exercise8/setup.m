% setup file for exercise 7
% Author: Edward J. Xu, Sanaz
% Date: 190614
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise8
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise8")  % ###############################################################
beta = 1;
k = 1.05;
n = 200;
vecU = rand(200);
vecX = simDistPareto(vecU, beta, k);
