function [ vecResultNorm, prob ] = testRngLcg(mCap, a, c, x0)
    % Test the simulated random number using many test
    % Example: mCap = 16; a = 5; c = 1; x0 = 3;
    %          vecResult = function(mCap, a, c, x0)
    % 1,  Generate the vector of random numbers using LCG
    [vecResultNorm, vecProbNorm] = getRngLcg(mCap, a, c, x0);
    % 2,  Plot the histogram of normlized number using 0 as min and mCap as max
    [vecProb10Class] = plotHist(vecResultNorm);
    % 3,  Test
    [prob] = testChiSquare(vecProb10Class);
    fprintf('Chi-Square Test Result: %f. \n', prob)
end
