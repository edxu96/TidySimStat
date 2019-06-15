% setup file for exercise 7
% Author: Edward J. Xu, Sanaz
% Date: 190614
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim/exercise7
% pwd
addpath("~/Documents/GitHub/StochasticSim/exercise7")  % ###############################################################
function [costSave] = doExercise_7(nSample)
    matCost = getMatCost();
    [m, n] = size(matCost);
    startPosition = 1;
    [sState] = simAnealing(startPosition, m, nSample, matCost);
    % Result
    costSave = calEnergy(sState(1).x, matCost) - calEnergy(sState(end).x, matCost);
    ratioAccept = sum([sState.accept]) / nSample;
end
