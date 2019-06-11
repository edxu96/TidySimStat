
function [ b ] = startSim( offeredTraffic, nServer, nCustomer, lambda, mu )
% Function to simulate the block system
%     :param offeredTraffic: offered traffic = lambda / mu
%     :param n: number of servers
    vecTimeDepart = ones(nServer, 1)
    nCustomerBlock = 0;
    clockSim = 0;
    nCustomerServe = 0;
    while i = 1:nCustomer
        % Next customer arrive
        clockSim = clockSim + exprnd(mu);
        nCustomerServe = nCustomerServe + 1;
        % Check the departed customers
        nCustomerDepart = 0;
        for j = 1:nServe
            if clockSim >= vecTimeDepart(j)
                vecTimeDepart(j) == 1;
                nCustomerDepart = nCustomerDepart + 1;
            end
        end
        % Check if blocked
        if nCustomerServe - nCustomerDepart > nServer
            nCustomerBlock = nCustomerBlock + 1;
            for j = 1:nServer
                vecTimeDepart(j) = vecTimeDepart(j) + exprnd(lambda);
            end
        end
    end
    b = nCustomerBlock / nCustomer;
end  % function
