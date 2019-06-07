function [ vecX, vecProbClass ] = distExpPdf( vecU, lambda, numClass, strFigName )
    numU = length(vecU);
    vecX = zeros(numU, 1);
    for i = 1:numU
        vecX(i) = - log(vecU(i)) / lambda;
    end
    [vecProbClass] = plotHist(vecX, numClass, strFigName);
end
