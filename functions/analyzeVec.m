

function analyzeVec(vecResult, strResult)
    fprintf('--------------------------------------------------------------------------------\n');
    fprintf(['Analysis of ' strResult ': \n'])
    fprintf('    mean = %f ; \n', mean(vecResult))
    fprintf('    median = %f ; \n', median(vecResult))
    fprintf('    variance = %f ; \n', var(vecResult))
    calInterConf(vecResult, 0.05);
end
