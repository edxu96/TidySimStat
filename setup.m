% setup file
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim
% pwd
addpath("~/Documents/GitHub/StochasticSim/functions")  % ###############################################################
addpath("~/Documents/GitHub/StochasticSim/exercises")  % ###############################################################

% Exercise 7: Anealing Simulation to Solve TSM Problem Mat-Heuristically
nSample = 100000;
doExercise_7(beta, k, nSet, nObs);
% Exercise 8: Bootstrap
beta = 1;
k = 2.05;
nSet = 100;
nObs = 10000;
doExercise_8(beta, k, nSet, nObs);
