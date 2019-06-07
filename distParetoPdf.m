function [ vecX, vecProbClass ] = distParetoPdf( vecU, beta, k, numClass, strFigName )
    numU = length(vecU);
    vecX = zeros(numU, 1);
    for i = 1:numU
        vecX(i) = beta * (vecU(i)^(- 1 / k) - 1);
    end
    vecXstd = [min(vecX):0.01:max(vecX)];
    vecYstd = vecXstd;
    for i = 1:length(vecXstd)
        % vecYstd(i) = k * beta^k / vecXstd(i)^(k + 1);
        vecYstd(i) = 1 / beta * (1 + vecXstd(i) / beta)^(-k + 1);
    end
    % vecYstd = gppdf(vecXstd, 1 / k, beta / k, 0);
    [vecProbClass] = plotHist(vecX, vecXstd, vecYstd, numClass, strFigName);
end
