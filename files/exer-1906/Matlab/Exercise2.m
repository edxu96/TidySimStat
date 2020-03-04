clear;
clc;
close all;
rng default      
n = 10000;          
p = 0.1;            
U = rand(1,n);      
X = floor(log(U)/log(1-p))+1;

% Plot
figure(1)
plot(sort(X));
xlabel('Outcomes'); ylabel('Geometric Random Variable');


X = [1 2 3 4 5 6];                 
p = [7/48 5/48 1/8 1/16 1/4 5/16]; 
U = rand(1,n+1);                   
l = length(p); 

%% Direct (crude) method
CDF = zeros(1,l+1);
for i = 2:l+1
    CDF(:,i) = CDF(:,i-1)+p(i-1);
end

for i = 1:n
    for j = 2:l+1
        if U(i)<= CDF(:,j) && CDF(:,j-1)<U(i) 
            OUTD(i)=X(j-1);
        end
    end
end

%% Rejection method
q=1/l;
c = max(p)/q;
ex = 100;
OUTR = [];
while length(OUTR)<n
    OUTRt = OUTR;
    for i = 1:n
        I(i) = 1+floor(l*U(i));
        if U(i+1) < p(I(i))/c
            OUTR(i) = I(i);
        end
    end
    OUTR = OUTR(OUTR>0);
    OUTR = [OUTR OUTRt];
    U = rand(1,n+1);
end

%% Alias method
F = l*p;
L = 1:n;
G = find(F>=1);
S = find(F<=1);
j = 1;

while ~isempty(S)
    j = S(1);
    k = G(1);    
    L(j)= k;
    F(k) = F(k)-(1-F(j));
    if F(k)<1
        G(1) = [];
        S = [S k];
    end
    S(1) = [];
    j = j+1;
end

for i = 1:n
    I(i) = 1+floor(l*U(i));
    if U(i+1) < F(I(i))
        OUTA(i) = I(i);
    else
        OUTA(i) = L(I(i));
    end
end


% Plot
figure(2)
subplot(3,2,1)
plot(sort(OUTD));
title('Direct Method'); xlabel('Outcomes'); ylabel('Probability')
subplot(3,2,2);
histogram(OUTD,l);
title('Histogram of Direct Method'); xlabel('Number of bins'); ylabel('Outcomes')

subplot(3,2,3)
plot(sort(OUTR));
title('Rejection Method'); xlabel('Outcomes'); ylabel('Probability')
subplot(3,2,4);
histogram(OUTR,l);
title('Histogram of Rejection Method'); xlabel('Number of bins'); ylabel('Outcomes')

subplot(3,2,5)
plot(sort(OUTA));
title('Alias Method'); xlabel('Outcomes'); ylabel('Probability')
subplot(3,2,6);
histogram(OUTA,l);
title('Histogram of Alias Method'); xlabel('Number of bins'); ylabel('Outcomes')

table([chi2gof(OUTD);kstest(OUTD);runstest(OUTD);corrcoef(OUTD)],...
    [chi2gof(OUTR);kstest(OUTR);runstest(OUTR);corrcoef(OUTR)],...
    [chi2gof(OUTA);kstest(OUTA);runstest(OUTA);corrcoef(OUTA)],...
    'RowNames', {'chi2 Test','Kolmogorov-Smirnov Test','Run Test',...
    'Correlation Coefficient Test'},'VariableNames', {'OUTD','OUTR','OUTA'})