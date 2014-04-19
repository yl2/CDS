## defaultProb.test.R

library(CDS)

## truth <- defaultProb(parSpread = 32, t = 5.25, recoveryRate = 0.4)

## save(truth, file = "defaultProb.test.RData")

load("defaultProb.test.RData")

result <- defaultProb(parSpread = 32, t = 5.25, recoveryRate = 0.4)

stopifnot(all.equal(result, truth))
