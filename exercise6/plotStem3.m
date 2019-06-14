function [fig] = plotBar3(mat, strFileName, m)
    fig = figure("Visible", "off");
    fig = stem3([0:m], [0:m], mat);  % [0:m], [0:m],
    saveas(fig, [pwd '/images/' strFileName '.png']);
    saveas(fig, [pwd '/images/' strFileName '.fig']);
end
