% function file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190611
% ######################################################################################################################


function [lb, ub] = calInterConf(vecResult, alpha)
% Calculate the Confidence Interval of vecResult
% default: alpha = 0.05
% ub: upper bound ; lb: lower bound ;
    n = length(vecResult);
    expect = mean(vecResult);
    se = sqrt(sum((vecResult - expect).^2) / (n - 1));
    % se = (sum(vecResult.^2) - n * expect^2) / (n - 1);
    lb = expect - se * tinv(1 - alpha / 2, n - 1) / sqrt(n);
    ub = expect + se * tinv(1 - alpha / 2, n - 1) / sqrt(n);
    fprintf('    ub = %f ;\n', ub)
    fprintf('    lb = %f ;\n', lb)
end
