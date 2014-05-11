## test case for CS10, for CDS of Xerox corporation
library(CDS)
CS10(CDS(TDate = "2014-04-22",
         maturity = "5Y", 
         parSpread = 105.8,
         coupon = 100,
         recoveryRate = 0.4,
         isPriceClean = FALSE,
         notional = 1e7))

