
function [ b ] = startSim( offeredTraffic, nServer, nCustomer, lambda, mu )
% Function to simulate the block system
%     :param offeredTraffic: offered traffic = lambda / mu
%     :param n: number of servers
    vecTimeDepart = ones(nServer, 1);
    nCustomerBlock = 0;
    clockSim = 0;
    nCustomerServe = 0;
    while i = 1:nCustomer
        % Next customer arrive
        clockSim = clockSim + exprnd(mu);
        nCustomerServe = nCustomerServe + 1;
        % Check the departed customers
        for j = 1:nServe
            if clockSim >= vecTimeDepart(j)
                vecTimeDepart(j) == clockSim;
                nCustomerServe = nCustomerServe - 1;
            end
        end
        % Check if blocked
        if nCustomerServe > nServer
            nCustomerBlock = nCustomerBlock + (nCustomerServe - nServer);
        else
            j = 1;
            while vecTimeDepart(j) != clockSim
                j = j + 1;
            end
            vecTimeDepart(j) = clockSim + exprnd(lambda);
        end
    end
    b = nCustomerBlock / nCustomer;
end  % function
