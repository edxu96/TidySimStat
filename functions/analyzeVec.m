

function analyzeVec(vecResult, strResult)
    fprintf(['Analysis of ' strResult ': \n'])
    fprintf('    mean = %f ; \n', mean(vecResult))
    fprintf('    variance = %f ; \n', var(vecResult))
    calInterConf(vecResult, 0.05);
end
