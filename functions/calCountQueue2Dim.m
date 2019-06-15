function [b] = calCountQueue2Dim(i, j, aCap_1, aCap_2)
    b = aCap_1^i / factorial(i) * aCap_2^j / factorial(j);
end
