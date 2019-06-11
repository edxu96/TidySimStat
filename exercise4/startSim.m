
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
        clockSimPre = clockSim;
        clockSim = clockSim + exprnd(mu);
        % clockSim = clockSim + gamrnd(nServer, 1 / nServer);
        nCustomerServe = nCustomerServe + 1;
        % Check the departed customers
        for j = 1:nServer
            if vecTimeDepart(j) > clockSimPre  % there is a customer
                if vecTimeDepart(j) < clockSim
                    vecTimeDepart(j) = clockSim;
                    nCustomerServe = nCustomerServe - 1;
                end
            elseif vecTimeDepart(j) == clockSimPre  % there is no customer
                vecTimeDepart(j) = clockSim;
            end
        end
        % Check if there is a block
        % disp(nCustomerServe)
        % disp(clockSim)
        % disp(vecTimeDepart)
        if nCustomerServe > nServer
            nCustomerBlock = nCustomerBlock + (nCustomerServe - nServer);
            nCustomerServe = nServer;
        else
            % Select the first server without a customer, assign a customer to it.
            j = 1;
            while vecTimeDepart(j) ~= clockSim
                j = j + 1;
            end
            % Set the service time
            vecTimeDepart(j) = clockSim + exprnd(lambda);
            % vecTimeDepart(j) = clockSim + 10;
        end
        vecNumCustomerServe(i) = nCustomerServe;
    end
    b = nCustomerBlock / nCustomer;
end  % function
