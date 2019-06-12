% setup file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190612
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
fprintf("#### Begin #####################################################################");
[funcArrive, vecParaArrive] = getFunc("expArrive", mu, lambda);
[funcServe, vecParaServe] = getFunc("expServe", mu, lambda);
[bCap] = calErlangsFormula(8, 1, nServer);
fprintf("Analysis: b = %f.\n", bCap);
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
fprintf("Result from Simulation ---------------------------------------------------------");
toc
printResult(vecResultProb);
fprintf("Result from Simulation and Control Variate -------------------------------------");
expectY = 1;
vecX = vecResultProb;
vecZ = zeros(nSim, 1);
covXY = cov(vecX, vecY);
varXY = covXY(1, 2);
c = - varXY / var(vecY);
for i = 1:nSim
    vecZ(i) = vecX(i) + c * (vecY(i) - expectY);
end
printResult(vecZ);
fprintf("#### End #######################################################################");
% 4,  Functions ########################################################################################################
% To define the function for length of arrival interval and serving time.
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
% To print the result.
function [boundLower, boundUpper] = printResult(vecResult)
    fprintf("mean(b) = %f.\n", mean(vecResult));
    fprintf("var(b) = %f.\n", var(vecResult));
    [boundLower, boundUpper] = calConfInterval(vecResult);
    fprintf("lowerConfiInterval(b) = %f.\n", boundLower);
    fprintf("upperConfiInterval(b) = %f.\n", boundUpper);
end
