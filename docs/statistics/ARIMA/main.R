## for: GitHub/edxu96/TidySimStat/examples/ARIMA
## Edward J. Xu
## April 23, 2020

#### Frequency Domain ####

library(astsa)

x1 = 2*cos(2*pi*1:100*6/100) + 3*sin(2*pi*1:100*6/100) 
x2 = 4*cos(2*pi*1:100*10/100) + 5*sin(2*pi*1:100*10/100) 
x3 = 6*cos(2*pi*1:100*40/100) + 7*sin(2*pi*1:100*40/100) 
x =x1+x2+x3

par(mfrow=c(2,2))
plot.ts(x1, ylim=c(-10,10), main=expression(omega==6/100~~~A^2==13)) 
plot.ts(x2, ylim=c(-10,10), main=expression(omega==10/100~~~A^2==41)) 
plot.ts(x3, ylim=c(-10,10), main=expression(omega==40/100~~~A^2==85)) 
plot.ts(x, ylim=c(-16,16), main="sum")

P = Mod(2 * fft(x) / 100)^2;  
Fr = 0:99/100
plot(Fr, P, type="o", xlab="frequency", ylab="scaled periodogram")

set.seed(90210) # so you can reproduce these results 
x = 2*cos(2*pi*1:500/50 + .6*pi) + rnorm(500,0,5)
z1 = cos(2*pi*1:500/50)
z2 = sin(2*pi*1:500/50)
summary(fit <- lm(x~0+z1+z2)) # zero to exclude the intercept 
par(mfrow=c(2,1))
plot.ts(x)
plot.ts(x, col=8, ylab=expression(hat(x))) 
lines(fitted(fit), col=2)



n = 1000
x = arima.sim(list(order = c(2, 0, 1), ar = c(1, -.9), ma = .8), n=n)
P = Mod(2 * fft(x) / n)^2;  
Fr = 0:(n-1) / n
plot(Fr[1:(.5 * n)], P[1:(.5 * n)], type="o", xlab="frequency", ylab="scaled periodogram")

arma.spec(ar = c(1, -.9), ma = .8)
