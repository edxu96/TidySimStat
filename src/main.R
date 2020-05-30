
1 - pchisq(2.46, 6)



library(randtests)
## Example 1
## Data from example in Brownlee (1965), p. 223.
## Results of 23 determinations, ordered in time, of the density of the earth.
##
earthden <- c(5.36, 5.29, 5.58, 5.65, 5.57, 5.53, 5.62, 5.29, 5.44, 5.34, 5.79,
              5.10, 5.27, 5.39, 5.42, 5.47, 5.63, 5.34, 5.46, 5.30, 5.75, 5.68, 5.85)
runs.test(earthden)

test <- runif(200)
runs.test(test)

1 - pchisq(3, 1)

2 * (1 - pnorm(-1.7477, 0, 1))



##
## Example 2
## Sweet potato yield per acre, harvested in the United States, between 1868 and 1937.
## Data available in this package.
##
data(sweetpotato)
runs.test(sweetpotato$yield)
