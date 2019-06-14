% setup file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise6
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise6")  % ###############################################################
% m = 10;
% nSample = 20000;
% lambda = 8;
% mu = 1;
% aCap = lambda / mu;
% [vecState, sState] = simRandWalkHastingsMetropolis(m, nSample, aCap);
% save([pwd '/outputs/vecState_2.mat'], 'vecState');
% % Calculate the Analytical Values --------------------------------------------------------------------------------------
% vecResult = zeros(m + 1, 1);
% for j = 0:m
%     vecResult(j + 1) = calCount(j, aCap);
% end
% vecResult = vecResult / sum(vecResult);
% % Plot the Histogram of the Result -------------------------------------------------------------------------------------
% vecProbClass = plotHist(vecState(1000:end), [0:1:m], vecResult, m + 1, '3.png');
% ######################################################################################################################
clear
clc
% ######################################################################################################################
m = 10;
nRow = 6;
nSample = 10000;
aCap_1 = 4;
aCap_2 = 4;
[sState2] = simRandWalkHastingsMetropolis2(m, nRow, nSample, aCap_1, aCap_2);
save([pwd '/outputs/sState2_2.mat'], 'sState2');
% Plot the Analytical Values
matProb = zeros(m + 1);
for i = 1:(m + 1)
    for j = 1:i
        matProb(i, j) = calCount2(i - 1, j - 1, aCap_1, aCap_2);
    end
end
matProb = matProb / sum(sum(matProb));
plotSurf(matProb, '8', m);
% Plot 3-D Histogram of the Result
vecX1 = zeros(nSample, 1);
vecX2 = zeros(nSample, 1);
vecX12 = zeros(nSample, 1);
for i = 1:nSample
    vecX1(i) = sState2(i).x(1);
    vecX2(i) = sState2(i).x(2);
    vecX12(i) = sum(sState2(i).x);
end
plotHist2(vecX1, vecX2, '9');
% openfig('images/4.fig')
