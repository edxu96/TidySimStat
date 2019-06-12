% setup file for exercise 5
% Author: Edward J. Xu, Sanaz
% Date: 190612
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise5
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise5")
% ######################################################################################################################
nSample = 100;
funcSim = @exp;
[result] = simIntegral(nSample, funcSim)
