function [fig] = plotSurf(mat)
    fig = figure("Visible", "off");
    fig = surf(mat);
    saveas(fig, [pwd '/images/4.png']);
    saveas(fig, [pwd '/images/4.fig']);
end
