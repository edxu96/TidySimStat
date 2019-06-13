function [vecX, sState] = simRanWalkMHAlgo(m, nSample, aCap)
    sState(1).x = randi(m);
    for i = 2:nSample
        sState(i).y = sState(i - 1).x + randWalk();
        if sState(i).y > m
            sState(i).y = sState(i).y - m;
        elseif sState(i).y < 1
            sState(i).y = sState(i).y + m;
        end
        % disp(sState(i).y)
        if calCount(sState(i).y, aCap) >= calCount(sState(i - 1).x, aCap)
            sState(i).x = sState(i).y;
        else
            if rand() < calCount(sState(i).y, aCap) / calCount(sState(i - 1).x, aCap)
                sState(i).x = sState(i).y;
            else
                sState(i).x = sState(i - 1).x;
        end
    end
    vecX = [sState.x];
end
