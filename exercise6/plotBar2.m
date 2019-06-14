function [fig] = plotBar2(mat, strFileName, m)
    fig = figure("Visible", "off");
    fig = bar3([0:m], mat);  % [0:m], [0:m],
    saveas(fig, [pwd '/images/' strFileName '.png']);
    saveas(fig, [pwd '/images/' strFileName '.fig']);
end
