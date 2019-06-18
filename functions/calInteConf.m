% function file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190611
% ######################################################################################################################


function [ boundLower, boundUpper ] = calInteConf(vecResult)
    n = length(vecResult);
    expect = mean(vecResult);
    sCapSquare = (sum(vecResult.^2) - n * expect^2) / (n - 1);
    boundLower = expect - sqrt(sCapSquare / n) * tpdf(0.05 / 2, n - 1);
    boundUpper = expect + sqrt(sCapSquare / n) * tpdf(0.05 / 2, n - 1);
end
