% setup file for exercises in stochastic simulation
% by Edward J. Xu and Sanaz
% 190606
addpath("/Users/fengguangjie/Documents/GitHub/StochasticSim")
cd Documents/GitHub/StochasticSim  % pwd
%
mCap = 16;
a = 5;
c = 1;
x0 = 3;
vecResult = testRngLcg(mCap, a, c, x0);
