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
nCustomer = 11000;
nSim = 100;
nStable = 1000;  % nCustomer * 0.01;
clockSimZero = 0;
mu = 1;
lambda = 8;
% 2,  Define Functions for Length of Arrival Intervals and Serving Time ################################################
[funcArrive, vecParaArrive] = getFunc("expArrive", mu, lambda);
[funcServe, vecParaServe] = getFunc("expServe", mu, lambda);
% 3,  Begin `nSim`-Times Simulations ###################################################################################
tic
nEvent = nCustomer;
vecResultProbRaw = zeros(nSim, 1);
vecResultProb = zeros(nSim, 1);
vecY = zeros(nSim, 1);
for i = 1:nSim
    [vecResultProbRaw(i), sState] = simDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, ...
        vecParaArrive, vecParaServe);
    vecResultProb(i) = (sState(nEvent).nCustomerBlock - sState(nStable).nCustomerBlock) / (nEvent - nStable);
    vecY(i) = mean([sState.intervalArrive]);
end
toc
% 4,  Compare the Mean Value from Simualtions and Analytical Value #####################################################
fprintf("Simulation: mean(b) = %f.\n", mean(vecResultProb));
fprintf("Simulation: var(b) = %f.\n", var(vecResultProb));
[boundLower, boundUpper] = calConfInterval(vecResultProb);
fprintf("Simulation: lowerConfiInterval(b) = %f.\n", boundLower);
fprintf("Simulation: upperConfiInterval(b) = %f.\n", boundUpper);
[bCap] = calErlangsFormula(8, 1, nServer);
fprintf("Analysis: b = %f.\n", bCap);
% 5,  Control Variate ##################################################################################################
expectY = 1;
vecX = vecResultProb;
vecZ = zeros(nSim, 1);
covXY = cov(vecX, vecY);
varXY = covXY(1, 2);
c = - varXY / var(vecY);
for i = 1:nSim
    vecZ(i) = vecX(i) + c * (vecY(i) - expectY);
end
fprintf("Control Variate: mean(vecZ) = %f.\n", mean(vecZ));
fprintf("Control Variate: var(vecZ) = %f.\n", var(vecZ));
[boundLower, boundUpper] = calConfInterval(vecZ);
fprintf("Control Variate: lowerConfiInterval(vecZ) = %f.\n", boundLower);
fprintf("Control Variate: upperConfiInterval(vecZ) = %f.\n", boundUpper);
% 6,  Functions ########################################################################################################
function [func, vecPara] = getFunc(whiFunc, mu, lambda)
    if whiFunc == "expArrive"
        func = @exprnd;
        vecPara = mu;
    elseif whiFunc == "expServe"
        func = @exprnd;
        vecPara = lambda;
    elseif  whiFunc == "cons"
        cons = 10;
        func = @(cons) cons;
        vecPara = cons;
    end
    fprintf("Func: %s.\n", whiFunc);
end
