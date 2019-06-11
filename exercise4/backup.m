function [ prob ] = processPoisson( t, lambda, n )
% Calculate the probability of N(t) equals n
%
% :param t: time of the process
% :param lambda: parameters in the Poisson process
% :param n: input x
    prob = (lambda * t)^n / factorial(n) * exp(- lambda * t);
end  % function


mu = 8;  % 1 / 64;
matProb = ones(10, 10);
for t = 1:10
    for n = 1:10
        matProb(t, n) = processPoisson(t, mu, n);
    end
end
plotPdf( [1:1:10], matProb, '1.png', "PDF of N(t) from Poisson Process" );


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
