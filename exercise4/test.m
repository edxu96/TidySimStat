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
whiFuncArrive = "exp";
whiFuncServe = "exp";
if whiFuncArrive == "exp"
    mu = 1;
    funcArrive = @exprnd;
    vecParaArrive = mu;
elseif  whiFuncArrive == "cons"
    cons = 10;
    funcArrive = @(cons) cons;
    vecParaArrive = cons;
end
% gamrnd(nServer, 1 / nServer);
if whiFuncServe == "exp"
    lambda = 8;
    funcServe = @exprnd;
    vecParaServe = lambda;
elseif  whiFuncServe == "cons"
    cons = 10;
    funcServe = @(cons) cons;
    vecParaServe = cons;
end
% 3,  Begin `numSim`-Times Simulations
nEvent = nCustomer;
[b, sState] = simDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, vecParaArrive, vecParaServe);
plotLine([1:nEvent], [sState.nCustomerBlock], ...
    '2.png', "The Result of Number of Blocked Customers");
plotScatter([1:nEvent], [sState.nCustomerServe], ...
    '3.png', "The Result of Number of Customers being Served");
[bCap] = calErlangsFormula(lambda, mu, nServer);
plotLine([1:nEvent], [sState.b; ones(1, nEvent) * bCap], '4.png', "The Result of the Probability a Customer is Blocked");
matTimeDepart = [sState.vecTimeDepart];
% ######################################################################################################################
