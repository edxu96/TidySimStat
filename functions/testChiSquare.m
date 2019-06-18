

function testChiSquare(vecNumObsClass, vecExpect, alpha)
    % [1253 625 1249 1249 625 1250 624 1250 1250 625]
    numClass = length(vecNumObsClass);
    vecResultTest = zeros(numClass, 1);
    for i = 1:numClass
        vecResultTest(i) = (vecNumObsClass(i) - vecExpect(i))^2 / vecExpect(i);
    end
    chiSquare = sum(vecResultTest);
    fprintf('chiSquare = %f ;\n', chiSquare);
    pValue = 1 - chi2cdf(chiSquare, numClass - 1 - 0);
    fprintf('pValue = %f ;\n', pValue);
    chiQuareCritical = chi2inv((1 - alpha), numClass - 1 - 0);
    fprintf('chiQuareCritical = %f ;\n', chiQuareCritical);
    if chiSquare > chiQuareCritical  % alpha = 0.95
        fprintf('reject H0;\n');
    else
        fprintf('accept H0;\n');
    end
end
