function [energy] = calEnergy(vector, matCost)
    energy = matCost(vector(1), vector(2));
    for i = 2:length(vector)
        energy = matCost(vector(i - 1), vector(i));
    end
end
