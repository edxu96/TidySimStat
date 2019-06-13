function [ matTransi ] = function( m, lambda, mu )
    matTransi = zeros(m + 1);
    matTransi
    for i = 2:(m + 1)
        matTransi(i, i + 1) = lambda / lambda + i * mu;
        matTransi(i, i - 1) = i * mu / lambda + i * mu;
    end

end  % function
