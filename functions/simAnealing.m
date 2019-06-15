% function file for exercise 6
% Author: Edward J. Xu
% Date: 190614
% ######################################################################################################################


function [sState] = simAnealing(startPosition, m, nSample, matCost)
    cellArraySSpace = getCellArraySampleSpaceAnnealing(m, startPosition);
    % Generate a Permutation Randomly
    vecXcap = zeros(m + 1, 1);
    vecXcap(1) = startPosition;
    vecXcap(m + 1) = startPosition;
    vecPerm = randperm(m);
    vecXcap(2:m) = vecPerm(vecPerm ~= startPosition);
    sState(1).x = vecXcap;
    sState(1).y = vecXcap;
    sState(1).z = cellArraySSpace{randi(length(cellArraySSpace))};
    % Start Anealing
    for n = 2:nSample
        sState(n).z = randWalk2(cellArraySSpace, sState(n - 1).z);
        sState(n).y = sState(n - 1).y;
        sState(n).y(sState(n).z(1)) = sState(n - 1).y(sState(n).z(2));
        sState(n).y(sState(n).z(2)) = sState(n - 1).y(sState(n).z(1));
        % Accept the candidate state or not.
        [sState(n).x, sState(n).accept] = acceptCandidate(sState(n - 1).x, sState(n).y, n, matCost);
    end
end


function [vecCandidate] = randWalk2(cellArraySSpace, vecPre)
    [m, n] = size(cellArraySSpace);
    % Find where vecPre is
    where = 1;
    while ~isequal(cellArraySSpace{where}, vecPre)
        where = where + 1;
    end
    [x, y] = returnPosition(where, m, n);
    % disp(x)
    % disp(y)
    if cellArraySSpace{x, y} ~= cellArraySSpace{where}
        error("Error when trying to find where the x is.")
    end
    % Random Walk
    x = loopRandWalk(x, m, 1);
    y = loopRandWalk(y, n, 1);
    % disp(x)
    % disp(y)
    vecCandidate = [cellArraySSpace{x, y}];
end


function [x, y] = returnPosition(where, m, n)
    x = mod(where, m);
    y = floor(where / m) + 1;
    if x == 0
        x = m;
        y = y - 1;
    end
end


function [x, accept] = acceptCandidate(xPre, y, k, matCost)
    if calEnergy(y, matCost) < calEnergy(xPre, matCost);
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
    vecPossible = [1:m];
    vecPossible = vecPossible([1:m] ~= startPosition);
    % Get the sample space in one dimension
    vecData1 = vecPossible;
    vecData2 = vecPossible;
    n1 = length(vecPossible);
    n2 = length(vecPossible);
    funcLogic = @(data1, data2) data1 ~= data2;  % vecPossible(i) ~= vecPossible(j)
    cellSampleSpace = getSampleSpace(vecData1, vecData2, n1, n2, funcLogic);
    %
    nRow = length(vecPossible);
    cellArraySSpace = arrangeSampleSpace2dim(cellSampleSpace, nRow);
end


function [count] = getCountAnnealing(vector, k, matCost)
    temp = calTemp(k);
    energy = calEnergy(vector, matCost);
    count = exp(- energy / temp);
end


function [temp] = calTemp(k)
    temp = 1 / sqrt(1 + k);
end
