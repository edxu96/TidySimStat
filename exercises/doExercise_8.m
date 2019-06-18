% setup file for exercise 8
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################


function doExercise_8(beta, k, nSet, nObs, seedObs)
    fprintf('--------------------------------------------------------------------------------\n');
    fprintf('Set Parameters: \n')
    fprintf('    beta = %f ; \n', beta)
    fprintf('    k = %f ; \n', k)
    fprintf('    nObs = %f ; \n', nObs)
    vecPara = [beta, k];
    % 2, Generate Observations
    funcSimDist = @simDistPareto;
    vecXx = simDist(nObs, seedObs, funcSimDist, vecPara, 'Pareto');
    % 3, Bootstrap Data Sets
    % sample from observations set with replacement
    [matBootstrap] = bootstrap(vecXx, nSet);
    fprintf('--------------------------------------------------------------------------------\n');
    fprintf('Theoretically: \n')
    fprintf('    mean = %f ; \n', beta * k / (k - 1))
    fprintf('    median = %f ; \n', beta * 2^(1 / k))
    fprintf('    var = %f ; \n', beta^2 * k / (k - 1)^2 / (k - 2))
end
