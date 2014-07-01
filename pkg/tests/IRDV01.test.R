## IRDV01.test.R
library(CDS)

## truth1 <- IRDV01(TDate = "2014-01-14",
##                  types = "MMMMMSSSSSSSSS",
##                  rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
##                  expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),
##                  currency = "USD",
##                  maturity = "5Y",
##                  dccCDS = "Act/360",
##                  freqCDS = "1Q",
##                  stubCDS = "F",
##                  badDayConvCDS = "F",
##                  calendar = "None",
##                  parSpread = 32,
##                  coupon = 100,
##                  recoveryRate = 0.4,
##                  notional = 1e7)

## save(truth1, file = "IRDV01.test.RData")

load("IRDV01.test.RData")

result1 <- IRDV01(TDate = "2014-01-14",
                  types = "MMMMMSSSSSSSSS",
                  rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
                  expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),
                  currency = "USD",
                  maturity = "5Y",
                  dccCDS = "Act/360",
                  freqCDS = "1Q",
                  stubCDS = "F",
                  badDayConvCDS = "F",
                  calendar = "None",
                  parSpread = 32,
                  coupon = 100,
                  recoveryRate = 0.4,
                  notional = 1e7)

stopifnot(all.equal(result1, truth1))
