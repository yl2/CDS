upFront <- function(baseDate, ## valueDateYear, valueDateMonth, valueDateDay,
                    types, dates, rates, nInstr,
                    mmDCC, fixedSwapFreq,
                    floatSwapFreq, fixedSwapDcc, floatSwapDcc,
                    badDayConvZC, holidays, couponRate){
    ## valueDate format valueDate = "2008-02-01"
    baseDateYear <- as.numeric(format(as.Date(baseDate), "%Y"))
    baseDateMonth <- as.numeric(format(as.Date(baseDate), "%m"))
    baseDateDay <- as.numeric(format(as.Date(baseDate), "%d"))
    
    .Call('JpmcdsCdsoneUpfrontChargeTest', baseDateYear, baseDateMonth,
          baseDateDay, types, dates, rates, nInstr, mmDCC, fixedSwapFreq,
          floatSwapFreq, fixedSwapDcc, floatSwapDcc, badDayConvZC, holidays, couponRate)
}
## pFront(valueDateYear = 2008,
## valueDateMonth = 1,
## valueDateDay = 3,
## types = "MMMMMSSSSSSSSS",
## dates = c(20080201, 20080203, 20080205),
## rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
## nInstr = 10,
## mmDCC = 10,
## fixedSwapFreq = 10,
## floatSwapFreq = 10,
## fixedSwapDcc = 10,
## floatSwapDcc = 10,
## badDayConvZC = 'M',
## holidays = 'None',
## couponRate = 3600)
## couponRate in bps
