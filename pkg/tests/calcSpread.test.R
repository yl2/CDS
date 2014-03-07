## calcSpread.test.R

library(CDS)

## truth <- calcSpread(baseDate = "2008-01-03",
##                     types = "MMMMMSSSSSSSSS",
##                     dates = c(20080201, 20080203, 20080205),
##                     rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
##                     nInstr = 10,
##                     mmDCC = 10,
##                     fixedSwapFreq = 10,
##                     floatSwapFreq = 10,
##                     fixedSwapDCC = 10,
##                     floatSwapDCC = 10,
##                     badDayConvZC = 'M',
##                     holidays = 'None',
##                     todayDate = "2008-02-01",
##                     valueDate = "2008-02-01",
##                     benchmarkStartDate = "2008-02-02",
##                     startDate = "2008-02-08",
##                     endDate = "2008-02-12",
##                     stepinDate = "2008-02-9",
##                     couponRate = 100/1e4, 
##                     payAccruedOnDefault = TRUE, 
##                     dateInterval = 'M',		  
##                     stubType = TRUE, 		
##                     accrueDCC = as.integer(3),
##                     badDayConv = as.integer(70),
##                     calendar = 'None',
##                     upfrontCharge = 600000/1e7,
##                     recoveryRate = .4,
##                     payAccruedAtStart = FALSE
##                     )
## save(truth, file = "/home/yang/CDS/pkg/tests/calcSpread.test.RData")

load("calcSpread.test.RData")
result <- calcSpread(baseDate = "2008-01-03",
                     types = "MMMMMSSSSSSSSS",
                     dates = c(20080201, 20080203, 20080205),
                     rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
                     nInstr = 10,
                     mmDCC = 10,
                     fixedSwapFreq = 10,
                     floatSwapFreq = 10,
                     fixedSwapDCC = 10,
                     floatSwapDCC = 10,
                     badDayConvZC = 'M',
                     holidays = 'None',
                     todayDate = "2008-02-01",
                     valueDate = "2008-02-01",
                     benchmarkStartDate = "2008-02-02",
                     startDate = "2008-02-08",
                     endDate = "2008-02-12",
                     stepinDate = "2008-02-9",
                     couponRate = 100/1e4, 
                     payAccruedOnDefault = TRUE, 
                     dateInterval = 'M',		  
                     stubType = TRUE, 		
                     accrueDCC = as.integer(3),
                     badDayConv = as.integer(70),
                     calendar = 'None',
                     upfrontCharge = 600000/1e7,
                     recoveryRate = .4,
                     payAccruedAtStart = FALSE
                     )


stopifnot(all.equal(result, truth))
