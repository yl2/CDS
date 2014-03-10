#' Calculate conventional spread from upfront
#'
#' @param couponRate in bps
#' @param recoveryRate in decimal. Default is 0.4.
#' @param notional default is 10mm (1e7)
#' @param upfrontCharge the dollar amount for upfront payment
#' 

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
                       payAccruedAtStart,
                       notional
                       ){
    ptsUpf <- upfrontCharge / notional
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
          couponRate / 1e4,
          payAccruedOnDefault,
          dateInterval,
          stubType,
          accrueDCC,
          badDayConv,
          calendar,
          ## upfrontCharge,
          ptsUpf,
          recoveryRate,
          payAccruedAtStart)
}
