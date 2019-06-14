% function file for exercise 7
% Author: Edward J. Xu
% Date: 190614
% ######################################################################################################################


function [count] = getCountAnnealing(vector, k, matCost)
    temp = calTemp(k);
    energy = calEnergy(vector, matCost);
    count = exp(- energy / temp);
end


function [temp] = calTemp(k)
    temp = 1 / sqrt(1 + k);
end
