% setup file for exercise 4
% Author: Edward J. Xu
% Date: 190612
% ######################################################################################################################


function doExercise_4(nServer, nEvent, nSim, nStable, clockSimZero, whi)
    fprintf('#### Begin #####################################################################');  % ####################
    [funcArrive, vecParaArrive, funcServe, vecParaServe] = getFunction(whi);
    fprintf('1,  Multiple Simulation --------------------------------------------------------');  % --------------------
    [vecYy] = simSeveralDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, vecParaArrive, ...
        vecParaServe, nStable);
    fprintf('2,  Result from Analysis -------------------------------------------------------');  % --------------------
    prob = calErlangsFormula(8, 1, nServer);
    fprintf('prob = %f.\n', prob);
    fprintf('3,  Result from Simulation -----------------------------------------------------');  % --------------------
    plotSimulation(sState);
    printResult(vecYy, var(vecYy));
    fprintf('4,  Result from Simulation and Control Variate ---------------------------------');  % --------------------
    expectYy = 1;
    vecXx = vecProbResult;
    vecZz = zeros(nSim, 1);
    covXxYy = cov(vecX, vecYy);
    varXxYy = covXxYy(1, 2);
    c = - varXxYy / var(vecYy);
    for i = 1:nSim
        vecZz(i) = vecXx(i) + c * (vecYy(i) - expectYy);
    end
    varianceZz = var(vecXx) - varXxYy^2 / var(vecYy);  % The calculation is a bit different. ???
    printResult(vecZz, varianceZz);
    fprintf('#### End #######################################################################');  % ####################
end


function [vecYy] = simSeveralDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, vecParaArrive, ...
    vecParaServe, nStable)
    tic
    vecProbResult = zeros(nSim, 1);
    vecYy = zeros(nSim, 1);
    for i = 1:nSim
        sState = simDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, ...
            vecParaArrive, vecParaServe);
        vecProbResult(i) = (sState(nEvent).nCustomerBlock - sState(nStable).nCustomerBlock) / (nEvent - nStable);
        vecYy(i) = mean([sState.inteEvent]);
    end
    toc
end


function [funcArrive, vecParaArrive, funcServe, vecParaServe] = getFunction(whi)
    if whi == 1
        [funcArrive, vecParaArrive] = getFuncArrive('expArrive', mu, lambda);
        [funcServe, vecParaServe] = getFuncServe('expServe', mu, lambda);
    end
end


function [func, vecPara] = getFuncArrive(whiFunc)
% To define the function for length of arrival interval and serving time.
    if whiFunc == 'exp'
        func = @exprnd;
        vecPara = 1;
    elseif  whiFunc == 'cons'
        cons = 8;
        func = @(cons) cons;
        vecPara = cons;
    end
    fprintf('Function for Inter-Arrival Time: %s.\n', whiFunc);
end


function [func, vecPara] = getFuncServe(whiFunc)
% To define the function for length of arrival interval and serving time.
    if whiFunc == 'expArrive'
        func = @exprnd;
        vecPara = 1;
    elseif whiFunc == 'expServe'
        func = @exprnd;
        vecPara = 8;
    elseif  whiFunc == 'cons'
        cons = 8;
        func = @(cons) cons;
        vecPara = cons;
    end
    fprintf('Function for Service Time: %s.\n', whiFunc);
end


function [boundLower, boundUpper] = printResult(vecResult, variance)
    fprintf('mean(b) = %f.\n', mean(vecResult));
    fprintf('var(b) = %f.\n', variance);
    [boundLower, boundUpper] = calConfInte(vecResult);
    fprintf('lowerConfiInterval(b) = %f.\n', boundLower);
    fprintf('upperConfiInterval(b) = %f.\n', boundUpper);
end


function plotSimulation(sState)
    vecXxStd_1 = 0.01:0.01:5;
    vecYyStd_1 = exppdf(vecXxStd_1, mu);
    plotHist([sState.inteEvent], vecXxStd_1, vecYyStd_1, 30, '5.png', ...
        'Histogram of Simulated Inter-Arrival and Exponential Distribution', 'Histogram of Inter-Arrival');
    vecXxStd_2 = 0.01:1:40;
    vecYyStd_2 = exppdf(vecXxStd_2, lambda);
    plotHist([sState.timeServe], vecXxStd_2, vecYyStd_2, 30, '6.png', ...
        'Histogram of Simulated Serving Time and Exponential Distribution', 'Histogram of Serving Time');
end


% function test()
%     nServer = 10;
%     nCustomer = 10000;  % 10000;
%     clockSimZero = 0;
%     % 2,  Define Functions for Length of Arrival Interval and Serve Time
%     [funcArrive, vecParaArrive] = getFunc2('expArrive');
%     [funcServe, vecParaServe] = getFunc2('expServe');
%     % 3,  Begin `numSim`-Times Simulations
%     nEvent = nCustomer;
%     [b, sState] = simDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, vecParaArrive, vecParaServe);
%     plotLine(1:nEvent, [sState.nCustomerBlock], ...
%         '2.png', 'The Result of Number of Blocked Customers');
%     plotScatter(1:nEvent, [sState.nCustomerServe], ...
%         '3.png', 'The Result of Number of Customers being Served');
%     [bCap] = calErlangsFormula(8, 1, nServer);
%     plotLine(1:nEvent, [sState.b; ones(1, nEvent) * bCap], '4.png', 'The Result of the Probability a Customer is Blocked');
%     matTimeDepart = [sState.vecTimeDepart];
% end
%
%
% function [func, vecPara] = getFunc2(whiFunc)
%     if whiFunc == 'expArrive'
%         mu = 1;
%         func = @exprnd;
%         vecPara = mu;
%     elseif whiFunc == 'expServe'
%         lambda = 8;
%         func = @exprnd;
%         vecPara = lambda;
%     elseif  whiFunc == 'cons'
%         cons = 10;
%         func = @(cons) cons;
%         vecPara = cons;
%     end
%     fprintf('Func: %s.\n', whiFunc);
% end
