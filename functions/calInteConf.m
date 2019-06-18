% function file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190611
% ######################################################################################################################


function [lb, ub] = calInteConf(vecResult)
% ub: upper bound ; lb: lower bound ;
    n = length(vecResult);
    expect = mean(vecResult);
    se = sqrt(sum((vecResult - expect).^2) / (n - 1));
    % se = (sum(vecResult.^2) - n * expect^2) / (n - 1);
    lb = expect - se / sqrt(n) * tpdf(0.05 / 2, n - 1);
    ub = expect + se / sqrt(n) * tpdf(0.05 / 2, n - 1);
end
