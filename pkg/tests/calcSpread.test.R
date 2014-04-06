## calcSpread.test.R

library(CDS)

## truth <- calcSpread(baseDate = "2008-01-03",
##                      types = "MMMMMSSSSSSSSS",
##                      dates = c(20080201, 20080203, 20080205),
##                      rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
##                      nInstr = 10,

##                      mmDCC = "Act/360",
##                      fixedSwapFreq = "6M",
##                      floatSwapFreq = "6M",
##                      fixedSwapDCC = "30/360",
##                      floatSwapDCC = "30/360",
##                      badDayConvZC = 'M',

##                      holidays = 'None',
##                      todayDate = "2008-02-01",
##                      valueDate = "2008-02-01",
##                      benchmarkStartDate = "2008-02-02",
##                      startDate = "2008-02-08",
##                      endDate = "2008-02-12",
##                      stepinDate = "2008-02-9",
##                      couponRate = 100, 
##                      payAccruedOnDefault = TRUE, 
##                      dateInterval = 'M',		  
##                      stubType = TRUE, 		
##                      accrueDCC = as.integer(3),
##                      badDayConv = as.integer(70),
##                      calendar = 'None',
##                      upfrontCharge = 600000,
##                      recoveryRate = .4,
##                      payAccruedAtStart = FALSE,
##                      notional = 1e7)
## save(truth, file = "/home/yang/CDS/pkg/tests/calcSpread.test.RData")

load("calcSpread.test.RData")
result <- calcSpread(baseDate = "2008-01-03",
                     types = "MMMMMSSSSSSSSS",
                     dates = c(20080201, 20080203, 20080205),
                     rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
                     nInstr = 10,

                     mmDCC = "Act/360",
                     fixedSwapFreq = "6M",
                     floatSwapFreq = "6M",
                     fixedSwapDCC = "30/360",
                     floatSwapDCC = "30/360",
                     badDayConvZC = 'M',

                     holidays = 'None',
                     todayDate = "2008-02-01",
                     valueDate = "2008-02-01",
                     benchmarkStartDate = "2008-02-02",
                     startDate = "2008-02-08",
                     endDate = "2008-02-12",
                     stepinDate = "2008-02-9",
                     couponRate = 100, 
                     payAccruedOnDefault = TRUE, 
                     dateInterval = 'M',		  
                     stubType = TRUE, 		
                     accrueDCC = as.integer(3),
                     badDayConv = as.integer(70),
                     calendar = 'None',
                     upfrontCharge = 600000,
                     recoveryRate = .4,
                     payAccruedAtStart = FALSE,
                     notional = 1e7)


stopifnot(all.equal(result, truth))
