% function file
% Author: Edward J. Xu
% Date: 190619
% ######################################################################################################################


function [sState] = simMarkovChain(sampleSpace, funcGetCandidate, funcAcceptCandidate, nSample, vecPara)
    sState(1:nSample) = struct('x', NaN, 'accept', 0, 'y', NaN);
    sState(1).x = sampleSpace{randi(length(sampleSpace))};
    sState(1).accept = 1;
    for n = 2:nSample
        % disp(sState(n - 1).x)
        sState(n).y = funcGetCandidate(sampleSpace, sState(n - 1).x);
        cell = funcAcceptCandidate(sState(n - 1).x, sState(n).y, vecPara);
        sState(n).x = cell{1};
        sState(n).accept = cell{2};
    end
end
