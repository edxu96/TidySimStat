

function [vecXx] = simDist(nUu, seed, funcSimDist, vecPara)
    rng(seed);
    vecUu = rand(nUu, 1);
    vecXx = zeros(nUu, 1);
    for i = 1:nUu
        vecXx(i) = funcSimDist(vecUu(i), vecPara);
    end
    fprintf('mean(vecXx) = %f.\n', mean(vecXx))
    fprintf('median(vecXx) = %f.\n', median(vecXx))
    fprintf('var(vecXx) = %f.\n', var(vecXx))
end
