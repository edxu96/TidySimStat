% setup file for exercise 5
% Author: Edward J. Xu
% Date: 190615
% ######################################################################################################################


function doExercise_5()
    % whiFunc = 'exp';
    % whiFunc = 'antithetic';
    % whiFunc = 'control';
    whiFunc = 'stratified';
    nSample = 10000;
    fprintf('#### Begin #####################################################################');  % ####################
    fprintf('Analytical Result: %f.\n', exp(1) - 1);
    vecU = rand(nSample, 1);
    tic
    [funcSim, vecU] = getFunc(whiFunc, vecU);
    vecResult = sampleFuncSim(nSample, funcSim, vecU);
    fprintf('mean = %f.\n', mean(vecResult));
    fprintf('var = %f.\n', var(vecResult));
    toc
    fprintf('#### End #######################################################################');  % ####################
end


function [funcSim, vecU] = getFunc(whiFunc, vecU)
% To get the function
    fprintf('Method: %s.\n', whiFunc);
    if whiFunc == 'exp'
        funcSim = @exp;
    elseif whiFunc == 'antithetic'
        funcSim = @(u) (exp(u) + exp(1-u)) / 2;
    elseif whiFunc == 'control'
        c = - (mean(vecU .* exp(vecU)) - mean(vecU) * mean(exp(vecU))) / var(vecU);
        funcSim = @(u) exp(u) + c * (u - mean(vecU));
    elseif whiFunc == 'stratified'
        matU = rand(length(vecU), 10);
        for i = 1:length(matU(:, 1))
            w_i = 0;
            for j = 1:10
                w_i = w_i + exp((j - 1 + matU(i, j)) / 10);
            end
            vecU(i) = w_i / 10;
        end
        funcSim = @(w) w;
    end
end


function [vecResult] = sampleFuncSim(nSample, funcSim, vecU)
% To sample using the function
    vecResult = zeros(nSample, 1);
    for i = 1:nSample
        vecResult(i) = funcSim(vecU(i));
    end
end


function [vecResult] = sampleStratify(nSample, funcSim, vecU)
% To stratified sample using the function
    vecResult = zeros(nSample, 1);
    for i = 1:nSample
        vecResult(i) = funcSim(vecU(i), i, nSample);
    end
end
