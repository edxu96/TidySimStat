function [ vecProbClass ] = plotHist(vecResult, vecXstd, vecYstd, nBin, strFigName)
    % Plot the histogram of RNG result and return the vector of values
    figHist = figure("Visible", "off");
    figHist = histogram(vecResult, 'NumBins', nBin, 'Normalization', 'probability', "Visible", "off");
    vecProbClass = figHist.Values;
    vecProbClassNorm = vecProbClass / figHist.BinWidth;
    vecX = figHist.BinEdges(1:figHist.NumBins);
    vecX = vecX + figHist.BinWidth / 1;
    figHist = plot(vecX, vecProbClassNorm, 'b', 'LineWidth', 2);
    hold on
    figHist = plot(vecXstd, vecYstd, 'r', 'LineWidth', 2);
    hold off
    title("Simulation and Analysis Result of Queueing System with 10 Servers and A being 8");
    legend('Simulation', 'Analysis', 'Location', 'northwest');
    saveas(figHist, [pwd '/images/' strFigName]);
end
