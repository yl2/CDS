## CDS.R test case for Electrolux AB corporation

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-22"),
##                      maturity = "5Y",
##                      contract ="STEC",
##                      parSpread = 99,
##                      upfront = round(-14368, digits=-4),
##                      IRDV01 = round(1.29, digits=0),
##                      price = 100.05,
##                      principal = round(-4924, digits=-3),
##                      RecRisk01 = round(3.46, digits=-3),
##                      defaultExpo = round(6004924, digits=-3),
##                      spreadDV01 = round(4923.93, digits=0),
##                      currency = "EUR",
##                      ptsUpfront = round(-0.00049239, digits=2),
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-21"),
##                      coupon = 100,
##                      recoveryRate = 0.40,
##                      defaultProb = round(0.0827, digits=2),
##                      notional = 1e7)

## save(truth1, file = "CDS.ElectroluxAB.test.RData")

load("CDS.ElectroluxAB.test.RData")
result1 <- CDS(TDate = "2014-04-22",
               maturity = "5Y", 
               parSpread = 99,
               contract ="STEC",
               currency="EUR",
               coupon = 100,
               recoveryRate = 0.4,
               isPriceClean = FALSE,
               notional = 1e7)
stopifnot(all.equal(truth1, CDSdf(result1)))
