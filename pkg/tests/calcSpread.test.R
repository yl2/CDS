## calcSpread.test.R

library(CDS)

## truth <- calcSpread(baseDate = "2014-01-03",
##                      types = "MMMMMSSSSSSSSS",
##                      dates = c(20080201, 20080203, 20080205),
##                     rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
##                      nInstr = 14,

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

## save(truth, file = "calcSpread.test.RData")

load("calcSpread.test.RData")
result <- calcSpread(baseDate = "2014-01-14",
                     types = "MMMMMSSSSSSSSS",
                     dates = c(20140201, 20140203, 20140205),
                     rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
                     nInstr = 14,

                     mmDCC = "Act/360",
                     fixedSwapFreq = "6M",
                     floatSwapFreq = "6M",
                     fixedSwapDCC = "30/360",
                     floatSwapDCC = "30/360",
                     badDayConvZC = 'M',

                     holidays = 'None',
                     todayDate = "2014-02-01",
                     valueDate = "2014-02-01",
                     benchmarkStartDate = "2014-02-02",
                     startDate = "2014-02-08",
                     endDate = "2019-03-20",
                     stepinDate = "2014-02-9",
                     couponRate = 100, 
                     payAccruedOnDefault = TRUE, 
                     dateInterval = 'M',		  
                     stubType = TRUE, 		
                     accrueDCC = as.integer(3),
                     badDayConv = as.integer(70),
                     calendar = 'None',
                     upfrontCharge = -1e7*3.417408/100,
                     recoveryRate = .4,
                     payAccruedAtStart = FALSE,
                     notional = 1e7)


stopifnot(all.equal(result, truth))
