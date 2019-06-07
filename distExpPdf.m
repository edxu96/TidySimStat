function [ vecX, vecProbClass ] = distExpPdf( vecU, lambda, numClass, strFigName )
    numU = length(vecU);
    vecX = zeros(numU, 1);
    for i = 1:numU
        vecX(i) = - log(vecU(i)) / lambda;
    end
    vecXstd = [min(vecX):0.01:max(vecX)];
    vecYstd = exppdf(vecXstd, 1 / lambda);
    [vecProbClass] = plotHist(vecX, vecXstd, vecYstd, numClass, strFigName);
end
