##test case for update using CDS of Xerox
library(CDS)
## object of class CDS
result2 <- update(CDS(TDate = "2014-04-22",
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