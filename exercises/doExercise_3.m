
function doExercise_3()

    % 2,  Simulate Distributions
    rng(2); vecUu1 = rand(10000, 1);
    rng(3); vecUu2 = rand(10000, 1);
    vecUu3 = cos(2 * pi * vecUu2);

    simContinuousDist(1, 8, 'exponential')

    simContinuousDist(2, 0, 'normal')

    simContinuousDist(3, [2.05, 1], 'Pareto')

    simContinuousDist(3, [2.5, 1], 'Pareto')

    simContinuousDist(3, [3, 1], 'Pareto')

    simContinuousDist(3, [4, 1], 'Pareto')


end


function simContinuousDist(whi, vecPara, strDist)
    % 1,  Simulate distribution
    nSample = length(cellUu);
    funcSimDist = getFuncSimDist(whi);
    seed = 1;
    vecXx = simDistribution(cellUu, seed, funcSimDist, vecPara, strDist);
    % 2,  Get standard distribution
    vecXxStd = min(vecXx):0.1:max(vecXx);
    funcDistStd = getFuncDistStd(whi);
    vecYyStd = simStdDist(vecXxStd, funcDistStd);
    % 3,  Plot the result in histogram
    vecResult = vecXx;
    numClass = 10;
    strFigName = ['3/' strDist];
    strFigTitle = ['Simulated and Standard ' strDist ' Distribution'];
    strFigLegend_1 = strDist;
    [vecProbClass, figHist] = plotHist(vecResult, vecXxStd, vecYyStd, numClass, strFigName, strFigTitle, strFigLegend_1);
    % 4,  Perform Tests
    vecXxStdTest = figHist.BinEdges(1:numClass) + figHist.BinWidth;
    vecYyStdTest = simStdDist(vecXxStdTest, funcDistStd);
    testChiSquare(vecProbClass * nSample, vecYyStdTest * nSample, 0.05);
    if whi ~= 3
        h = lillietest(vecXx, 'Alpha', 0.05, 'Distribution', strDist);
        disp(h)
    end
end


function [funcSimDist] = getFuncSimDist(whi)
    if whi == 1  % Exponential Distribution
        funcSimDist = @simDistExp;
    elseif whi == 2  % Normal
        funcSimDist = @simDistNorm;
    elseif whi == 3
        % k = vecPara(1)
        % beta = vecPara(2)
        funcSimDist = @simDistPareto;
    end
end


function [vecYyStd] = simStdDist(vecXxStd, funcDistStd)
    n = length(vecXxStd);
    vecYyStd = zeros(n, 1);
    for i = 1:n
        vecYyStd(i) = funcDistStd(vecXxStd(i));
    end
end


function [funcDistStd] = getFuncDistStd(whi)
    if whi == 1  % Exponential Distribution
        funcDistStd = @(vecXxStd, vecPara) exppdf(vecXxStd, 1 / vecPara(1));
    elseif whi == 2  % Normal
        funcDistStd = @(vecXxStd, vecPara) normpdf(vecXxStd, 0, 1);
    elseif whi == 3
        % k = vecPara(1)
        % beta = vecPara(2)
        funcDistStd = @(vecXxStd, vecPara) gppdf(vecXxStd, 1 / vecPara(1), vecPara(2) / vecPara(1), 0);
    end
end
