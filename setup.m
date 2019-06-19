% setup file
% Author: Edward J. Xu
% Date: 190619
% ######################################################################################################################
% cd ~/Documents/GitHub/StochasticSim
% pwd
addpath('~/Documents/GitHub/StochasticSim/functions')  % ###############################################################
addpath('~/Documents/GitHub/StochasticSim/exercises')  % ###############################################################
addpath('~/Documents/GitHub/StochasticSim/data')  % ###############################################################
% exercise3();
% exercise4();
% exercise5();
% exercise6a();
% exercise6b();
% exercise7();
% exercise8();
% ######################################################################################################################


function exercise3()
    fprintf('\n--------------------------------------------------------------------------------\n');
    fprintf('Exercise 3: Simulate Continuous Random Variable \n')
    nSample = 100000;
    doExercise_3(nSample);
    fprintf('--------------------------------------------------------------------------------\n\n');
end


function exercise4()
    nServer = 10;
    nCustomer = 11000;
    nEvent = nCustomer;
    nSim = 100;
    nStable = 1000;
    clockSimZero = 0;
    mu = 1;
    lambda = 8;
    fprintf('\n--------------------------------------------------------------------------------\n')
    fprintf('Exercise 4: Discrete Event Simulation of Blocking System \n')
    tabYy = doExercise_4(nServer, nEvent, nSim, nStable, clockSimZero, mu, lambda);
    fprintf('--------------------------------------------------------------------------------\n\n');
end


function exercise5()
    nSample = 10000;
    fprintf('\n--------------------------------------------------------------------------------\n');
    fprintf('Exercise 5: Variance Reduction \n')
    doExercise_5(nSample);
    fprintf('--------------------------------------------------------------------------------\n\n');
end


function exercise6a()
    m = 10;
    nSample = 1000000;
    lambda = 8;
    mu = 1;
    aCap = lambda / mu;
    doExercise_6a(m, nSample, aCap);
end


function exercise6b()
    m = 10;
    nRow = 6;
    nSample = 1000000;
    aCap_1 = 4;
    aCap_2 = 4;
    whiMethod = 3;
    [matCount, matProb, cass] = doExercise_6b(m, nRow, nSample, aCap_1, aCap_2, whiMethod);
end


function exercise7()
    nSample = 10000;
    startPosition = 1;
    tempMax = 50;
    coefDecay = 0.5;
    coefStretch = 0.00001;
    strFigName = '7/8';
    seedInitial = 100;
    doExercise_7(nSample, startPosition, tempMax, coefDecay, strFigName, seedInitial, coefStretch);
end


function exercise8()
    fprintf('\n--------------------------------------------------------------------------------\n');
    fprintf('Exercise 8: Bootstrap \n')
    beta = 1;
    k = 1.05;
    nSet = 100;
    nObs = 200;
    seedObs = 50;
    doExercise_8(beta, k, nSet, nObs, seedObs);
    fprintf('--------------------------------------------------------------------------------\n\n');
end


function note()
    n = 10;
    lambda = 1;
    mu = analyzePareto(0.38, 1.05)
    bCap = calErlangsFormula(lambda, mu, n)
    mu = analyzePareto(4.10, 2.05)
    bCap = calErlangsFormula(lambda, mu, n)
end
