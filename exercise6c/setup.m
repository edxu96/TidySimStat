% setup file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise6c
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise6c")  % ##############################################################
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
plotSurf(matProb);
%
vecX1 = zeros(nSample, 1);
vecX2 = zeros(nSample, 1);
vecX12 = zeros(nSample, 1);
for i = 1:nSample
    vecX1(i) = sState(i).x(1);
    vecX2(i) = sState(i).x(2);
    vecX12(i) = sum(sState(i).x);
end
plotHist2(vecX1, vecX2);
% openfig('images/4.fig')
