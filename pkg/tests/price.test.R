## test case for price function that calculates price of CDS, in this case for Xerox corporation
library(CDS)
## actual price is 99.72
result1 <- price(28068, 1e7)
stopifnot(all.equal(99.72, round(result1, 2)))
