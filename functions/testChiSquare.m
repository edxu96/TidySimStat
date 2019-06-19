% Function to perform Chi-Square test
% Author: Edward J. Xu
% Date: 190618
% ######################################################################################################################


function testChiSquare(vecObs, vecExp, alpha)
% Perform Chi-Square Test
% Hypothesis 0: the simulated vecObs can represent vecExp from analytical result
% Warning: If the simulation produces count, vecObs should be count instead of probability
    fprintf('Perform Chi-Square Test: \n')
    disp(vecObs)
    disp(vecExp)
    fprintf('    alpha = %f ; \n', alpha)
    numClass = length(vecObs);
    vecResultTest = zeros(numClass, 1);
    for i = 1:numClass
        vecResultTest(i) = (vecObs(i) - vecExp(i))^2 / vecExp(i);
    end
    chiSquare = sum(vecResultTest);
    fprintf('    chiSquare = %f ;\n', chiSquare)
    pValue = 1 - chi2cdf(chiSquare, numClass - 1 - 0);
    fprintf('    pValue = %f ;\n', pValue)
    chiQuareCritical = chi2inv((1 - alpha), numClass - 1 - 0);
    fprintf('    chiQuareCritical = %f ;\n', chiQuareCritical)
    if chiSquare > chiQuareCritical
        fprintf('    Reject H0. \n')
    elseif chiSquare < chiQuareCritical
        fprintf('    Accept H0. \n')
    end
end
