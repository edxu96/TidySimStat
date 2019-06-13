function [b] = calCount2(i, j, aCap_1, aCap_2)
    b = aCap_1^i / factorial(i) * aCap_2^j / factorial(j);
end
