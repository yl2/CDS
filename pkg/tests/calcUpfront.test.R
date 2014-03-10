## calcUpfront.test.R

library(CDS)

## truth <- calcUpfront("2008-01-03",
##                      types = "MMMMMSSSSSSSSS",
##                      dates = c(20080201, 20080203, 20080205),
##                      rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
##                      nInstr = 10,
##                      mmDCC = 10,
##                      fixedSwapFreq = 10,
##                      floatSwapFreq = 10,
##                      fixedSwapDcc = 10,
##                      floatSwapDcc = 10,
##                      badDayConvZC = 'M',
##                      holidays = 'None',
##                      today = "2008-02-01",
##                      valueDate = "2008-02-01",
##                      benchmarkDate = "2008-02-02",
##                      startDate = "2008-02-08",
##                      endDate = "2008-02-12",
##                      stepinDate = "2008-02-9",
##                      parSpread = 720,
##                      couponRate = 100,
##                      recoveryRate = 0.4,
##                      notional = 1e7)
## save(truth, file = "calcUpfront.test.RData")

load("calcUpfront.test.RData")
result <- calcUpfront("2008-01-03",
                      types = "MMMMMSSSSSSSSS",
                      dates = c(20080201, 20080203, 20080205),
                      rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
                      nInstr = 10,
                      mmDCC = 10,
                      fixedSwapFreq = 10,
                      floatSwapFreq = 10,
                      fixedSwapDcc = 10,
                      floatSwapDcc = 10,
                      badDayConvZC = 'M',
                      holidays = 'None',
                      today = "2008-02-01",
                      valueDate = "2008-02-01",
                      benchmarkDate = "2008-02-02",
                      startDate = "2008-02-08",
                      endDate = "2008-02-12",
                      stepinDate = "2008-02-9",
                      parSpread = 720,
                      couponRate = 100,
                      recoveryRate = 0.4,
                      notional = 1e7)


stopifnot(all.equal(result, truth))
