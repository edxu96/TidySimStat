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
nCustomer = 10000;
nSim = 100;
clockSimZero = 0;
% 2,  Define Functions for Length of Arrival Intervals and Serving Time ################################################
[funcArrive, vecParaArrive] = getFunc("expArrive");
[funcServe, vecParaServe] = getFunc("expServe");
% 3,  Begin `nSim`-Times Simulations ###################################################################################
tic
nEvent = nCustomer;
vecResultProb = zeros(nSim, 1);
vecY = zeros(nSim, 1);
for i = 1:nSim
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
% 5,  Control Variate ##################################################################################################
expectY = mu;
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
function [func, vecPara] = getFunc(whiFunc)
    if whiFunc == "expArrive"
        mu = 1;
        func = @exprnd;
        vecPara = mu;
    elseif whiFunc == "expServe"
        lambda = 8;
        func = @exprnd;
        vecPara = lambda;
    elseif  whiFunc == "cons"
        cons = 10;
        func = @(cons) cons;
        vecPara = cons;
    end
    fprintf("Func: %s.\n", whiFunc);
end
