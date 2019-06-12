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
nSample = 10000;
% ######################################################################################################################
vecU = rand(nSample, 1);
[funcSim] = getFunc(whiFunc, vecU);
if whiFunc == "stratified"
    tic
    matSample = zeros(nSim, nSample);
    vecSample = zeros(nSim, 1);
    for i = 1:nSim
        matSample(i, :) = rand(nSample, 1);
        vecSample = vecSample + exp((i-1) / nSim + matSample(i, :) / nSim);
    end
    vecSample = vecSample / nSim;
    [resultBar] = sampleFuncSim(nSample, funcSim, vecSample);
    fprintf("result = %f.\n", resultBar);
    toc
else
    tic
    vecResult = sampleFuncSim(nSample, funcSim, vecU);
    expect = mean(vecResult);
    variance = var(vecResult);
    fprintf("mean = %f.\n", expect);
    fprintf("var = %f.\n", variance);
    toc
end
% ######################################################################################################################
%
function [funcSim] = getFunc(whiFunc, vecU)
    fprintf("Method: %s.\n", whiFunc);
    if whiFunc == "exp"
        funcSim = @exp;
    elseif whiFunc == "antithetic"
        funcSim = @(u) (exp(u) + exp(1-u)) / 2;
    elseif whiFunc == "control"
        c = - (mean(vecU .* exp(vecU)) - mean(vecU) * mean(exp(vecU))) / var(vecU);
        funcSim = @(u) exp(u) + c * (u - mean(vecU));
    elseif whiFunc == "stratified"
        funcSim = @(w) w;
    end
end
