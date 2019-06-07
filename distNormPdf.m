function [ vecX, vecProbClass ] = distNormPdf( vecU1, vecTriU2, numClass, strFigName )
    numU = length(vecU1);
    vecX = zeros(numU, 1);
    for i = 1:numU
        vecX(i) = sqrt(-2 * log(vecU1(i))) * vecTriU2(i);
    end
    vecXstd = [min(vecX):0.01:max(vecX)];
    vecYstd = normpdf(vecXstd, 0, 1);
    [vecProbClass] = plotHist(vecX, vecXstd, vecYstd, numClass, strFigName);
end
