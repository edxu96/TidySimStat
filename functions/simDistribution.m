

function [vecXx] = simDistribution(cellUu, seed, funcSimDist, vecPara, strDist)
    rng(seed);
    nUu = length(cellUu);
    vecXx = zeros(nUu, 1);
    for i = 1:nUu
        vecXx(i) = funcSimDist(cellUu{i}, vecPara);
    end
    fprintf('--------------------------------------------------------------------------------\n');
    fprintf('Analysis of Simulated %s Distribution: \n', strDist)
    fprintf('    mean = %f ; \n', mean(vecXx))
    fprintf('    median = %f ; \n', median(vecXx))
    fprintf('    variance = %f ; \n', var(vecXx))
    calInterConf(vecXx, 0.05);
end
