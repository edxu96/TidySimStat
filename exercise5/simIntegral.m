function [resultBar] = simIntegral(nSample, funcSim)
    vecResult = zeros(nSample, 1);
    vecSample = rand(nSample);
    for i = 1:nSample
        vecResult(i) = funcSim(vecSample(i));
    end
    resultBar = sum(vecResult) / nSample;
end
