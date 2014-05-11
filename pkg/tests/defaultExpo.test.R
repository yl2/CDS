## test case for default exposure for CDS of Xerox Corporation

library(CDS)

## true default exposure for Xerox is 5971932
result1 <- defaultExpo(principal = 28068)
stopifnot(all.equal(5971932, result1))
