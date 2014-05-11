## CDS.R test case for Caesars Entertainment Operating Co Inc

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##              maturity = "5Y",
##              contract ="SNAC",
##              parSpread = round(12354.53, digits=2),
##              upfront = round(5707438, digits=-4),
##              IRDV01 = round(-271.18, digits=0),
##              price = 42.55,
##              principal = round(5744938, digits=-3),
##              RecRisk01 = round(-95430.32, digits=-3),
##              defaultExpo = round(255062, digits=-3),
##              spreadDV01 = round(21.15, digits=0),
##              currency = "USD",
##              ptsUpfront = round(0.5745, digits=2),
##              freqCDS = "Q",
##              pencouponDate = as.Date("2019-03-20"),
##              backstopDate = as.Date("2014-02-14"),
##              coupon = 500,
##              recoveryRate = 0.40,
##              defaultProb = round(0.99998, digits=2),
##              notional = 1e7)

## save(truth1, file = "CDS.CaesarsEntCorp.test.RData")

load("CDS.CaesarsEntCorp.test.RData")

result1 <- CDS(TDate = "2014-04-15",
               maturity = "5Y",
               parSpread = 12354.529,
               currency = "USD",
               coupon = 500,
               recoveryRate = 0.40,
               isPriceClean = FALSE,
               notional = 1e7)

stopifnot(all.equal(truth1, CDSdf(result1)))
