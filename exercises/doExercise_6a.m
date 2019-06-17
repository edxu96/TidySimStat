% setup file for exercise 5
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################


function doExercise_6a()
    m = 10;
    nSample = 20000;
    lambda = 8;
    mu = 1;
    aCap = lambda / mu;
    % --------------------------------------------------------------------------------------
    cellArraySSpace = getCellArraySampleSpace([0:1:m]);
    vecPara = [aCap];
    funcGetCandidate = @(cass, xPre) loopRandWalk(xPre, m, 0);
    funcAcceptCandidate = @acceptHastingsMetropolis;
    [vecState, sState] = simMarkovChain(cellArraySSpace, funcGetCandidate, funcAcceptCandidate, nSample, vecPara)
    % [vecState, sState] = simRandWalkHastingsMetropolis(m, nSample, aCap);
    save([pwd '/outputs/vecState_2.mat'], 'vecState');
    % Calculate the Analytical Values ----------------------------------------------------------------------------------
    vecResult = zeros(m + 1, 1);
    for j = 0:m
        vecResult(j + 1) = calCount(j, aCap);
    end
    vecResult = vecResult / sum(vecResult);
    % Plot the Histogram of the Result ---------------------------------------------------------------------------------
    strTitle = 'Simulation and Analysis Result of Queueing System with 10 Servers and A being 8';
    vecProbClass = plotHist(vecState(1000:end), [0:1:m], vecResult, m + 1, strTitle, '1.png');
end


function [cellArraySSpace] = getCellArraySampleSpace(vecSampleSpace)
    for i = 1:length(vecSampleSpace)
        cellSampleSpace{end + 1} = {vecSampleSpace(i)};
    end
    cellArraySSpace = cellSampleSpace;  % 1 dimension
end


function [x] = acceptHastingsMetropolis(xPre, y, vecPara)
    aCap = vecPara;
    if calCount(y, aCap) >= calCount(xPre, aCap)
        x = sState(n).y;
    else
        if rand() < calCount(y, aCap) / calCount(xPre, aCap)
            x = y;
        else
            x = xPred;
    end
end
