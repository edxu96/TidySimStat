% function file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190611
% Version: 2.0
% ######################################################################################################################
function [b, sState] = simDiscreteEvent(nServer, nEvent, funcArrive, funcServe, vecParaArrive, ...
    vecParaServe)
    % 1,  Initiate State Variables
    vecTimeDepart = zeros(nServer, 1);
    nCustomerBlock = 0;
    clockSim = 0;
    nCustomerServe = 0;
    % 2,  Begin Simulation
    for i = 1:nEvent
        % 2.1,  Next event happens: a new customer has arrived.
        sState(i).intervalSim = funcArrive(vecParaArrive);  % non- state variable can be stored immediately.
        clockSim = clockSim + sState(i).intervalSim;
        % 2.2,  Evolution of State Variables
        [nCustomerServe, nCustomerBlock, vecTimeDepart] = updateStateBlock(clockSim, nServer, nCustomerServe, ...
            nCustomerBlock, vecTimeDepart, funcServe, vecParaServe);
        % 2.3,  Store the result of state variables
        sState(i).clockSim  = clockSim;
        sState(i).vecTimeDepart = vecTimeDepart;
        sState(i).nCustomerBlock = nCustomerBlock;
        sState(i).nCustomerServe = nCustomerServe;
        sState(i).b = nCustomerBlock / i;
    end
    b = sState(nEvent).b;
end
