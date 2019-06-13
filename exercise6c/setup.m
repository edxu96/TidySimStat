% setup file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise6c
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise6c")  % ##############################################################
m = 10;
nSample = 10000;
aCap_1 = 4;
aCap_2 = 4;
[vecX, sState] = simRanWalkMHAlgo(m, nSample, aCap_1, aCap_2);
%
matProb = zeros(m + 1);
for i = 1:(m + 1)
    for j = 1:(m + 1)
        matProb(i, j) = calCount2(i - 1, j - 1, aCap_1, aCap_2);
    end
end
matResult = matResult / sum(matResult);
%
