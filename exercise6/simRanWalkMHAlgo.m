function [vecX, sState] = simRanWalkMHAlgo(m, nSample, aCap)
    sState(1).x = randi(m + 1) - 1;  % Random integer in [0, m]
    for n = 2:nSample
        sState(n).y = sState(n - 1).x + randWalk();
        if sState(n).y > m
            sState(n).y = sState(n).y - m;
        elseif sState(n).y < 1
            sState(n).y = sState(n).y + m;
        end
        % disp(sState(n).y)
        if calCount(sState(n).y, aCap) >= calCount(sState(n - 1).x, aCap)
            sState(n).x = sState(n).y;
        else
            if rand() < calCount(sState(n).y, aCap) / calCount(sState(n - 1).x, aCap)
                sState(n).x = sState(n).y;
            else
                sState(n).x = sState(n - 1).x;
        end
    end
    vecX = [sState.x];
end
