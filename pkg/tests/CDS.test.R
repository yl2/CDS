## CDS.R test case

library(CDS)

## truth1 <- CDS(TDate = "2014-01-14",
##               maturity = "5Y",
##               parSpread = 32,
##               couponRate = 100,
##               recoveryRate = 0.4,
##               isPriceClean = FALSE,
##               notional = 1e7)

## save(truth1, file = "CDS.test.RData")

load("CDS.test.RData")
result1 <- CDS(TDate = "2014-01-14",
               maturity = "5Y",
               parSpread = 32,
               couponRate = 100,
               recoveryRate = 0.4,
               isPriceClean = FALSE,
               notional = 1e7)
stopifnot(all.equal(truth1, result1))

