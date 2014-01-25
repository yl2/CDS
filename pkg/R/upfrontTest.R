TuoUpFront <- function(valueDateYear, valueDateMonth,
valueDateDay, types, dates, rates, nInstr, mmDCC, fixedSwapFreq,
floatSwapFreq, fixedSwapDcc, floatSwapDCC, badDayConvZC, holidays) .Call('JpmcdsCdsoneUpfrontChargeTest', valueDateYear, valueDateMonth,
valueDateDay, types, dates, rates, nInstr, mmDCC, fixedSwapFreq,
floatSwapFreq, fixedSwapDcc, floatSwapDCC, badDayConvZC, holidays)
