function [result] = simIntegral(nSample, funcSim)
    vecResult = zeros(nSample, 1);
    vecSample = rand(nSample);
    for i = 1:nSample
        vecResult(i) = funcSim(vecSample(i));
    end
    result = sum(vecResult) / nSample;
end
