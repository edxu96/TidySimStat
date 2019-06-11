
function [ b ] = startSim( offeredTraffic, nServer, nCustomer )
% Function to simulate the block system
%     :param offeredTraffic: offered traffic = lambda / mu
%     :param n: number of servers
    exppdf(vecXstd, 1 / lambda);
    nCustomerBlock = 0;
    for i = 1:nCustomer

        
        nCustomerBlock = nCustomerBlock + 1
    end
    b = nCustomerBlock / nCustomer;
end  % function
