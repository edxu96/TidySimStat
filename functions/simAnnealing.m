% Simulated Annealing to Optimize in Sample Space
% Author: Edward J. Xu
% Date: 190614
% ######################################################################################################################


function [sState] = simAnnealing(startPosition, m, nSample, matCost)
    cellArraySSpace = getCellArraySampleSpaceAnnealing(m, startPosition);
    % Generate a Permutation Randomly
    vecXx = zeros(m + 1, 1);
    vecXx(1) = startPosition;
    vecXx(m + 1) = startPosition;
    vecPerm = randperm(m);
    vecXx(2:m) = vecPerm(vecPerm ~= startPosition);
    sState(1:nSample) = struct('x', zeros(m + 1, 1), 'y', zeros(m + 1, 1), 'z', zeros(2, 1));
    sState(1).x = vecXx;
    sState(1).y = vecXx;
    sState(1).z = cellArraySSpace{randi(length(cellArraySSpace))};
    % Start Anealing
    for n = 2:nSample
        sState(n).z = loopRandWalk2dim(cellArraySSpace, sState(n - 1).z);
        sState(n).y = sState(n - 1).y;
        sState(n).y(sState(n).z(1)) = sState(n - 1).y(sState(n).z(2));
        sState(n).y(sState(n).z(2)) = sState(n - 1).y(sState(n).z(1));
        % Accept the candidate state or not.
        [sState(n).x, sState(n).accept] = acceptCandidate(sState(n - 1).x, sState(n).y, n, matCost);
    end
end


function [x, accept] = acceptCandidate(xPre, y, k, matCost)
    if calEnergy(y, matCost) < calEnergy(xPre, matCost)
        x = y;
        accept = 1;
    else
        if rand() < exp(getCountAnnealing(y, k, matCost) / getCountAnnealing(xPre, k, matCost))
            x = y;
            accept = 1;
        else
            x = xPre;
            accept = 0;
        end
    end
end


function [cellArraySSpace] = getCellArraySampleSpaceAnnealing(m, startPosition)
    %
    vecPossible = 1:m;
    vecPossible = vecPossible(1:m ~= startPosition);
    % Get the sample space in one dimension
    vecData1 = vecPossible;
    vecData2 = vecPossible;
    n1 = length(vecPossible);
    n2 = length(vecPossible);
    funcLogic = @(data1, data2) data1 ~= data2;  % vecPossible(i) ~= vecPossible(j)
    cellSampleSpace = getSampleSpace2dim(vecData1, vecData2, n1, n2, funcLogic);
    %
    nRow = length(vecPossible);
    cellArraySSpace = getArraySampleSpace(cellSampleSpace, nRow);
end


function [count] = getCountAnnealing(vector, k, matCost)
    temp = calTemp(k);
    energy = calEnergy(vector, matCost);
    count = exp(- energy / temp);
end


function [temp] = calTemp(k)
    temp = 1 / sqrt(1 + k);
end
