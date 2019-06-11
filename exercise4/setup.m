% setup file for exercise 4
% Author: Edward J. Xu
% Date: 190611
% Version: 1.0
vecProb = ones(100, 1)
for n = 1:100
    vecProb[n] = processPoisson(1, 1 / 64, n)
end
