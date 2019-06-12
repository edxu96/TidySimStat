% setup file for exercise 5
% Author: Edward J. Xu, Sanaz
% Date: 190612
% Version: 1.0
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise5
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise5")
% ######################################################################################################################
% whiFunc = "exp";
% whiFunc = "antithetic";
whiFunc = "control";
% whiFunc = "stratified";
fprintf("Method: %s.\n", whiFunc);
if whiFunc == "exp"
    funcSim = @exp;
elseif whiFunc == "antithetic"
    funcSim = @(u) (exp(u) + exp(1-u)) / 2;
elseif whiFunc == "control"
    vecU = rand(10000, 1);
    c = - (mean(vecU .* exp(vecU)) - 0.5 * mean(exp(vecU))) / var(vecU);
    funcSim = @(u) exp(u) + c * (u - 0.5);
elseif whiFunc == "stratified"
    funcSim = @(w) w;
end
nSample = 100;
nSim = 100;
if whiFunc == "stratified"
    tic
    matSample = zeros(nSim, nSample);
    vecSample = zeros(nSim, 1);
    for i = 1:nSim
        matSample(i, :) = rand(nSample, 1);
        vecSample = vecSample + exp((i-1) / nSim + matSample(i, :) / nSim);
    end
    vecSample = vecSample / nSim;
    [resultBar] = simIntegral(nSample, funcSim, vecSample);
    fprintf("result = %f.\n", resultBar);
    toc
else
    tic
    vecResultBar = zeros(nSim, 1);
    for i = 1:nSim
        vecSample = rand(nSample, 1);
        [vecResultBar(i)] = simIntegral(nSample, funcSim, vecSample);
    end
    fprintf("mean = %f.\n", mean(vecResultBar));
    fprintf("var = %f.\n", var(vecResultBar));
    toc
end
