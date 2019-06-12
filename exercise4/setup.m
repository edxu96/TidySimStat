% setup file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190611
% Version: 3.1
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise4
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise4")
% 1,  Define Basic Parameters ##########################################################################################
nServer = 10;
nCustomer = 100000;
numSim = 10;
clockSimZero = 0;
% 2,  Define Functions for Length of Arrival Interval and Serve Time ###################################################
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
% 3,  Begin `numSim`-Times Simulations #################################################################################
tic
nEvent = nCustomer;
vecResultProb = zeros(numSim, 1);
vecY = zeros(numSim, 1);
for i = 1:numSim
    [vecResultProb(i), sState] = simDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, ...
        vecParaArrive, vecParaServe);
    vecY(i) = mean([sState.intervalArrive]);
end
toc
% 4,  Compare the Mean Value from Simualtions and Analytical Value #####################################################
fprintf("Simulation: mean(b) = %f.\n", mean(vecResultProb));
fprintf("Simulation: var(b) = %f.\n", var(vecResultProb));
[boundLower, boundUpper] = calConfInterval(vecResultProb);
fprintf("Simulation: lowerConfiInterval(b) = %f.\n", boundLower);
fprintf("Simulation: upperConfiInterval(b) = %f.\n", boundUpper);
[bCap] = calErlangsFormula(lambda, mu, nServer);
fprintf("Analysis: prob that the customer gets blocked = %f.\n", bCap);
% 5,  Control Variate #####################################################
expectY = mu;
vecX = vecResultProb;
vecZ = zeros(numSim, 1);
covXY = cov(vecX, vecY);
varXY = covXY(1, 2);
c = - varXY / var(vecY);
for i = 1:numSim
    vecZ(i) = vecX(i) + c * (vecY(i) - expectY);
end
fprintf("Control Variate: mean(vecZ) = %f.\n", mean(vecZ));
fprintf("Control Variate: var(vecZ) = %f.\n", var(vecZ));
[boundLower, boundUpper] = calConfInterval(vecZ);
fprintf("Control Variate: lowerConfiInterval(vecZ) = %f.\n", boundLower);
fprintf("Control Variate: upperConfiInterval(vecZ) = %f.\n", boundUpper);
