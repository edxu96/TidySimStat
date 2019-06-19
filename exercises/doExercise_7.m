% function file
% Author: Edward J. Xu
% Date: 190619
% ######################################################################################################################


function [vecResult, sState] = doExercise_7(nSample, startPosition, tempMax, coefDecay, strFigName, seedInitial, ...
    coefStretch)
% Simulated Annealing to Optimize the Path in Travelling Salesman Problem
%
% :param tempMax: maximum temperature during annealing
    fprintf('#### Begin #####################################################################');  % ####################
    matCost = getMatCost();
    [m, ~] = size(matCost);
    % 1,  Simulate Annealing
    tic
    sState = simAnnealing(startPosition, m, nSample, matCost, tempMax, coefDecay, seedInitial, coefStretch);
    toc
    % 2,  Print the Simulation Result
    costResult = sState(end).obj;
    vecResult = sState(end).x;
    costSave = sState(1).obj - sState(end).obj;
    ratioAccept = sum([sState.accept]) / nSample;
    fprintf('costResult = %f.\n', costResult);
    fprintf('costSave = %f.\n', costSave);
    fprintf('ratioAccept = %f.\n', ratioAccept);
    fprintf('node = %g.\n', vecResult);
    % 3,  Plot the Simulation Result
    vecXx = 1:nSample;
    matYy = zeros(nSample, 2);
    matYy(:, 1) = [sState.obj];
    matYy(:, 2) = [sState.temp] * 50;
    plotLine(vecXx, matYy, strFigName, 'Simulated Annealing Temperature and Energy');
    fprintf('#### End #######################################################################');  % ####################
end
