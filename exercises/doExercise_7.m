% function file for exercise 7
% Author: Edward J. Xu, Sanaz
% Date: 190614
% ######################################################################################################################


function [vecResult, sState] = doExercise_7(nSample, startPosition)
    fprintf('#### Begin #####################################################################');  % ####################
    matCost = getMatCost();
    [m, ~] = size(matCost);
    tic
    [sState] = simAnnealing(startPosition, m, nSample, matCost);
    toc
    % Result
    costResult = calEnergy(sState(end).x, matCost);
    vecResult = sState(end).x;
    costSave = calEnergy(sState(1).x, matCost) - calEnergy(sState(end).x, matCost);
    ratioAccept = sum([sState.accept]) / nSample;
    fprintf('costResult = %f.\n', costResult);
    fprintf('costSave = %f.\n', costSave);
    fprintf('ratioAccept = %f.\n', ratioAccept);
    fprintf('#### End #######################################################################');  % ####################
end
