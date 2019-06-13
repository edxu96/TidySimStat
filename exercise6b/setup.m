% setup file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise6b
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise6b")  % ##############################################################
m = 10;
nSample = 10000;
lambda = 8;
mu = 1;
aCap = lambda / mu;
[vecX, sState] = simRanWalkMHAlgo(m, nSample, aCap);
%
vecResult = zeros(m + 1, 1);
for j = 0:m
    vecResult(j + 1) = calCount(j, aCap);
end
vecResult = vecResult / sum(vecResult);
%
vecProbClass = plotHist(vecX, [1:1:m], vecResult, m, '3.png');
