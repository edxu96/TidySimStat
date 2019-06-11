
function [ b, nCustomerBlock, vecNumCustomerServe ] = startSim( nServer, nCustomer, lambda, mu )
% Function to simulate the block system
%     :param offeredTraffic: offered traffic = lambda / mu
%     :param n: number of servers
    vecTimeDepart = ones(nServer, 1);
    nCustomerBlock = 0;
    clockSim = 0;
    nCustomerServe = 0;
    vecNumCustomerServe = zeros(nCustomer, 1);
    for i = 1:nCustomer
        % Next customer arrive
        clockSim = clockSim + exprnd(mu);
        nCustomerServe = nCustomerServe + 1;
        % Check the departed customers
        for j = 1:nServer
            if clockSim >= vecTimeDepart(j)
                vecTimeDepart(j) == clockSim;
                nCustomerServe = nCustomerServe - 1;
            end
        end
        % Check if blocked
        if nCustomerServe > nServer
            nCustomerBlock = nCustomerBlock + (nCustomerServe - nServer);
        else
            for j = 1:nServer
                if vecTimeDepart(j) == clockSim
                    vecTimeDepart(j) = clockSim + exprnd(lambda);
                end
            end
        end
        vecNumCustomerServe(i) = nCustomerServe;
    end
    b = nCustomerBlock / nCustomer;
end  % function
