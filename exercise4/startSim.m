
function [ b ] = startSim( offeredTraffic, nServer, nCustomer )
% Function to simulate the block system
%     :param offeredTraffic: offered traffic = lambda / mu
%     :param n: number of servers
    exppdf(vecXstd, 1 / lambda);
    nCustomerBlock = 0;
    clockSim = 0;
    nCustomerServe = 0
    for i = 1:nCustomer
        nCustomerServe = nCustomerServe + 1
        clockSim = clockSim + exppdf(lambda)
        if nCustomerServe > nServer
            nCustomerBlock = nCustomerBlock + 1;
        end
    end
    b = nCustomerBlock / nCustomer;
end  % function
