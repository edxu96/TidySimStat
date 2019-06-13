function [vecX, sState] = simHastMetroAlgo(m, aCap, matTransi)
    k = randi(m);
    sState(1).x = k;
    sState(1).u = 0;
    for n = 2:m
        % Get random variable X
        vecProbX = zeros(m + 1, 1);
        for j = 1:m
            p = matTransi(sState(n - 1).x, j);
            vecProbX(j + 1) = p + vecProbX(j);
        end
        sState(n).vecProbX = vecProbX;
        % Generate y using X
        yRaw = rand();
        j = 1;
        while yRaw < vecProbX(j + 1)
            j = j + 1;
        end
        sState(n).y = j;
        %
        sState(n).u = rand();
        sState(n).v = calCount(sState(n).y, aCap) * matTransi(sState(n).y, sState(n - 1).x) / ...
            calCount(sState(n - 1).x, aCap) / matTransi(sState(n - 1).x, sState(n).y);
        if sState(n).u < sState(n).v;
            sState(n).x = sState(n).y;
        else
            sState(n).x = sState(n - 1).x;
        end
    end
    vecX = [sState.x];
end
