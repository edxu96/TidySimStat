
function [ b, nCustomerBlock, vecNumCustomerServe ] = startSim( nServer, nCustomer, lambda, mu )
% Function to simulate the block system
%     :param offeredTraffic: offered traffic = lambda / mu
%     :param n: number of servers
    % Data storage
    vecNumCustomerServe = zeros(nCustomer, 1);
    %
    vecTimeDepart = zeros(nServer, 1);
    nCustomerBlock = 0;
    clockSim = 0;
    nCustomerServe = 0;
    for i = 1:nCustomer
        % Next customer arrive
        timeArriveInterval = exprnd(mu);
        nCustomerServe = nCustomerServe + 1;
        % Check the departed customers
        for j = 1:nServer
            if vecTimeDepart(j) > clockSim  % there is some customer
                if clockSim + timeArriveInterval >= vecTimeDepart(j)
                    vecTimeDepart(j) == clockSim + timeArriveInterval;
                    nCustomerServe = nCustomerServe - 1;
                end
            elseif vecTimeDepart(j) == clockSim  % there is no customer
                vecTimeDepart(j) = clockSim + timeArriveInterval;
            end
        end
        clockSim = clockSim + timeArriveInterval;
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
