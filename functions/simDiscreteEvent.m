% function file for exercise 4
% Author: Edward J. Xu, Sanaz
% Date: 190612
% ######################################################################################################################
function [b, sState] = simDiscreteEvent(clockSimZero, nServer, nEvent, funcArrive, funcServe, vecParaArrive, ...
    vecParaServe)
    % 1,  Initiate State Variables
    sState(1).inteEvent = funcArrive(vecParaArrive);
    sState(1).timeServe = funcServe(vecParaServe);
    sState(1).clockSim = clockSimZero + sState(1).inteEvent;
    [sState(1).nCustomerServe, sState(1).nCustomerBlock, sState(1).vecTimeDepart] = updateStateBlock( ...
        sState(1).clockSim, nServer, 0, 0, zeros(nServer, 1), sState(1).timeServe);
    sState(1).b = sState(1).nCustomerBlock / 1;
    % 2,  Begin Simulation
    for i = 2:nEvent
        % 2.1,  Next event happens: a new customer has arrived.
        sState(i).inteEvent = funcArrive(vecParaArrive);
        sState(i).timeServe = funcServe(vecParaServe);
        sState(i).clockSim = sState(i-1).clockSim + sState(i).inteEvent;
        % 2.2,  Evolution of State Variables
        [sState(i).nCustomerServe, sState(i).nCustomerBlock, sState(i).vecTimeDepart] = updateStateBlock( ...
            sState(i).clockSim, nServer, sState(i-1).nCustomerServe, sState(i-1).nCustomerBlock, ...
            sState(i-1).vecTimeDepart, sState(i).timeServe);
        sState(i).b = sState(i).nCustomerBlock / i;
    end
    b = sState(nEvent).b;
end
