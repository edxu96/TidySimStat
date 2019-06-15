function [x] = simDistPareto(u, vecPara)
% vecPara = [beta, k];
    beta = vecPara(1);
    k = vecPara(2);
    xRaw = beta * (u^(- 1 / k) - 1);
    x = xRaw + beta;
end
