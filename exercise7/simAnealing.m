% function file for exercise 6
% Author: Edward J. Xu
% Date: 190614
% ######################################################################################################################


function [sState] = simAnealing(startPosition, m, nSample)
    cellArraySSpace = getSampleSpace2(m, startPosition);
    % Generate a Permutation Randomly
    vecXcap = zeros(m + 1, 1);
    vecXcap(1) = startPosition;
    vecXcap(m + 1) = startPosition;
    vecPerm = randperm(m);
    vecXcap(2:m) = vecPerm(vecPerm ~= startPosition);
    sState(1).x = vecXcap;
    sState(1).z = cellArraySSpace{randi(length(cellArraySSpace))};
    % Start Anealing
    for n = 2:nSample
        sState(n).x = randWalk2(cellArraySSpace, sState(n - 1).z);
         sState(n).y
        % Accept the candidate state or not.
        [sState(n).x, sState(n).accept] = acceptCandidate(sState(n - 1).x, sState(n).y, aCap_1, aCap_2);
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


function [x, accept] = acceptCandidate(xPre, y, aCap_1, aCap_2)
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


function [cellArraySSpace] = getSampleSpace2(m, startPosition)
    %
    vecPossible = [1:m];
    vecPossible = vecPossible([1:m] ~= startPosition);
    % Get the sample space in one dimension
    cellSampleSpace = getSampleSpace(vecPossible);
    %
    nRow = length(vecPossible);
    nCol = length(cellSampleSpace) / nRow;
    if mod(nCol, 1) ~= 0
        error("nRow is impossible!!!")
    end
    cellArraySSpace = {};
    k = 1;
    for i = 1:nRow
        for j = 1:nCol
            cellArraySSpace(i, j) = cellSampleSpace(k);
            k = k + 1;
        end
    end
end


function [cellSampleSpace] = getSampleSpace(vecPossible)
    n = length(vecPossible);
    cellSampleSpace = {};
    for i = 1:n
        for j = 0:n
            cellSampleSpace{end+1} = [vecPossible(i), vecPossible(j)];
        end
    end
    cellSampleSpace = cellSampleSpace(randperm(length(cellSampleSpace)));
end
