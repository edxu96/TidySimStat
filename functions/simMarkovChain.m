

function [sState] = simMarkovChain(cellArraySSpace, funcGetCandidate, funcAcceptCandidate, nSample, vecPara)
    sState(1).x = cellArraySSpace{randi(length(cellArraySSpace))};
    sState(1).accept = 1;
    for n = 2:nSample
        sState(n).y = funcGetCandidate(cellArraySSpace, sState(n - 1).x);
        [sState(n).x, sState(n).accept] = funcAcceptCandidate(sState(n - 1).x, sState(n).y, vecPara);
    end
end
