% setup file for exercise 7
% Author: Edward J. Xu, Sanaz
% Date: 190614
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise7
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise7")  % ###############################################################
matCost = getMatCost();
m = size(matCost);
[sState] = simAnealing(startPosition, m, nSample, matCost)
