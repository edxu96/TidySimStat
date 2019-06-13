function [fig] = plotSurf(mat, strFileName)
    fig = figure("Visible", "off");
    fig = surf(mat);
    saveas(fig, [pwd '/images/' strFileName '.png']);
    saveas(fig, [pwd '/images/' strFileName '.fig']);
end
