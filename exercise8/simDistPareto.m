function [vecXcap] = simDistPareto(vecUcap, beta, k)
    numUcap = length(vecUcap);
    vecXcapRaw = zeros(numUcap, 1);
    for i = 1:numUcap
        vecXcapRaw(i) = beta * (vecUcap(i)^(- 1 / k) - 1);
    end
    % vecXstd = [min(vecXcap):0.01:max(vecXcap)];
    % vecYstd = gppdf(vecXstd, 1 / k, beta / k, 0);
    vecXcap = vecXcapRaw + beta;
    expectSim = mean(vecXcap);
    varSim = mean(vecXcap.^2) + expectSim^2;
    % Print the analysis of the simulation result and compare it with theoretical value
    expectCal = beta * k / (k - 1);
    varCal = beta^2 * k / (k - 1)^2 / (k - 2);
    fprintf("Simulation of Pareto Distribution, with beta = %f, and k = %f.\n", beta, k)
    fprintf("Expect = %f, theoretically = %f.\n", expectSim, expectCal)
    fprintf("Variance = %f, theoretically = %f.\n", varSim, varCal)
end
