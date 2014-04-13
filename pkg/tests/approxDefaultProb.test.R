## approxDefaultProb.test.R

library(CDS)

## truth <- approxDefaultProb(parSpread = 32, t = 5.25, recoveryRate = 0.4)

## save(truth, file = "approxDefaultProb.test.RData")

load("approxDefaultProb.test.RData")

result <- approxDefaultProb(parSpread = 32, t = 5.25, recoveryRate = 0.4)

stopifnot(all.equal(result, truth))
