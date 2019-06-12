function [vecProbClass] = plotHist(vecResult, vecXstd, vecYstd, numClass, strFigName, strFigTitle, strFigLegend_1)
    % Plot the histogram of RNG result and return the vector of values
    figHist = figure("Visible", "off");
    figHist = histogram(vecResult, 'NumBins', numClass, 'Normalization', 'probability', "Visible", "off");
    vecProbClass = figHist.Values;
    vecProbClassNorm = vecProbClass / figHist.BinWidth;  % Normalize the prob with BinWidth
    vecX = figHist.BinEdges(1:figHist.NumBins);
    vecX = vecX + figHist.BinWidth / 1;
    figHist = plot(vecX, vecProbClassNorm, 'b', 'LineWidth', 2);
    hold on
    figHist = plot(vecXstd, vecYstd, 'r', 'LineWidth', 2);
    hold off
    title(strFigTitle);
    legend(strFigLegend_1, 'Standard Distribution');
    saveas(figHist, [pwd '/images/' strFigName]);
end
