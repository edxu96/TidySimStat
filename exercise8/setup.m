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
seedObs = 99;
vecSeedBootstrap = [1:nSet];
vecPara = [beta, k];
fprintf("#### 1, Generate Observations ##################################################\n")
funcSimDist = @simDistPareto;
vecXx = simDist(nObs, seedObs, funcSimDist, vecPara);
fprintf("#### 2, Bootstrap Data Sets ####################################################\n")
% sample from observations set with replacement
matBootstrap = zeros(nSet, nObs);
for i = 1:nSet
    rng(vecSeedBootstrap(i));
    indexBootstrap = randi(nObs, nObs, 1);
    matBootstrap(i, :) = vecXx(indexBootstrap);
end
clear indexBootstrap
fprintf("#### 3, Analyze the Result #####################################################\n")
vecMedian = median(matBootstrap');
vecExpect = mean(matBootstrap');
vecVar = var(matBootstrap');
fprintf("mean(vecMedian) = %f, var(vecMedian) = %f.\n", mean(vecMedian), var(vecMedian))
fprintf("mean(vecExpect) = %f, var(vecExpect) = %f.\n", mean(vecExpect), var(vecExpect))
fprintf("mean(vecVar) = %f, var(vecVar) = %f.\n", mean(vecVar), var(vecVar))
expectCal = beta * k / (k - 1);
varCal = beta^2 * k / (k - 1)^2 / (k - 2);
fprintf("Theoretically, mean = %f, var = %f.\n", expectCal, varCal)
fprintf("#### End #######################################################################\n")
