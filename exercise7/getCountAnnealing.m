% function file for exercise 7
% Author: Edward J. Xu
% Date: 190614
% ######################################################################################################################


function [count] = getCountAnnealing(vector, k, matCost)
    temp = calTemp(k);
    energy = calEnergy(vector, matCost)
    count = exp(- energy / temp);
end


function [energy] = calEnergy(vector, matCost)
    energy = matCost(vector(1), vector(2));
    for i = 2:length(vector)
        energy = matCost(vector(i - 1), vector(i));
    end
end


function [temp] = calTemp(k)
    temp = 1 / sqrt(1 + k);
end
