function [fig] = plotSurf(mat, strFileName, m)
    fig = figure("Visible", "off");
    fig = surf([0:m], [0:m], mat);
    saveas(fig, [pwd '/images/' strFileName '.png']);
    saveas(fig, [pwd '/images/' strFileName '.fig']);
end
