% 190606
function [vecResult, vecProb] = getRngLcg(mCap, a, c, x0)
    % c -> b, mCap >- c
    vecResult = zeros(mCap, 1);
    vecProb = zeros(mCap, 1);
    vecResult(1) = rem(a * x0 + c, mCap);
    for i = 2:mCap
        vecResult(i) = rem(a * vecResult(i-1) + c, mCap);
    end
    vecProb = vecResult / mCap;
end
