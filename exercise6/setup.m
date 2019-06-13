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
% ######################################################################################################################
clear
clc
% ######################################################################################################################
m = 10;
nRow = 6;
nSample = 10000;
aCap_1 = 4;
aCap_2 = 4;
[vecX, sState] = simRanWalkMHAlgo2(m, nRow, nSample, aCap_1, aCap_2);
%
matProb = zeros(m + 1);
for i = 1:(m + 1)
    for j = 1:i
        matProb(i, j) = calCount2(i - 1, j - 1, aCap_1, aCap_2);
    end
end
matProb = matProb / sum(sum(matProb));
plotSurf(matProb, '7');
%
vecX1 = zeros(nSample, 1);
vecX2 = zeros(nSample, 1);
vecX12 = zeros(nSample, 1);
for i = 1:nSample
    vecX1(i) = sState(i).x(1);
    vecX2(i) = sState(i).x(2);
    vecX12(i) = sum(sState(i).x);
end
plotHist2(vecX1, vecX2, '6');
% openfig('images/4.fig')
