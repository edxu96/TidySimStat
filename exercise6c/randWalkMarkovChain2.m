% function file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% ######################################################################################################################
function [vecNext] = randWalkMarkovChain2(cellArraySSpace, vecNow)
    [m, n] = size(cellArraySSpace);
    % Find where vecNow is
    where = 1;
    while ~isequal(cellArraySSpace{where}, vecNow)
        where = where + 1;
    end
    [x, y] = returnXY(where, m, n);
    % disp(x)
    % disp(y)
    if cellArraySSpace{x, y} ~= cellArraySSpace{where}
        error("Error when trying to find where the x is.")
    end
    % Random Walk
    x = loopRandWalk(x, m);
    y = loopRandWalk(y, n);
    % disp(x)
    % disp(y)
    vecNext = [cellArraySSpace{x, y}];
end


function [x, y] = returnXY(where, m, n)
    x = mod(where, m);
    y = floor(where / m) + 1;
    if x == 0
        x = m;
        y = y - 1;
    end
end


function [x] = loopRandWalk(x, nMax)
    x = x + randWalk();
    if x > nMax
        x = 1;
    elseif x < 1
        x = nMax;
    end
end
