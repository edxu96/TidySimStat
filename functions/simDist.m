

function [vecXx] = simDist(nUu, seed, funcSimDist, vecPara, strDist)
    rng(seed);
    vecUu = rand(nUu, 1);
    vecXx = zeros(nUu, 1);
    for i = 1:nUu
        vecXx(i) = funcSimDist(vecUu(i), vecPara);
    end
    fprintf('--------------------------------------------------------------------------------\n');
    fprintf('Analysis of Simulated %s Distribution: \n', strDist)
    fprintf('    mean = %f ; \n', mean(vecXx))
    fprintf('    median = %f ; \n', median(vecXx))
    fprintf('    variance = %f ; \n', var(vecXx))
    calInterConf(vecXx, 0.05);
end
