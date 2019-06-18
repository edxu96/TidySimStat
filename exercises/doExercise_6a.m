% setup file for exercise 5
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################


function doExercise_6a(m, nSample, aCap)
    % --------------------------------------------------------------------------------------
    cellSampleSpace = getSampleSpace(0:1:m);
    funcGetCandidate = @(css, xPre) loopRandWalk(xPre, css{end}, css{1});
    vecPara = aCap;
    funcAcceptCandidate = @accept;
    sState = simMarkovChain(cellSampleSpace, funcGetCandidate, funcAcceptCandidate, nSample, vecPara);
    vecState = [sState.x];
    save([pwd '/outputs/vecState_2.mat'], 'vecState');
    % Calculate the Analytical Values ----------------------------------------------------------------------------------
    vecResult = zeros(m + 1, 1);
    for j = 0:m
        vecResult(j + 1) = calCount(j, aCap);
    end
    vecResult = vecResult / sum(vecResult);
    % Plot the Histogram of the Result ---------------------------------------------------------------------------------
    strTitle = 'Simulation and Analysis Result of Queueing System with 10 Servers and A being 8';
    vecProbClass = plotHist(vecState(1000:end), 0:1:m, vecResult, m + 1, strTitle, '1.png');
    % [prob] = testChiSquare(vecProbClass * nSample, );
end


function [x] = accept(xPre, y, vecPara)
    aCap = vecPara(1);
    if calCount(y, aCap) >= calCount(xPre, aCap)
        x = sState(n).y;
    else
        if rand() < calCount(y, aCap) / calCount(xPre, aCap)
            x = y;
        else
            x = xPred;
        end
    end
end
