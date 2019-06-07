function [ vecProbClass ] = plotHist( vecResult, vecXstd, vecYstd, numClass, strFigName )
    % Plot the histogram of RNG result and return the vector of values
    figHist = figure("Visible", "off");
    hold on
    figHist = histogram(vecResult, 'NumBins', numClass, 'Normalization', 'probability');
    vecProbClass = figHist.Values;
    figHist = plot(vecXstd, vecYstd, 'r', 'LineWidth', 2)
    hold off
    saveas(figHist, [pwd '/images/' strFigName]);
end
