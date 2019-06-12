function [vecX] = distExp(vecU, lambda)
    numU = length(vecU);
    vecX = zeros(numU, 1);
    for i = 1:numU
        vecX(i) = - log(vecU(i)) / lambda;
    end
end
