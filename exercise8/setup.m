% setup file for exercise 7
% Author: Edward J. Xu, Sanaz
% Date: 190614
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise8
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise8")  % ###############################################################
beta = 1;
k = 2.05;
nSet = 100;
nObs = 10000;
fprintf("#### 1, Generate Observations ##################################################\n")
vecUcap = rand(nObs);
vecXcap = simDistPareto(vecUcap, beta, k);
fprintf("#### 2, Bootstrap Data Sets ####################################################\n")
% sample from observations set with replacement
matBootstrap = zeros(nSet, nObs);
for i = 1:nSet
    rng(i);
    indexBootstrap = randi(nObs, nObs, 1);
    matBootstrap(i, :) = vecXcap(indexBootstrap);
end
clear indexBootstrap
fprintf("#### 3, Analyze the Result #####################################################\n")
vecMedian = median(matBootstrap');
vecExpect = mean(matBootstrap');
fprintf("mean(vecMedian) = %f, var(vecMedian) = %f.\n", mean(vecMedian), var(vecMedian))
fprintf("mean(vecExpect) = %f, var(vecExpect) = %f.\n", mean(vecExpect), var(vecExpect))
fprintf("#### End #######################################################################\n")
