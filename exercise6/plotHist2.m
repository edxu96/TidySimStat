function [ fig ] = plotHist(vecX1, vecX2, strFileName)
    % Plot the histogram of RNG result and return the vector of values
    fig = figure("Visible", "off");
    fig = histogram2(vecX1, vecX2, 10, 'FaceColor', 'flat');
    saveas(fig, [pwd '/images/' strFileName '.png']);
    saveas(fig, [pwd '/images/' strFileName '.fig']);
end
