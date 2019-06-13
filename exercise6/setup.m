% setup file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise6
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise6")  % ###############################################################
m = 100;
lambda = 8;
mu = 1;
aCap = lambda / mu;
[matTransi] = getTransiMatrix(m - 1, lambda, mu);
[vecX, sState] = simHastMetroAlgo(m, aCap, matTransi);
