% setup file for exercise 5
% Author: Edward J. Xu, Sanaz
% Date: 190612
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise5
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise5")
% ######################################################################################################################
whiFunc = "antithetic";
fprintf("Method: %s.\n", whiFunc);
if whiFunc == "exp"
    funcSim = @exp;
elseif whiFunc == "antithetic"
    funcSim = @(u) (exp(u) + exp(1-u)) / 2;
end
nSim = 100;
nSample = 100;
vecResultBar = zeros(nSim, 1);
for i = 1:nSim
    [vecResultBar(i)] = simIntegral(nSample, funcSim);
end
fprintf("Mean = %f.\n", mean(vecResultBar));
fprintf("Var = %f.\n", var(vecResultBar));
