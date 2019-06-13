function [matTransi] = getTransiMatrix(m, lambda, mu)
    matTransi = zeros(m + 1);  % the index starts from 0
    matTransi(1, 2) = 1;
    for i = 1:m - 1
        matTransi(i + 1, i + 2) = lambda / (lambda + i * mu);
        matTransi(i + 1, i) = 1 - matTransi(i + 1, i + 2);  % i * mu / lambda + i * mu;
    end
    matTransi(m + 1, m) = 1;
    vecCheck = false(m + 1, 1);
    for i = 1:(m + 1)
        vecCheck(i) = (sum(matTransi(i, :)) == 1);
    end
    fprintf("Whether `matTransi` is correct? %s. \n", string(sum(vecCheck) == m + 1));
end  % function
