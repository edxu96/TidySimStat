% setup file
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim
% pwd
addpath('~/Documents/GitHub/StochasticSim/functions')  % ###############################################################
addpath('~/Documents/GitHub/StochasticSim/exercises')  % ###############################################################
addpath('~/Documents/GitHub/StochasticSim/data')  % ###############################################################

% ######################################################################################################################
% Exercise 4: Discrete Event Simulation
nServer = 10;
nCustomer = 11000;
nEvent = nCustomer;
nSim = 100;
nStable = 1000;
clockSimZero = 0;
mu = 1;
lambda = 8;
tabYy = doExercise_4(nServer, nEvent, nSim, nStable, clockSimZero, mu, lambda);
% ######################################################################################################################
% Exercise 6:

% ######################################################################################################################
% Exercise 7: Anealing Simulation to Solve TSM Problem Mat-Heuristically
% nSample = 100000;
% startPosition = 1;
% tempMax = 50;
% coefDecay = 0.5;
% coefStretch = 0.1;
% strFigName = '7/7';
% seedInitial = 100;
% doExercise_7(nSample, startPosition, tempMax, coefDecay, strFigName, seedInitial, coefStretch);
% ######################################################################################################################
% Exercise 8: Bootstrap
% beta = 1;
% k = 2.05;
% nSet = 100;
% nObs = 10000;
% seedObs = 99;
% doExercise_8(beta, k, nSet, nObs, seedObs);
