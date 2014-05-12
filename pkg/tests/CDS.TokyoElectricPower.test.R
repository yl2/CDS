## CDS.R test case for Tokyo Electric Power Co. Inc.

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                     maturity = "5Y",
##                     contract ="STEC",
##                     parSpread = round(250.00, digits=2),
##                     upfront = round(701502, digits=-4),
##                     IRDV01 = round(-184.69, digits=0),
##                     price = 92.91,
##                     principal = round(709002, digits=-3),
##                     RecRisk01 = round(-1061.74, digits=-3),
##                     defaultExpo = round(5790998, digits=-3),
##                     spreadDV01 = round(4448.92, digits=0),
##                     currency = "JPY",
##                     ptsUpfront = round(0.0709, digits=2),
##                     freqCDS = "Q",
##                     pencouponDate = as.Date("2019-03-20"),
##                     backstopDate = as.Date("2014-02-14"),
##                     coupon = 100,
##                     recoveryRate = 0.35,
##                     defaultProb = round(0.1830, digits=2),
##                     notional = 1e7)

## save(truth1, file = "CDS.TokyoElectricPower.test.RData")

load("CDS.TokyoElectricPower.test.RData")
result1 <- CDS(TDate = "2014-04-15",
               maturity = "5Y",
               contract ="STEC",
               parSpread = 250,
               currency = "JPY",
               coupon = 100,
               recoveryRate = 0.35,
               isPriceClean = FALSE,
               notional = 1e7)
stopifnot(all.equal(truth1, CDSdf(result1)))
