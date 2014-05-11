## CDS.R test case for Toys R Us Inc

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                      maturity = "5Y",
##                      contract ="SNAC",
##                      parSpread = round(1737.7289, digits=2),
##                      upfront = round(3237500, digits=-4),
##                      IRDV01 = round(-648.12, digits=0),
##                      price = 67.25,
##                      principal = round(3275000, digits=-3),
##                      RecRisk01 = round(-30848.67, digits=-3),
##                      defaultExpo = round(2725000, digits=-3),
##                      spreadDV01 = round(1580.31, digits=0),
##                      currency = "USD",
##                      ptsUpfront = round(0.3275, digits=2),
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-14"),
##                      coupon = 500,
##                      recoveryRate = 0.40,
##                      defaultProb = round(0.7813, digits=2),
##                      notional = 1e7)

## save(truth1, file = "CDS.ToysRUs.test.RData")

load("CDS.ToysRUs.test.RData")
result1 <- CDS(TDate = "2014-04-15",
               maturity = "5Y",
               contract="SNAC",
               parSpread = 1737.7289,
               currency = "USD",
               coupon = 500,
               recoveryRate = 0.40,
               isPriceClean = FALSE,
               notional = 1e7)
stopifnot(all.equal(truth1, CDSdf(result1)))
