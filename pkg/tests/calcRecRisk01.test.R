## calcRecRisk01.test.R

library(CDS)

## truth1 <- calcRecRisk01(TDate = "2014-01-14",
##                          currency = "USD",
##                          maturity = "5Y",
                          
##                           dccCDS = "Act/360",
##                           freqCDS = "1Q",
##                           stubCDS = "F",
##                           badDayConvCDS = "F",
##                           calendar = "None",
##                           parSpread = 32,
##                           couponRate = 100,
##                           recoveryRate = 0.4,
##                           notional = 1e7)

## save(truth1, file = "calcRecRisk01.test.RData")



load("calcRecRisk01.test.RData")

result1 <- calcRecRisk01(TDate = "2014-01-14",
                         currency = "USD",
                         maturity = "5Y",
                         
                         dccCDS = "Act/360",
                         freqCDS = "1Q",
                         stubCDS = "F",
                         badDayConvCDS = "F",
                         calendar = "None",
                         parSpread = 32,
                         couponRate = 100,
                         recoveryRate = 0.4,
                         notional = 1e7)


stopifnot(all.equal(result1, truth1))

