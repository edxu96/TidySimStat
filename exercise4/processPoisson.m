function [ p ] = function( t, lambda, n )
% Calculate the probability of N(t) equals n
%
% :param t: time of the process
% :param lambda: parameters in the Poisson process
% :param n: input x
    p = (lambda * t)^n / factorial(n) * exp(- lambda * t)
end  % function
