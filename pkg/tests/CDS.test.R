## CDS.test.R

library(CDS)

## truth <- CDS(contract = "SNAC",
##              today = "2014-01-14",
##              entityName = "IBM",

##              notional = 1e7,
##              currency = "USD",

##              TDate = "2014-01-14",
##              spread = 21,
##              couponRate = 100,

##              dccCDS = "Act/360",
##              freqCDS = "1Q",
##              stubCDS = "f/s",
##              badDayConvCDS = "F",
##              calendarCDS = "None",

##              maturity = "5Y",
##              payAccOnDefault = TRUE,
##              recRate = 0.4,
                        
##              userCurve = FALSE,
##              baseDate = "2014-01-14",
             
##              valueDate = "2014-01-17",
##              benchmarkDate = "2013-12-20",
##              startDate = "2013-12-20",
##              endDate = "2019-03-20",
##              stepinDate = "2014-01-15")
## save(truth, file = "CDS.test.RData")

load("CDS.test.RData")
result <- CDS(contract = "SNAC",
              today = "2014-01-14",
              entityName = "IBM",

              notional = 1e7,
              currency = "USD",

              TDate = "2014-01-14",
              spread = 21,
              couponRate = 100,

              dccCDS = "Act/360",
              freqCDS = "1Q",
              stubCDS = "f/s",
              badDayConvCDS = "F",
              calendarCDS = "None",

              maturity = "5Y",
              payAccOnDefault = TRUE,
              recRate = 0.4,
              
              userCurve = FALSE,
              baseDate = "2014-01-14",
              
              valueDate = "2014-01-17",
              benchmarkDate = "2013-12-20",
              startDate = "2013-12-20",
              endDate = "2019-03-20",
              stepinDate = "2014-01-15")


stopifnot(all.equal(truth, result))
