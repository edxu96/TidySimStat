


function [matBootstrap] = simBootstrap(vecXx, nSet)
    fprintf('--------------------------------------------------------------------------------\n');
    fprintf('Boostrap: \n')
    fprintf('    nSet = %d ; \n', nSet)
    vecSeed = 1:nSet;
    nObs = length(vecXx);
    tic
    matBootstrap = zeros(nSet, nObs);
    for i = 1:nSet
        rng(vecSeed(i));
        indexBootstrap = randi(nObs, nObs, 1);
        matBootstrap(i, :) = vecXx(indexBootstrap);
    end
    clear indexBootstrap
    timeElapsed = toc;
    fprintf('    timeElapsed = %f ; \n', timeElapsed)
    analyzeMatBootstrap(matBootstrap)
end


function analyzeMatBootstrap(matBootstrap)
    vecMean = mean(matBootstrap');
    vecMedian = median(matBootstrap');
    vecVar = var(matBootstrap');
    analyzeVec(vecMean, 'vecMean from boostrap', 1);
    analyzeVec(vecMedian, 'vecMedian from boostrap', 1);
    analyzeVec(vecVar, 'vecVar from boostrap', 2);
end
