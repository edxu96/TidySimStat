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
    % se = sqrt(sum((vecResult - expect).^2) / (n - 1));
    se = (sum(vecResult.^2) - n * expect^2) / (n - 1);
    lbMean = expect - se * tinv(1 - alpha / 2, n - 1) / sqrt(n);
    ubMean = expect + se * tinv(1 - alpha / 2, n - 1) / sqrt(n);
    fprintf('    ubMean = %f ;\n', ubMean)
    fprintf('    lbMean = %f ;\n', lbMean)
    lbVar = sqrt((n - 1) * se^2 / chi2inv(alpha / 2, n - 1));
    ubVar = sqrt((n - 1) * se^2 / chi2inv(1 - alpha / 2, n - 1));
    fprintf('    ubVar = %f ;\n', ubVar)
    fprintf('    lbVar = %f ;\n', lbVar)
end


% function [lb, ub] = calInterConf(vecResult, alpha, whi)
% % Calculate the Confidence Interval of vecResult
% % default: alpha = 0.05
% % ub: upper bound ; lb: lower bound ;
%     n = length(vecResult);
%     expect = mean(vecResult);
%     % se = sqrt(sum((vecResult - expect).^2) / (n - 1));
%     se = (sum(vecResult.^2) - n * expect^2) / (n - 1);
%     if whi == 1
%         lb = expect - se * tinv(1 - alpha / 2, n - 1) / sqrt(n);
%         ub = expect + se * tinv(1 - alpha / 2, n - 1) / sqrt(n);
%         fprintf('    ub of mean = %f ;\n', ub)
%         fprintf('    lb of mean = %f ;\n', lb)
%     elseif whi == 2
%         lb = (n - 1) * se^2 / chi2inv(alpha / 2, n - 1);
%         ub = (n - 1) * se^2 / chi2inv(1 - alpha / 2, n - 1);
%         fprintf('    ub of variance = %f ;\n', ub)
%         fprintf('    lb of variance = %f ;\n', lb)
%     end
% end
