function [ bCap ] = calErlangsFormula( lambda, mu, n )
% function: Short description
%
% Extended description
    aCap = lambda * mu;
    sum = 0;
    for i = 0:n
        sum = sum + aCap^i / factorial(i);
    end
    bCap = (aCap^n / factorial(n) ) / ( sum );
end  % function
