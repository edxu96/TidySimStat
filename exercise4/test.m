% Test the functions for exercise 4
% Author: Edward J. Xu
% Date: 190611
% Version: 1.0
% ######################################################################################################################
% 1,  Test if the simulation works well
nServer = 10;
nCustomer = 10000;  % 10000;
lambda = 15;
mu = 1;
numSim = 10;
[b, sState] = startSim(nServer, nCustomer, lambda, mu);
plotLine([1:length([sState.nCustomerBlock])], [sState.nCustomerBlock], ...
    '2.png', "The Result of Number of Blocked Customers");
plotScatter([1:length([sState.nCustomerServe])], [sState.nCustomerServe], ...
    '3.png', "The Result of Number of Customers being Served");
% ######################################################################################################################
