function [ fig ] = plotHist(vecX1, vecX2)
    % Plot the histogram of RNG result and return the vector of values
    fig = figure("Visible", "off");
    fig = histogram2(vecX1, vecX2, 10);
    saveas(fig, [pwd '/images/5.png']);
    saveas(fig, [pwd '/images/5.fig']);
end
