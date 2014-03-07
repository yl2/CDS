calcUpfront <- function(baseDate,
                        types, dates, rates, nInstr,
                        mmDCC, fixedSwapFreq,
                        floatSwapFreq, fixedSwapDcc, floatSwapDcc,
                        badDayConvZC, holidays,
                        
                        today,
                        valueDate,
                        benchmarkDate,
                        startDate,
                        endDate,
                        stepinDate,
                        parSpread,
                        couponRate){
    baseDate <- separateYMD(baseDate)
    today <- separateYMD(today)
    valueDate <- separateYMD(valueDate)
    benchmarkDate <- separateYMD(benchmarkDate)
    startDate <- separateYMD(startDate)
    endDate <- separateYMD(endDate)
    stepinDate <- separateYMD(stepinDate)
 
    .Call('calcUpfrontTest',
          baseDate[1], baseDate[2], baseDate[3],

          types, dates, rates, nInstr, mmDCC, fixedSwapFreq,
          floatSwapFreq, fixedSwapDcc, floatSwapDcc, badDayConvZC, holidays,
          
          today[1],today[2],today[3],
          valueDate[1],valueDate[2],valueDate[3],
          benchmarkDate[1], benchmarkDate[2], benchmarkDate[3],
          startDate[1],startDate[2],startDate[3],
          endDate[1],endDate[2],endDate[3],
          stepinDate[1],stepinDate[2],stepinDate[3],
          parSpread, couponRate)
}


