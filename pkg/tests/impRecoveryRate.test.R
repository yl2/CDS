## test case for implied recovery rate using a data frame containing ids, spreads and pds of 
## eight different CDSs

library(CDS)

## ids <- c("CaesarsEntCorp", "ElectroluxAB", "Chorus", "NorskeSkogindustrier", 
##         "Radioshack", "TokyoElectricPower", "ToysRUs", "Xerox")
## pd <- c(0.99998, 0.0827, 0.1915, 0.9128, 0.9997, 0.1830, 0.7813, 0.0880)
## spread <- c(12354.53, 99, 243.28, 2785.8889, 9106.8084, 250.00, 1737.7289, 105.8)
## TDate <- c(as.Date("2014-04-15"), as.Date("2014-04-22"), as.Date("2014-04-15"), 
##            as.Date("2014-04-15"), as.Date("2014-04-15"), as.Date("2014-04-15"),
##            as.Date("2014-04-15"), as.Date("2014-04-22"))
## endDate <- c(as.Date("2019-06-20"), as.Date("2019-06-20"), as.Date("2019-06-20"), 
##              as.Date("2019-06-20"), as.Date("2019-06-20"), as.Date("2019-06-20"),
##              as.Date("2019-06-20"), as.Date("2019-06-20"))   
## df <- data.frame(ids, pd, spread, TDate, endDate)

## save(df, file = "impRecoveryRate.test.RData")
load("impRecoveryRate.test.RData")
# 3 is the column number for spread and 2 is the column number for pd, 1 for id
impliedRecoveryRate(df, 3, 2, 1, 5, 4)
