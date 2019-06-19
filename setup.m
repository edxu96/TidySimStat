% setup file
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim
% pwd
addpath('~/Documents/GitHub/StochasticSim/functions')  % ###############################################################
addpath('~/Documents/GitHub/StochasticSim/exercises')  % ###############################################################
addpath('~/Documents/GitHub/StochasticSim/data')  % ###############################################################
vecWheDoExercise = [0 0 0 0 0 0 0 1];
% ######################################################################################################################
if vecWheDoExercise(4)  % Exercise 4: Discrete Event Simulation
    nServer = 10;
    nCustomer = 11000;
    nEvent = nCustomer;
    nSim = 100;
    nStable = 1000;
    clockSimZero = 0;
    mu = 1;
    lambda = 8;
    tabYy = doExercise_4(nServer, nEvent, nSim, nStable, clockSimZero, mu, lambda);
end
% ######################################################################################################################
if vecWheDoExercise(5)  % Exercise 5: Variance Reduction
    nSample = 10000;
    fprintf('\n--------------------------------------------------------------------------------\n');
    fprintf('Exercise 5: Variance Reduction \n')
    doExercise_5(nSample);
    fprintf('--------------------------------------------------------------------------------\n\n');
end
% ######################################################################################################################
if vecWheDoExercise(6) == 1 % Exercise 6a:
    m = 10;
    nSample = 1000000;
    lambda = 8;
    mu = 1;
    aCap = lambda / mu;
    doExercise_6a(m, nSample, aCap);
end
% ######################################################################################################################
% Exercise 6b:
if vecWheDoExercise(6) == 2
    m = 10;
    nRow = 6;
    nSample = 1000000;
    aCap_1 = 4;
    aCap_2 = 4;
    whiMethod = 3;
    [matCount, matProb, cass] = doExercise_6b(m, nRow, nSample, aCap_1, aCap_2, whiMethod);
end
% ######################################################################################################################
if vecWheDoExercise(7)  % Exercise 7: Anealing Simulation to Solve TSM Problem Mat-Heuristically
    nSample = 10000;
    startPosition = 1;
    tempMax = 50;
    coefDecay = 0.5;
    coefStretch = 0.00001;
    strFigName = '7/8';
    seedInitial = 100;
    doExercise_7(nSample, startPosition, tempMax, coefDecay, strFigName, seedInitial, coefStretch);
end
% ######################################################################################################################
if vecWheDoExercise(8)  % Exercise 8: Bootstrap
    fprintf('\n--------------------------------------------------------------------------------\n');
    fprintf('Exercise 8: Bootstrap \n')
    beta = 1;
    k = 1.05;
    nSet = 100;
    nObs = 200;
    seedObs = 99;
    doExercise_8(beta, k, nSet, nObs, seedObs);
    fprintf('--------------------------------------------------------------------------------\n\n');
end
