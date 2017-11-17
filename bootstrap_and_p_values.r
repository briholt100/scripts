#Fropm:https://github.com/bcaffo/courses/blob/master/06_StatisticalInference/13_Resampling/Bootstrapping.pdf

library(UsingR)
data(father.son)
x <- father.son$sheight
n <- length(x)
theta <- median(x)
jk <- sapply(1:n, function(i) median(x[-i]))
thetaBar <- mean(jk)
biasEst <- (n - 1) * (thetaBar - theta)
seEst <- sqrt((n - 1) * mean((jk - thetaBar)^2))

B <- 1000
resamples <- matrix(sample(x, n * B, replace = TRUE), B, n)
medians <- apply(resamples, 1, median)
sd(medians)


quantile(medians, c(0.025, 0.975))



data(InsectSprays)
boxplot(count ~ spray, data = InsectSprays)

subdata <- InsectSprays[InsectSprays$spray %in% c("B", "C"), ]
y <- subdata$count
group <- as.character(subdata$spray)
testStat <- function(w, g) mean(w[g == "B"]) - mean(w[g == "C"])
observedStat <- testStat(y, group)
permutations <- sapply(1:10000, function(i) testStat(y, sample(group)))
observedStat

mean(permutations > observedStat)


##I'd like to play around witha  t-test to recreate a p-value and to compare it to the above.
with(InsectSprays,t.test(count[spray=='D']),count[spray=='E'])

#his vid on p-values
https://www.youtube.com/watch?v=Ky68x_7iK6c