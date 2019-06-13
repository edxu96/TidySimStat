% setup file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise6b
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise6b")  % ##############################################################
m = 10;
nSample = 100000;
aCap_1 = 4;
aCap_2 = 4;
[vecX, sState] = simRanWalkMHAlgo(m, nSample, aCap_1, aCap_2);
%
vecResult = zeros(m, 1);
for j = 1:m
    vecResult(j) = calCount(j, aCap);
end
vecResult = vecResult / sum(vecResult);
%
vecProbClass = plotHist(vecX, [1:1:m], vecResult, m, '3.png');
