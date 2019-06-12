% Test the functions for exercise 4
% Author: Edward J. Xu
% Date: 190611
% Version: 2.1
% ######################################################################################################################
% 1,  Define Basic Parameters
nServer = 10;
nCustomer = 10000;  % 10000;
clockSimZero = 0;
% 2,  Define Functions for Length of Arrival Interval and Serve Time
[funcArrive, vecParaArrive] = getFunc("expArrive");
[funcServe, vecParaServe] = getFunc("expServe");
% 3,  Begin `numSim`-Times Simulations
nEvent = nCustomer;
[b, sState] = simDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, vecParaArrive, vecParaServe);
plotLine([1:nEvent], [sState.nCustomerBlock], ...
    '2.png', "The Result of Number of Blocked Customers");
plotScatter([1:nEvent], [sState.nCustomerServe], ...
    '3.png', "The Result of Number of Customers being Served");
[bCap] = calErlangsFormula(8, 1, nServer);
plotLine([1:nEvent], [sState.b; ones(1, nEvent) * bCap], '4.png', "The Result of the Probability a Customer is Blocked");
matTimeDepart = [sState.vecTimeDepart];
% 6,  Functions ########################################################################################################
function [func, vecPara] = getFunc(whiFunc)
    if whiFunc == "expArrive"
        mu = 1;
        func = @exprnd;
        vecPara = mu;
    elseif whiFunc == "expServe"
        lambda = 8;
        func = @exprnd;
        vecPara = lambda;
    elseif  whiFunc == "cons"
        cons = 10;
        func = @(cons) cons;
        vecPara = cons;
    end
    fprintf("Func: %s.\n", whiFunc);
end
