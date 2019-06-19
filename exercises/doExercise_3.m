

function doExercise_3(nSample)
    % 1,  Simulate Distributions ---------------------------------------------------------------------------------------
    rng(2); vecUu1 = rand(nSample, 1);
    rng(3); vecUu2 = rand(nSample, 1);
    vecUu3 = cos(2 * pi * vecUu2);
    % 2,  Simulate exponential -----------------------------------------------------------------------------------------
    cellUu = num2cell(vecUu1);
    simContinuousDist(1, cellUu, 8, 'exponential', 0:0.01:1.2);
    % 3,  Simulate normal distribution ---------------------------------------------------------------------------------
    cellUu = cell(nSample, 1);
    for i = 1:nSample
        cellUu{i} = [vecUu1(i) vecUu3(i)];
    end
    simContinuousDist(2, cellUu, 0, 'normal', -4:0.1:4);
    % 4,  Simulate Pareto distribution ---------------------------------------------------------------------------------
    cellUu = num2cell(vecUu1);
    simContinuousDist(3, cellUu, [1, 2.05], 'Pareto2.05-1', 0:1:40);
    simContinuousDist(3, cellUu, [1, 2.5], 'Pareto2.5-1', 0:1:40);
    simContinuousDist(3, cellUu, [1, 3], 'Pareto3-1', 0:1:40);
    simContinuousDist(3, cellUu, [1, 4], 'Pareto4-1', 0:1:40);
end


function simContinuousDist(whi, cellUu, vecPara, strDist, vecBinEdge)
    % fprintf('--------------------------------------------------------------------------------')
    % fprintf(['Simulate continuous ' strDist ' distribution: \n'])
    % 1,  Simulate distribution
    nSample = length(cellUu);
    funcSimDist = getFuncSimDist(whi);
    seed = 1;
    vecXx = simDistribution(cellUu, seed, funcSimDist, vecPara, strDist);
    getTheoreticalResult(vecPara, whi, strDist);
    % 2,  Get standard distribution
    vecXxStd = min(vecBinEdge):0.01:max(vecBinEdge);
    [funcDistStd, vecTest] = getFuncDistStd(whi, nSample, vecPara);
    vecYyStd = funcDistStd(vecXxStd, vecPara);
    % 3,  Plot the result in histogram
    vecResult = vecXx;
    strFigName = ['3/' strDist];
    strFigTitle = ['Simulated and Standard ' strDist ' Distribution'];
    strFigLegend = strDist;
    [vecProb, vecBinCenter] = plotHistogram(vecResult, vecXxStd, vecYyStd, vecBinEdge, strFigTitle, strFigName, strFigLegend);
    % 4,  Perform Tests
    vecXxStdTest = vecBinCenter;  % vecBinEdge;
    vecYyStdTest = funcDistStd(vecXxStdTest, vecPara);
    testChiSquare(vecProb * nSample, vecYyStdTest * nSample, 0.05);
    if whi == 3
        testKS(vecXx, vecTest, 1)
    else
        testKS(vecXx, vecTest, 0)
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


function [funcDistStd, vecTest] = getFuncDistStd(whi, nSample, vecParameter)
    if whi == 1  % Exponential Distribution
        funcDistStd = @(vecXxStd, vecPara) exppdf(vecXxStd, 1 / vecPara(1));
        vecTest = exprnd(1 / vecParameter(1), nSample, 1);
    elseif whi == 2  % Normal
        funcDistStd = @(vecXxStd, vecPara) normpdf(vecXxStd, 0, 1);
        vecTest = normrnd(0, 1, nSample, 1);
    elseif whi == 3
        % k = vecPara(1)
        % beta = vecPara(2)
        funcDistStd = @(vecXxStd, vecPara) gppdf(vecXxStd, 1 / vecPara(1), vecPara(2) / vecPara(1), 0);
        vecTest = gprnd(1 / vecParameter(1), vecParameter(2) / vecParameter(1), 0, nSample, 1);
    end
end


function getTheoreticalResult(vecPara, whi, strDist)
    if whi == 1
        meanDist = 1 / vecPara(1);
        medianDist = 1 / vecPara(1) * log(2);
        varDist = (1 / vecPara(1))^2;
    elseif whi == 2
        meanDist = 0;
        medianDist = 0;
        varDist = 1;
    elseif whi == 3
        beta = vecPara(1);
        k = vecPara(2);
        meanDist = beta * k / (k - 1);
        medianDist = beta * 2^(1 / k);
        varDist = beta^2 * k / (k - 1)^2 / (k - 2);
    end
    fprintf(['Theoretical Result of ' strDist ': \n'])
    fprintf('    mean = %f ; \n', meanDist)
    fprintf('    median = %f ; \n', medianDist)
    if (whi == 3) && (vecPara(2) < 2)
        fprintf('    We cannot get variance of Pareto dist theoretically when beta < 2; \n')
    else
        fprintf('    variance = %f ; \n', varDist)
    end
end
