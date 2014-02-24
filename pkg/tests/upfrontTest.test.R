## upfrontTest.test.R

library(CDS)

## truth <- upFront(valueDateYear = 2008,
##                  valueDateMonth = 1,
##                  valueDateDay = 3,
##                  types = "MMMMMSSSSSSSSS",
##                  dates = c(20080201, 20080203, 20080205),
##                  rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
##                  nInstr = 10,
##                  mmDCC = 10,
##                  fixedSwapFreq = 10,
##                  floatSwapFreq = 10,
##                  fixedSwapDcc = 10,
##                  floatSwapDcc = 10,
##                  badDayConvZC = 'M',
##                  holidays = 'None',
##                  couponRate = 3600)

## save(truth, file = "upfrontTest.test.RData")


load("upfrontTest.test.RData")

result <- upFront(valueDateYear = 2008,
                  valueDateMonth = 1,
                  valueDateDay = 3,
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
                  couponRate = 3600)

stopifnot(all.equal(result, truth))
