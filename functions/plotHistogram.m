% function file for exercise 7
% Author: Edward J. Xu
% Date: 190614
% ######################################################################################################################


function [vecProb] = plotHistogram(vecResult, vecXxStd, vecYstd, nBin, strTitle, strFigName)
    % Plot the histogram of RNG result and return the vector of values
    fig = figure('Visible', 'off');
    figHist = histogram(vecResult, 'NumBins', nBin, 'BinEdges', -0.5:1:10.5, 'Normalization', 'probability', 'Visible', 'off');
    vecProb = figHist.Values;
    vecProbNorm = vecProb / figHist.BinWidth;
    plot(vecXxStd, vecProbNorm, 'b', 'LineWidth', 2);
    hold on
    plot(vecXxStd, vecYstd, 'r', 'LineWidth', 2);
    hold off
    title(strTitle);
    legend('Simulation', 'Analysis', 'Location', 'northwest');
    saveas(fig, [pwd '/images/' strFigName '.png']);
    saveas(fig, [pwd '/images/' strFigName '.fig']);
end
