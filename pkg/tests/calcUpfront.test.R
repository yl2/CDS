## calcUpfront.test.R

library(CDS)

## truth <- calcUpfront("2008-01-03",
##                       types = "MMMMMSSSSSSSSS",
##                       dates = c(20080201, 20080203, 20080205),
##                       rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
##                       nInstr = 10,
##                       mmDCC = "Act/360",
##                       fixedSwapFreq = "6M",
##                       floatSwapFreq = "6M",
##                       fixedSwapDcc = "30/360",
##                       floatSwapDcc = "30/360",
##                       badDayConvZC = 'M',
##                       holidays = 'None',
                      
##                       today = "2008-02-01",
##                       valueDate = "2008-02-01",
##                       benchmarkDate = "2008-02-02",
##                       startDate = "2008-02-08",
##                       endDate = "2008-02-12",
##                       stepinDate = "2008-02-9",

##                       dccCDS = "Act/360",
##                       freqCDS = "1S",
##                       stubCDS = "f/s",

##                       parSpread = 720,
##                       couponRate = 100,
##                       recoveryRate = 0.4,
##                       notional = 1e7)

## save(truth, file = "calcUpfront.test.RData")

load("calcUpfront.test.RData")
result <- calcUpfront("2008-01-03",
                      types = "MMMMMSSSSSSSSS",
                      dates = c(20080201, 20080203, 20080205),
                      rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
                      nInstr = 10,
                      mmDCC = "Act/360",
                      fixedSwapFreq = "6M",
                      floatSwapFreq = "6M",
                      fixedSwapDcc = "30/360",
                      floatSwapDcc = "30/360",
                      badDayConvZC = 'M',
                      holidays = 'None',
                      
                      today = "2008-02-01",
                      valueDate = "2008-02-01",
                      benchmarkDate = "2008-02-02",
                      startDate = "2008-02-08",
                      endDate = "2008-02-12",
                      stepinDate = "2008-02-9",

                      dccCDS = "Act/360",
                      freqCDS = "1S",
                      stubCDS = "f/s",

                      parSpread = 720,
                      couponRate = 100,
                      recoveryRate = 0.4,
                      notional = 1e7)


stopifnot(all.equal(result, truth))
