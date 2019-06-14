function [ fig ] = plotHist2(vecX1, vecX2, mat, m, strFileName, whiMethod)
    % Plot the histogram of RNG result and return the vector of values
    fig = figure("Visible", "off");
    fig = histogram2(vecX1, vecX2, [-0.5:1:10.5], [-0.5:1:10.5], 'FaceColor', 'flat');
    hold on
    fig = stem3([0:m], [0:m], mat);
    hold off
    if whiMethod == 1
        saveas(fig, [pwd '/images/direct' strFileName '.png']);
        saveas(fig, [pwd '/images/direct' strFileName '.fig']);
    elseif whiMethod == 2
        saveas(fig, [pwd '/images/gibbs' strFileName '.png']);
        saveas(fig, [pwd '/images/gibbs' strFileName '.fig']);
    end
end
