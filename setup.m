% setup file
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim
% pwd
addpath('~/Documents/GitHub/StochasticSim/functions')  % ###############################################################
addpath('~/Documents/GitHub/StochasticSim/exercises')  % ###############################################################
addpath('~/Documents/GitHub/StochasticSim/data')  % ###############################################################


% whiMethod = 1;
% whiMethod = 2;

% ######################################################################################################################
% Exercise 7: Anealing Simulation to Solve TSM Problem Mat-Heuristically
nSample = 1000000;
startPosition = 1;
tempMax = 100;  % 1
coefDecay = 0.45;
strFigName = '7/5';
seedInitial = 2;
doExercise_7(nSample, startPosition, tempMax, coefDecay, strFigName, seedInitial);
% ######################################################################################################################
% Exercise 8: Bootstrap
% beta = 1;
% k = 2.05;
% nSet = 100;
% nObs = 10000;
% doExercise_8(beta, k, nSet, nObs);
