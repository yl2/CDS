## CDS.R test case for Xerox corporation

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-22"),
##                      maturity = "5Y",
##                     contract ="SNAC",
##                     parSpread = round(105.8, digits=1),
##                     upfront = round(18624, digits=-4),
##                      IRDV01 = round(-7.36, digits=0),
##                      price = 99.72,
##                      principal = round(28068, digits=-3),
##                      RecRisk01 = round(-20.85, digits=-3),
##                      defaultExpo = round(5971932, digits=-3),
##                      spreadDV01 = round(4825.49, digits=0),
##                      currency = "USD",
##                      ptsUpfront = round(0.0028, digits=2),
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-21"),
##                      coupon = 100,
##                      recoveryRate = 0.40,
##                      defaultProb = round(0.0880, digits=2),
##                     notional = 1e7)

## save(truth1, file = "CDS.Xerox.test.RData")

load("CDS.Xerox.test.RData")
result1 <- CDS(TDate = "2014-04-22",
               maturity = "5Y", 
               parSpread = 105.8,
               coupon = 100,
               recoveryRate = 0.4,
               isPriceClean = FALSE,
               notional = 1e7)
stopifnot(all.equal(truth1, CDSdf(result1)))
