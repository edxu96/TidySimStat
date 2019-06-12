function [ boundLower, boundUpper ] = calConfInterval(vecResult)
% function: Short description
%
% Extended description
    n = length(vecResult);
    expect = mean(vecResult);
    sCapSquare = (sum(vecResult.^2) - n * expect^2) / (n - 1);
    boundLower = expect + sqrt(sCapSquare / n) * tpdf(0.05 / 2, n - 1);
    boundUpper = expect - sqrt(sCapSquare / n) * tpdf(0.05 / 2, n - 1);
end  % function
