% function file for exercise 7
% Author: Edward J. Xu
% Date: 190614
% ######################################################################################################################


function [count] = getCountAnnealing(vecXcap, k, matCost)
    temp = calTemp(k);
    energy = calEnergy(vecXcap, matCost)
    count = exp(- energy / temp);
end


function [energy] = calEnergy(vecXcap, matCost)
    energy = matCost(vecXcap(1), vecXcap(2));
    for i = 2:length(vecXcap)
        energy = matCost(vecXcap(i - 1), vecXcap(i));
    end
end


function [temp] = calTemp(k)
    temp = 1 / sqrt(1 + k);
end
