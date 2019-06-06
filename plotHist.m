function [ vecProb10Class ] = plotHist( vecResultNorm )
    % Plot the histogram of RNG result and return the vector of
    figHist = figure("Visible", "off");
    figHist = histogram(vecResultNorm, 'NumBins', 10, 'Normalization', 'probability');
    saveas(figHist, [pwd '/images/figHist.png']);
    vecProb10Class = figHist.Values;
end
