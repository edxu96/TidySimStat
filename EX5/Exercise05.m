%% Exercise 5

% The integral is given by: integral(exp(x),0,1)
clear, clc            % Clear
rng('default')        % Generate same random numbers
n = 100;              % Samples
U = rand(1,n);        % Random number from a uniform distribution
true_mean = exp(1)-1; % True mean

% Estimate the integral by simulation (the crude Monte Carlo estimator).
X = exp(U);
mean_X = sum(X)/n;
var_X = sum(X.^2)/n-(sum(X)/n).^2;
CI_X = conf(X);

% Estimate the integral using antithetic variables
Y = (exp(U)+exp(1-U))/2;
mean_Y = sum(Y)/n;
mean_eUe1U = sum(exp(U).*exp(1-U))/n;
mean_eU = sum(exp(U))/n;
mean_e1U = sum(exp(1-U))/n;
cov_eUe1U = mean_eUe1U-mean_eU.*mean_e1U;
var_eU = sum(exp(U).^2)/n-(sum(exp(U))/n).^2;
var_e1U = sum(exp(1-U).^2)/n-(sum(exp(1-U))/n).^2;
var_Y = 1/4*var_eU+1/4*var_e1U+2*1/4*cov_eUe1U;
CI_Y = conf(Y);

% Estimate the integral using a control variable
mean_UeU = sum(U.*exp(U))/n;
mean_U = sum(U)/n;
mean_eU = sum(exp(U))/n;
cov_UeU = mean_UeU-mean_U.*mean_eU;
var_U = sum(U.^2)/n-(sum(U)/n).^2;
var_eU = sum(exp(U).^2)/n-(sum(exp(U))/n).^2;
c = -cov_UeU/var_U;
Z = (exp(U)+c*(U-1/2));
mean_Z = sum(exp(U)+c*(U-1/2))/n;
var_Z = var_eU-cov_UeU.^2/var_U;
CI_Z = conf(Z);

% Estimate the integral using stratified sampling
for k = 1:(n/10)
    for i = 1:10
        tl(i) = exp(((i-1)/10)+rand/10);
    end
    W(k) = sum(tl)/10;
end
mean_W = sum(W)/k;
var_W = sum(W.^2)/k-(sum(W)/k).^2;
CI_W = conf(W);

table([true_mean;0;NaN;NaN],[mean_X;var_X;CI_X(1);CI_X(2)],[mean_Y;var_Y;CI_Y(1);CI_Y(2)],...
    [mean_Z;var_Z;CI_Z(1);CI_Z(2)],[mean_W;var_W;CI_W(1);CI_W(2)],...
    'RowNames', {'Mean','Var','CI_lower','CI_upper'},'VariableNames', {'True','X','Y','Z','W'})

% Use control variates to reduce the variance of the estimator in
% exercise 4 (Poisson arrivals).

% This is the function BlockingSystem_VarRed