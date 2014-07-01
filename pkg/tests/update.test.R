## test case for update using CDS
library(CDS)

## truth1 <- update(CDS(TDate = "2014-04-22",
##                      types = "MMMMMSSSSSSSSS",
##                      rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
##                      expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),
##                      maturity = "5Y", 
##                      parSpread = 105.8,
##                      coupon = 100,
##                      recoveryRate = 0.4,
##                      isPriceClean = FALSE,
##                      notional = 1e7), 
##                  upfront = 20000,
##                  isPriceClean = FALSE,
##                  ptsUpfront = NULL,
##                  spread = NULL)
## save(truth1, file = "update.test.RData")

load("update.test.RData")
result1 <- update(CDS(TDate = "2014-04-22",
                      types = "MMMMMSSSSSSSSS",
                      rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
                      expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),
                      maturity = "5Y", 
                      parSpread = 105.8,
                      coupon = 100,
                      recoveryRate = 0.4,
                      isPriceClean = FALSE,
                      notional = 1e7), 
                      upfront = 20000,
                      isPriceClean = FALSE,
                      ptsUpfront = NULL,
                      spread = NULL)

stopifnot(all.equal(truth1, result1))
