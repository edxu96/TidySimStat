function [ fig ] = plotPdf( vecX, matY, strFigName, strTitle )
% Plot the fig and save
%
% Warning: remember to use '' for strFigName instead of "".
    [m, n] = size(matY);
    fig = figure("Visible", "off");
    hold on
    for i = 1:m
        fig = plot(vecX, matY(i, :), 'LineWidth', 2);
    end
    title(strTitle);
    legend;
    hold off
    saveas(fig, [pwd '/images/' strFigName]);
end  % function
