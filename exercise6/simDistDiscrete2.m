% function file for exercise 6
% Author: Edward J. Xu
% Date: 190614
% ######################################################################################################################


function [sState] = simDistDiscrete2(m, nRow, nSample, aCap_1, aCap_2, whiMethod)
    cellArraySSpace = getSampleSpace2(m, nRow);
    sState(1).x = cellArraySSpace{randi(length(cellArraySSpace))};
    sState(1).accept = 1;
    for n = 2:nSample
        if whiMethod == 1
            % Generate candidate state using 2-D random walk with arrangement of sample space.
            sState(n).y = randWalk2(cellArraySSpace, sState(n - 1).x);
            % Accept the candidate state or not.
            [sState(n).x, sState(n).accept] = acceptCandidate(sState(n - 1).x, sState(n).y, aCap_1, aCap_2);
        elseif whiMethod == 2
            % Generate candidate state using Gibbs sampler.
            sState(n).y = sampleGibbs(sState(n - 1).x, m, aCap_1, aCap_2);
            % Always accept the candidate state.
            sState(n).x = sState(n).y;
        end
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


function [vecCandidate] = sampleGibbs(vecPre, m, aCap_1, aCap_2)
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
