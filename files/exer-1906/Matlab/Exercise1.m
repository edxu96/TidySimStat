%%
clear;
clc;
close all;
p = 10;         % classes
n = 10000;      
M = 16;         % modulus
a = 5;          % multiplier
c = 1;          % shift

x=zeros(1,n);  
U=zeros(1,n);

for i = 2:n
    x(:,i) = mod(a*x(:,i-1)+c,M);
    U(:,i) = x(:,i)/M;
end

rng default;
y = rand(n,1);  

%% 
% Histogram
figure(1)
subplot(2,1,1);
histogram(U,p);
title('Histogram of U_i');xlabel('U_i'); ylabel('Number of Occurances');

subplot(2,1,2);
histogram(y,p);
title('Histogram of y');xlabel('y'); ylabel('Number of Occurances');

% Scatter plot
figure(2)
subplot(2,1,1);
scatter(U(2:end),U(1:end-1));
title('Scatter plot of U_i'); xlabel('U_i(2:n-1)'); ylabel('U_i(1:n-1)');

subplot(2,1,2);
scatter(y(2:end),y(1:end-1));
title('Scatter plot of y'); xlabel('y(2:n-1)'); ylabel('y(1:n-1)');

% X^2
n_obs_U = hist(U,p);
n_obs_y = hist(y,p);
n_exp = n*ones(1,p)/p;
T_U = 0;
T_y = 0;

for i = 1:p
    T_U = (((n_obs_U(i)-n_exp(i))^2)/n_exp(i))+T_U;
    T_y = (((n_obs_y(i)-n_exp(i))^2)/n_exp(i))+T_y;
end

h_U = 1-chi2cdf(T_U,p-1);
h_y = 1-chi2cdf(T_y,p-1);

% Kolmogorov-Smirnov (KS)
U_s = sort(U);
U_u = unique(U_s);

ks=zeros(1,M);
for i = 1:M
    ks(i) = max(norm(U_s - U_u(i)));
end

ECDF = ks/n;
figure(3);
cdfplot(U);
hold on
cdfplot(y);
hold off
title('Kolmogorov Smirnov Test'); xlabel('U_i'); ylabel('Cumulative Probability')
legend('ECDF', 'Normal CDF')

% Run-tests
m_true = 0.5;
n1 = 0;
n2 = 0;
k = 0;
l = 0;

for i = 1:n
    if U(i) < m_true
        k = 0;
        if l == 0
            n2 = n2+1;
        end
        l = 1;
    else
        l = 0;
        if k == 0
            n1 = n1+1;
        end
        k = 1;
    end 
end

N = [2*((n1*n2)/(n1+n2)),(2*n1*n2*(2*n1*n2-n1-n2))/(((n1+n2)^2)*(n1+n2-1))];

ConInt = N(1)+tinv([0.025 0.975],n-1)*sqrt(N(2));

if (ConInt(1) < n1 && n1 < ConInt(2)) && (ConInt(1) < n2 && n2 < ConInt(2))
    p = 1; % Accept
else
    p = 0; % Reject
end

% Correlation test
h=0;
for i = 1:n
    ch(i) = 1/(n-h)*U(i)*U(i+h);
end