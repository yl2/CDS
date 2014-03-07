## Calculate conventional spread from upfront
calcSpread <- function(baseDate,
                       types, dates, rates, nInstr,
                       mmDCC, fixedSwapFreq,
                       floatSwapFreq, fixedSwapDCC, floatSwapDCC,
                       badDayConvZC, holidays,
                       
                       todayDate, 
                       valueDate, 
                       benchmarkStartDate,
                       stepinDate,  
                       startDate,  
                       endDate,  
                       couponRate, 
                       payAccruedOnDefault, 
                       dateInterval,		  
                       stubType, 		
                       accrueDCC,
                       badDayConv,
                       calendar,
                       upfrontCharge,
                       recoveryRate,
                       payAccruedAtStart
                       ){
    
    baseDate <- separateYMD(baseDate)
    todayDate <- separateYMD(todayDate)
    valueDate <- separateYMD(valueDate)
    benchmarkStartDate <- separateYMD(benchmarkStartDate)
    startDate <- separateYMD(startDate)
    endDate <- separateYMD(endDate)
    stepinDate <- separateYMD(stepinDate)
    
    .Call('calcCdsoneSpread',
          baseDate,
          types,
          dates,
          rates,
          nInstr,
          mmDCC,
          fixedSwapFreq,
          floatSwapFreq,
          fixedSwapDCC,
          floatSwapDCC,
          badDayConvZC,
          holidays,
          todayDate,
          valueDate,
          benchmarkStartDate,
          stepinDate,
          startDate,
          endDate,
          couponRate,
          payAccruedOnDefault,
          dateInterval,
          stubType,
          accrueDCC,
          badDayConv,
          calendar,
          upfrontCharge,
          recoveryRate,
          payAccruedAtStart)
}
