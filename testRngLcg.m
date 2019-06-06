function vecResult = testRngLcg(mCap, a, c, x0)
    % Test the simulated random number using many test
    % Example: mCap = 16; a = 5; c = 1; x0 = 3;
    %          vecResult = function(mCap, a, c, x0)
    % 1,  Generate the vector of random numbers using LCG
    [vecResult, vecProb] = getRngLcg(mCap, a, c, x0);
    vecResultNorm = vecResult / mCap;
    % 2,  Plot the histogram of normlized number using 0 as min and mCap as max
    figHist = figure("Visible", "off");
    figHist = histogram(vecResult, 'NumBins', 10, 'Normalization', 'probability');
    saveas(figHist, [pwd '/images/figHist.png']);
    vecProb10Class = figHist.Values;
    % 3,  Test
    
end
