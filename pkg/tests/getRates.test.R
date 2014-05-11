## test case for getRates function
library(CDS)
## US treasury yield curve from April 15, 2014
## truth1 <- c(0.001517, 
##             0.001923,
##             0.002287,
##             0.003227,
##             0.005105,
##             0.005465,
##             0.009265,
##             0.013470,
##             0.017150,
##             0.020160,
##             0.022630,
##             0.024580,
##             0.026265,
##             0.027590,
##             0.029715,
##             0.031820,
##             0.033635,
##             0.034420,
##             0.034780)
## save(truth1, file = "getRates.test.RData")
load("getRates.test.RData")
#rates column from the package's getRates function
rates <- getRates(date = "2014-04-15")[[1]]
rates <- as.numeric(levels(rates$rate))
stopifnot(all.equal(truth1, rates))
