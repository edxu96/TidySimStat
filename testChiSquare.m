function [ prob ] = testChiSquare(vecNumObsClass)
    % [1253 625 1249 1249 625 1250 624 1250 1250 625]
    numClass = length(vecNumObsClass);
    numObs = sum(vecNumObsClass);
    vecResultTest = zeros(numClass, 1);
    expect = numObs / numClass;
    for i = 1:numClass
        vecResultTest(i) = (vecNumObsClass(i) - expect)^2 / expect;
    end
    tCap = sum(vecResultTest);
    prob = 1 - chi2pdf(tCap, numClass - 1 - 0);
end
