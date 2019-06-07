function [ vecX, vecProbClass ] = distGeoPDF(vecU, p, numClass, strFigName)
    numU = length(vecU);
    vecX = zeros(numU, 1);
    for i = 1:numU
        vecX(i) = floor(log(vecU(i)) / log(1 - p)) + 1;
    end
    figHist = figure("Visible", "off");
    hold on
    figHist = histogram(vecX, 'NumBins', numClass, 'Normalization', 'probability');
    vecXstd = [min(vecX):max(vecX)];
    vecYstd = geopdf(vecXstd, p);
    plot(vecXstd, vecYstd, "r")
    hold off
    saveas(figHist, [pwd '/images/' strFigName]);
    vecProbClass = figHist.Values;
    % [vecProbClass] = plotHist(vecX, numClass, strFigName);
end
