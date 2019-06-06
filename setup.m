% setup file for exercises in stochastic simulation
% by Edward J. Xu and Sanaz
% 190606
% ######################################################################################################################
% cd Documents/GitHub/StochasticSim
% pwd
% ######################################################################################################################
addpath("/Users/fengguangjie/Documents/GitHub/StochasticSim")
%
mCap = 10000;
a    = 500000000;
c    = 100000000;
x0   = 3;
vecResultNorm = testRngLcg(mCap, a, c, x0);
