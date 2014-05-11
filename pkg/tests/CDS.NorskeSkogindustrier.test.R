## CDS.R test case for Norske Skogindustrier ASA (European company)

library(CDS)

## truth1 <- data.frame(TDate = as.Date("2014-04-15"),
##                      maturity = "5Y",
##                      contract ="STEC",
##                      parSpread = round(2785.8889, digits=2),
##                      upfront = round(4412500, digits=-4),
##                      IRDV01 = round(-729.47, digits=0),
##                      price = 55.5,
##                      principal = round(4450000, digits=-3),
##                      RecRisk01 = round(-56513.77, digits=-3),
##                      defaultExpo = round(1550000, digits=-3),
##                      spreadDV01 = round(731.48, digits=0),
##                      currency = "EUR",
##                      ptsUpfront = round(0.44, digits=2),
##                      freqCDS = "Q",
##                      pencouponDate = as.Date("2019-03-20"),
##                      backstopDate = as.Date("2014-02-14"),
##                      coupon = 500,
##                      recoveryRate = 0.40,
##                      defaultProb = round(0.9128, digits=2),
##                      notional = 1e7)

## save(truth1, file = "CDS.NorskeSkogindustrier.test.RData")

load("CDS.NorskeSkogindustrier.test.RData")
result1 <- CDS(TDate = "2014-04-15",
               maturity = "5Y",
               contract ="STEC",
               parSpread = 2785.8889,
               currency = "EUR",
               coupon = 500,
               recoveryRate = 0.40,
               isPriceClean = FALSE,
               notional = 1e7)
stopifnot(all.equal(truth1, CDSdf(result1)))
