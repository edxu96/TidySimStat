

function [vecCandidate] = loopRandWalk2Dim(cellArraySSpace, vecPre)
    [m, n] = size(cellArraySSpace);
    % Find where vecPre is
    where = 1;
    while ~isequal(cellArraySSpace{where}, vecPre)
        where = where + 1;
    end
    [x, y] = getArrayPosition(where, m, n);
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
