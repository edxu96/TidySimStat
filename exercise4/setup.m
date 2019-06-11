% setup file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190611
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise4
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise4")
% ######################################################################################################################

nServer = 10;
nCustomer = 1000;  % 10000;
lambda = 15;
mu = 1;
numSim = 10;
vecResultProb = zeros(numSim, 1);
for i = 1:numSim
    [ vecResultProb(i) ] = startSim( nServer, nCustomer, lambda, mu );
end
mean(vecResultProb)
[ bCap ] = calErlangsFormula( lambda, mu, nServer )

% gamrnd(nServer, 1 / nServer)
