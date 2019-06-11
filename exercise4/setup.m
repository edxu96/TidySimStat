% setup file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190611
% Version: 2.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise4
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise4")
% ######################################################################################################################
nServer = 10;
nCustomer = 10000;  % 10000;
lambda = 15;
mu = 1;
numSim = 10;
vecResultProb = zeros(numSim, 1);
for i = 1:numSim
    [vecResultProb(i)] = startSim(nServer, nCustomer, lambda, mu);
end
fprintf("Simulation: mean(prob that the customer gets blocked) = %f.\n", mean(vecResultProb));
[bCap] = calErlangsFormula(lambda, mu, nServer);
fprintf("Analysis: prob that the customer gets blocked = %f.\n", bCap);
% gamrnd(nServer, 1 / nServer)
