

function [prob] = testChiSquare(vecNumObsClass, vecExpect)
    % [1253 625 1249 1249 625 1250 624 1250 1250 625]
    numClass = length(vecNumObsClass);
    vecResultTest = zeros(numClass, 1);
    for i = 1:numClass
        vecResultTest(i) = (vecNumObsClass(i) - vecExpect(i))^2 / vecExpect(i);
    end
    tCap = sum(vecResultTest);
    prob = 1 - chi2pdf(tCap, numClass - 1 - 0);
    fprintf('Chi-Square T = %f ;\n', tCap);
    fprintf('Chi-Square Test Result: %f ;\n', prob);
end
