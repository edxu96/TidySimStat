% setup file for exercise 8
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################
function doExercise_8(beta, k, nSet, nObs)
    fprintf("#### 1, Set Parameters #########################################################\n")
    fprintf("beta = %f, k = %f, nSet = %f, nObs = %f.\n", beta, k, nSet, nObs)
    seedObs = 99;
    vecSeedBootstrap = [1:nSet];
    vecPara = [beta, k];
    fprintf("#### 2, Generate Observations ##################################################\n")
    funcSimDist = @simDistPareto;
    vecXx = simDist(nObs, seedObs, funcSimDist, vecPara);
    fprintf("#### 3, Bootstrap Data Sets ####################################################\n")
    % sample from observations set with replacement
    matBootstrap = zeros(nSet, nObs);
    for i = 1:nSet
        rng(vecSeedBootstrap(i));
        indexBootstrap = randi(nObs, nObs, 1);
        matBootstrap(i, :) = vecXx(indexBootstrap);
    end
    clear indexBootstrap
    fprintf("#### 4, Analyze the Result #####################################################\n")
    vecMedian = median(matBootstrap');
    vecExpect = mean(matBootstrap');
    vecVar = var(matBootstrap');
    fprintf("mean(vecMedian) = %f, var(vecMedian) = %f.\n", mean(vecMedian), var(vecMedian))
    fprintf("mean(vecExpect) = %f, var(vecExpect) = %f.\n", mean(vecExpect), var(vecExpect))
    fprintf("mean(vecVar) = %f, var(vecVar) = %f.\n", mean(vecVar), var(vecVar))
    expectCal = beta * k / (k - 1);
    varCal = beta^2 * k / (k - 1)^2 / (k - 2);
    fprintf("Theoretically, mean = %f, var = %f.\n", expectCal, varCal)
    fprintf("#### End #######################################################################\n")
end
