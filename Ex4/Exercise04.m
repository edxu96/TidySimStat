%% Exercise 4

% Write a discrete event simulation program for a blocking system, i.e. a
% system with n service units and no waiting room

clear,clc      % Clear
rng('default') % Generate same random numbers
n = 10;        % Service units
s = 8;         % Mean service time
l = 1;         % Mean time between customers
c = 10000;     % Customers
ite = 10;      % Simulate 10 runs

BS_t = ErlangsB(n,s,l);
[BS_s,CI_s] = BlockingSystem(n,s,l,c,ite);

% Substitute the arrival process with a renewal process

% Erlang distributed inter arrival times
[BS_e,CI_e] = BlockingSystem_Erlang(n,s,l,c,ite);

% Hyper exponential inter arrival times
[BS_h,CI_h] = BlockingSystem_Hyper(n,s,l,c,ite);

% Constant service time
[BS_c,CI_c] = BlockingSystem_Constant(n,s,l,c,ite);

% Pareto distributed service times
[BS_p,CI_p] = BlockingSystem_Pareto(n,s,l,c,ite);

% Distribution of choice that only takes non-negative values (rand)
[BS_vr,CI_vr] = BlockingSystem_VarRed(n,s,l,c,ite);

table([BS_t;NaN;NaN],[BS_s;CI_s(1);CI_s(2)],[BS_e;CI_e(1);CI_e(2)],[BS_h;CI_h(1);CI_h(2)],...
    [BS_c;CI_c(1);CI_c(2)],[BS_p;CI_p(1);CI_p(2)],[BS_vr;CI_vr(1);CI_vr(2)],...
    'RowNames', {'BS','CI_lower','CI_upper'},'VariableNames', {'t','s','e','h','c','p','vr'})