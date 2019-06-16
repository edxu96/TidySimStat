% function file for exercise 7
% Author: Edward J. Xu, Sanaz
% Date: 190614
% ######################################################################################################################


function [vecResult, sState] = doExercise_7(nSample, startPosition, tempMax, coefDecay)
    fprintf('#### Begin #####################################################################');  % ####################
    matCost = getMatCost();
    [m, ~] = size(matCost);
    tic
    [sState] = simAnnealing(startPosition, m, nSample, matCost, tempMax, coefDecay);
    toc
    % Print the Simulation Result
    costResult = sState(end).obj;
    vecResult = sState(end).x;
    costSave = sState(1).obj - sState(end).obj;
    ratioAccept = sum([sState.accept]) / nSample;
    fprintf('costResult = %f.\n', costResult);
    fprintf('costSave = %f.\n', costSave);
    fprintf('ratioAccept = %f.\n', ratioAccept);
    % Plot the Simulation Result
    vecXx = 1:nSample;
    matYy = zeros(nSample, 2);
    matYy(:, 1) = [sState.obj];
    matYy(:, 2) = [sState.temp] * 100;
    plotLine(vecXx, matYy, '7/1', 'Simulated Annealing Temperature and Energy');
    fprintf('#### End #######################################################################');  % ####################
end
