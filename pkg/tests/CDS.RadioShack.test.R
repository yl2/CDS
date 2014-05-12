## CDS.R test case for RadioShack Corp

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                      maturity = "5Y",
##                      contract ="SNAC",
##                      parSpread = round(9106.8084, digits=2),
##                      upfront = round(5612324, digits=-4),
##                      IRDV01 = round(-361.62, digits=0),
##                      price = 43.5,
##                      principal = round(5649824, digits=-3),
##                      RecRisk01 = round(-93430.52, digits=-3),
##                      defaultExpo = round(350176, digits=-3),
##                      spreadDV01 = round(40.86, digits=0),
##                      currency = "USD",
##                      ptsUpfront = round(0.5649, digits=2),
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-14"),
##                      coupon = 500,
##                      recoveryRate = 0.40,
##                      defaultProb = round(0.9997, digits=2),
##                      notional = 1e7)

## save(truth1, file = "CDS.RadioShack.test.RData")

load("CDS.RadioShack.test.RData")
result1 <- CDS(TDate = "2014-04-15",
               maturity = "5Y",
               parSpread = 9106.8084,
               currency = "USD",
               coupon = 500,
               recoveryRate = 0.40,
               isPriceClean = FALSE,
               notional = 1e7)
stopifnot(all.equal(truth1, CDSdf(result1)))
