## CDS.R test case for Chorus Ltd. (Australian company)

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                      maturity = "5Y",
##                     contract ="SNZC",
##                      parSpread = round(243.28, digits=2),
##                     upfront = round(650580, digits=-4),
##                      IRDV01 = round(-169.33, digits=0),
##                      price = 93.42,
##                      principal = round(658080, digits=-3),
##                      RecRisk01 = round(-1106.34, digits=-3),
##                      defaultExpo = round(5341920, digits=-3),
##                      spreadDV01 = round(4317.54, digits=0),
##                      currency = "USD",
##                      ptsUpfront = round(0.065808, digits=2),
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-14"),
##                      coupon = 100,
##                      recoveryRate = 0.40,
##                      defaultProb = round(0.1915, digits=2),
##                      notional = 1e7)

## save(truth1, file = "CDS.Chorus.test.RData")

load("CDS.Chorus.test.RData")
result1 <- CDS(TDate = "2014-04-15",
               maturity = "5Y",
               contract ="SNZC",
               parSpread = 243.28,
               currency = "USD",
               coupon = 100,
               recoveryRate = 0.40,
               isPriceClean = FALSE,
               notional = 1e7)
stopifnot(all.equal(truth1, CDSdf(result1)))
