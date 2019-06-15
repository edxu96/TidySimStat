% function file for exercise 7
% Author: Edward J. Xu
% Date: 190614
% ######################################################################################################################


function [energy] = calEnergy(vector, matCost)
    energy = matCost(vector(1), vector(2));
    for i = 2:length(vector)
        energy = energy + matCost(vector(i - 1), vector(i));
    end
end
