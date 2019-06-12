function [vecResult] = sampleFuncSim(nSample, funcSim, vecU)
    vecResult = zeros(nSample, 1);
    for i = 1:nSample
        vecResult(i) = funcSim(vecU(i));
    end
end
