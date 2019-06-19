

function [vecProbClass, figHist] = plotHist(vecResult, vecXxStd, vecYyStd, numClass, strFigName, strFigTitle, strFigLegend_1)
    % Plot the histogram of RNG result and return the vector of values
    figure('Visible', 'off');
    figHist = histogram(vecResult, 'NumBins', numClass, 'Normalization', 'probability', 'Visible', 'off');
    vecProbClass = figHist.Values;
    vecProbClassNorm = vecProbClass / figHist.BinWidth;  % Normalize the prob with BinWidth
    vecX = figHist.BinEdges(1:figHist.NumBins);
    vecX = vecX + figHist.BinWidth / 1;
    fig = plot(vecX, vecProbClassNorm, 'b', 'LineWidth', 2);
    hold on
    plot(vecXxStd, vecYyStd, 'r', 'LineWidth', 2);
    hold off
    title(strFigTitle);
    legend(strFigLegend_1, 'Standard Distribution');
    saveas(fig, [pwd '/images/' strFigName '.png']);
    saveas(fig, [pwd '/images/' strFigName '.fig']);
end
