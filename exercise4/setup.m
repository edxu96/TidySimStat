% setup file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190611
% Version: 3.1
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise4
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise4")
% ######################################################################################################################
% 1,  Define Basic Parameters
nServer = 10;
nCustomer = 10000;
numSim = 10;
clockSimZero = 0;
% 2,  Define Functions for Length of Arrival Interval and Serve Time
whiFuncArrive = "exp";
fprintf("Func for Length Arrival Interval: %s.\n", whiFuncArrive);
whiFuncServe = "exp";
fprintf("Func for Serve Time: %s.\n", whiFuncServe);
if whiFuncArrive == "exp"
    mu = 1;
    funcArrive = @exprnd;
    vecParaArrive = mu;
elseif  whiFuncArrive == "cons"
    cons = 10;
    funcArrive = @(cons) cons;
    vecParaArrive = cons;
end
% gamrnd(nServer, 1 / nServer);
if whiFuncServe == "exp"
    lambda = 8;
    funcServe = @exprnd;
    vecParaServe = lambda;
elseif  whiFuncServe == "cons"
    cons = 10;
    funcServe = @(cons) cons;
    vecParaServe = cons;
end
% 3,  Begin `numSim`-Times Simulations
tic
nEvent = nCustomer;
vecResultProb = zeros(numSim, 1);
for i = 1:numSim
    [vecResultProb(i)] = simDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, vecParaArrive, ...
        vecParaServe);
end
% 4,  Compare the Mean Value from Simualtions and Analytical Value
fprintf("Simulation: mean(prob that the customer gets blocked) = %f.\n", mean(vecResultProb));
fprintf("Simulation: var(prob that the customer gets blocked) = %f.\n", var(vecResultProb));
toc
[bCap] = calErlangsFormula(lambda, mu, nServer);
fprintf("Analysis: prob that the customer gets blocked = %f.\n", bCap);
% ######################################################################################################################
