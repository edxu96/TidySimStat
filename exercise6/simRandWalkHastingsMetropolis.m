% function file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% ######################################################################################################################
function [vecState, sState] = simRandWalkHastingsMetropolis(m, nSample, aCap)
    sState(1).x = randi(m + 1) - 1;  % Random integer in [0, m]
    for n = 2:nSample
        sState(n).y = loopRandWalk(sState(n - 1).x, m, 0);
        if calCount(sState(n).y, aCap) >= calCount(sState(n - 1).x, aCap)
            sState(n).x = sState(n).y;
        else
            if rand() < calCount(sState(n).y, aCap) / calCount(sState(n - 1).x, aCap)
                sState(n).x = sState(n).y;
            else
                sState(n).x = sState(n - 1).x;
        end
    end
    vecState = [sState.x];
end
