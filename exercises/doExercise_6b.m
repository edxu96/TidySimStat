% setup file for exercise 6b
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################


function doExercise_6b()
    m = 10;
    nRow = 6;
    nSample = 100000;
    aCap_1 = 4;
    aCap_2 = 4;
    whiMethod = 1;
    % whiMethod = 2;
    if whiMethod == 1
        vecPara = [aCap_1, aCap_2]
        funcGetCandidate = @loopRandWalk2dim(cellArraySSpace, xPre);
        funcAcceptCandidate = @acceptCandidate(xPre, y, vecPara);
    elseif whiMethod == 2
        vecPara = [aCap_1, aCap_2]
        funcGetCandidate = @sampleGibbs(sState(n - 1).x, m, aCap_1, aCap_2);
        funcAcceptCandidate = @(xPre, y, vecPara) y;
    end
    cellArraySSpace = getCellArraySampleSpace2Dim(m, nRow);
    sState2 = simMarkovChain(cellArraySSpace, funcGetCandidate, funcAcceptCandidate, nSample, vecPara)
    save([pwd '/outputs/sState2_2.mat'], 'sState2');
    % Plot the Analytical Values -------------------------------------------------------------------------------------------
    matProb = zeros(m + 1);
    for i = 0:m
        for j = 0:(m - i)
            matProb(i + 1, j + 1) = calCount2(i, j, aCap_1, aCap_2);
        end
    end
    matProb = matProb / sum(sum(matProb));
    plotStem3([0:m], [0:m], matProb, '3', m);
    % Plot 3-D Histogram of the Result -------------------------------------------------------------------------------------
    vecX1 = zeros(nSample, 1);
    vecX2 = zeros(nSample, 1);
    vecX12 = zeros(nSample, 1);
    for i = 1:nSample
        vecX1(i) = sState2(i).x(1);
        vecX2(i) = sState2(i).x(2);
        vecX12(i) = sum(sState2(i).x);
    end
    plotHist2(vecX1, vecX2, matProb * nSample, m, '4', whiMethod);
end


function [x, accept] = acceptCandidate(xPre, y, vecPara)
    aCap_1 = vecPara(1);
    aCap_2 = vecPara(2);
    if calCount2(y(1), y(2), aCap_1, aCap_2) >= calCount2(xPre(1), xPre(2), aCap_1, aCap_2)
        x = y;
        accept = 1;
    else
        if rand() < (calCount2(y(1), y(2), aCap_1, aCap_2) / calCount2(xPre(1), xPre(2), aCap_1, aCap_2))
            x = y;
            accept = 1;
        else
            x = xPre;
            accept = 0;
        end
    end
end


function [vecCandidate] = sampleGibbs(vecPre, m, vecPara)
    aCap_1 = vecPara(1);
    aCap_2 = vecPara(2);
    vecCandidate = zeros(2, 1);
    % 1,  Draw i-coordinate to change
    i = randi(2);
    j = getOtherOne(i);
    vecCandidate(j) = vecPre(j);  % value j-coordinate remains the same
    % 2,  Define new random variable
    denominator = 0;
    for k = 0:1:(m - vecPre(j))
        denominator = denominator + calCount(k, aCap_1);
    end
    % 3,  Draw new value for j-coordinate from the new random variable
    draw = rand();
    k = 0;
    probCumu = calCount(0, aCap_1) / denominator;
    while ~(draw < probCumu)
        k = k + 1;
        probCumu = probCumu + calCount(k, aCap_1) / denominator;
    end
    if (k + vecCandidate(j)) > m
        error('i + j > m');
    elseif (k + vecCandidate(j)) < 0
        error('i + j < 0');
    end
    % 4,  Change
    vecCandidate(i) = k;
end


function [j] = getOtherOne(i)
    if i == 1
        j = 2;
    elseif i == 2
        j = 1;
    end
end


function [cellArraySSpace] = getCellArraySampleSpace2dim(m, nRow)
    % nRow = 6
    vecData1 = [0:1:m];
    vecData2 = [0:1:m];
    n1 = length(vecData1);
    n2 = length(vecData2);
    funcLogic = @(data1, data2) ((0 <= data1 + data2) & (data1 + data2 <= m));  % (0 <= i + j) & (i + j <= m)
    cellSampleSpace = getCellSampleSpace2dim(vecData1, vecData2, n1, n2, funcLogic);
    cellSampleSpace = getSampleSpace(m);
    [cellArraySSpace] = arrangeSampleSpace2dim(cellSampleSpace, nRow);
end
