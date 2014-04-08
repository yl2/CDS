## calcDV01.test.R

library(CDS)

## truth <- calcIRDV01("2014-01-14",
##                     types = "MMMMMSSSSSSSSS",
##                     dates = c(20140201, 20140203, 20140205),
##                     rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
##                     nInstr = 14,
##                     mmDCC = "Act/360",
##                     fixedSwapFreq = "6M",
##                     floatSwapFreq = "6M",
##                     fixedSwapDcc = "30/360",
##                     floatSwapDcc = "30/360",
##                     badDayConvZC = 'M',
##                     holidays = 'None',
                    
##                     today = "2014-01-17",
##                     valueDate = "2014-01-17",
##                     benchmarkDate = "2014-02-02",
##                     startDate = "2014-02-08",
##                     endDate = "2019-03-20",
##                     stepinDate = "2014-02-9",
                    
##                     dccCDS = "Act/360",
##                     freqCDS = "1S",
##                     stubCDS = "f/s",
##                     badDayConvCDS = "F",
##                     calendar = "None",
##                     parSpread = 32,
##                     couponRate = 100,
##                     recoveryRate = 0.4,
##                     notional = 1e7)

## save(truth, file = "calcIRDV01.test.RData")

load("calcIRDV01.test.RData")

result <- calcIRDV01("2014-01-14",
                     types = "MMMMMSSSSSSSSS",
                     dates = c(20140201, 20140203, 20140205),
                     rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
                     nInstr = 14,
                     mmDCC = "Act/360",
                     fixedSwapFreq = "6M",
                     floatSwapFreq = "6M",
                     fixedSwapDcc = "30/360",
                     floatSwapDcc = "30/360",
                     badDayConvZC = 'M',
                     holidays = 'None',
                     
                     today = "2014-01-17",
                     valueDate = "2014-01-17",
                     benchmarkDate = "2014-02-02",
                     startDate = "2014-02-08",
                     endDate = "2019-03-20",
                     stepinDate = "2014-02-9",

                     dccCDS = "Act/360",
                     freqCDS = "1S",
                     stubCDS = "f/s",
                     badDayConvCDS = "F",
                     calendar = "None",
                     parSpread = 32,
                     couponRate = 100,
                     recoveryRate = 0.4,
                     notional = 1e7)


stopifnot(all.equal(result, truth))
