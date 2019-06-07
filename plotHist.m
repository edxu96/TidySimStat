function [ vecProbClass ] = plotHist( vecResult, numClass, strFigName )
    % Plot the histogram of RNG result and return the vector of
    figHist = figure("Visible", "off");
    figHist = histogram(vecResult, 'NumBins', numClass, 'Normalization', 'probability');
    saveas(figHist, [pwd '/images/' strFigName]);
    vecProbClass = figHist.Values;
end
