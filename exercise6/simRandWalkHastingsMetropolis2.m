% function file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% ######################################################################################################################


function [vecX, sState] = simRandWalkHastingsMetropolis2(m, nRow, nSample, aCap_1, aCap_2)
    cellArraySSpace = getSampleSpace2(m, nRow);
    sState(1).x = cellArraySSpace{randi(length(cellArraySSpace))};
    for n = 2:nSample
        sState(n).y = randWalkMarkovChain2(cellArraySSpace, sState(n - 1).x);  % Generate the candidate state
        % disp(sState(n).y)
        %
        if calCount2(sState(n).y(1), sState(n).y(2), aCap_1, aCap_2) >= ...
            calCount2(sState(n - 1).x(1), sState(n - 1).x(2), aCap_1, aCap_2)
            sState(n).x = sState(n).y;
        else
            if rand() < (calCount2(sState(n).y(1), sState(n).y(2), aCap_1, aCap_2) / ...
                calCount2(sState(n - 1).x(1), sState(n - 1).x(2), aCap_1, aCap_2))
                sState(n).x = sState(n).y;
            else
                sState(n).x = sState(n - 1).x;
        end
    end
    vecX = [sState.x];
end


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
    x = loopRandWalk(x, m, 1);
    y = loopRandWalk(y, n, 1);
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





% x1 = randi(m + 1) - 1;
% x2 = randi(x1) - 1;
% sState(1).x = [x1, x2];


% y1 = sState(n - 1).x(1) + randWalk();
% if y1 > m
%     y1 = y1 - (m + 1);
% elseif y1 < 0
%     y1 = y1 + (m + 1);
% end
% % disp(y1)
% y2 = sState(n - 1).x(2) + randWalk();
% % disp(y2)
% if y2 > m - y1
%     y2 = 0;
% elseif y2 < 0
%     y2 = m - y1;
% end
% sState(n).y = [y1, y2];
