function [resultBar] = simIntegral(nSample, funcSim, vecSample)
    vecResult = zeros(nSample, 1);
    for i = 1:nSample
        vecResult(i) = funcSim(vecSample(i));
    end
    resultBar = sum(vecResult) / nSample;
end
