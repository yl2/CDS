#' Calculate the IR DV01 from conventional spread
#'
#' @param parSpread in bps
#' @param couponRate in bps
#' @param recoveryRate in decimal. Default is 0.4.
#' @param notional default is 10mm (1e7)
#' 
calcIRDV01 <- function(baseDate,
                     types, dates, rates, nInstr,
                     mmDCC, ## mmDCC is a character detailing the
                            ## DCC of the MM instruments for the
                            ## yield curve.
                     
                     fixedSwapFreq, floatSwapFreq, fixedSwapDcc, floatSwapDcc,
                     badDayConvZC, holidays,
                     
                     today,
                     valueDate,
                     benchmarkDate,
                     startDate,
                     endDate,
                     stepinDate,
                     
                     dccCDS,
                     freqCDS,
                     stubCDS,
                     badDayConvCDS,
                     calendar,
                     
                     parSpread,
                     couponRate,
                     recoveryRate = 0.4,
                     notional = 1e7){
    baseDate <- .separateYMD(baseDate)
    today <- .separateYMD(today)
    valueDate <- .separateYMD(valueDate)
    benchmarkDate <- .separateYMD(benchmarkDate)
    startDate <- .separateYMD(startDate)
    endDate <- .separateYMD(endDate)
    stepinDate <- .separateYMD(stepinDate)
    
    upfront = .Call('calcUpfrontTest',
        baseDate,
        
        types, dates, rates, nInstr, mmDCC,
        
        fixedSwapFreq, floatSwapFreq, fixedSwapDcc, floatSwapDcc,
        badDayConvZC, holidays,
        
        today,
        valueDate,
        benchmarkDate,
        startDate,
        endDate,
        stepinDate,
        
        dccCDS,
        freqCDS,
        stubCDS,
        badDayConvCDS,
        calendar,
        
        parSpread,
        couponRate,
        recoveryRate,
        notional)

  upfront2 = .Call('calcUpfrontTest',
      baseDate,
      
        types, dates, rates + 1/1e4, nInstr, mmDCC,
      
        fixedSwapFreq, floatSwapFreq, fixedSwapDcc, floatSwapDcc,
        badDayConvZC, holidays,
        
        today,
        valueDate,
        benchmarkDate,
        startDate,
        endDate,
        stepinDate,
        
        dccCDS,
        freqCDS,
        stubCDS,
        badDayConvCDS,
        calendar,
        
        parSpread,
        couponRate,
        recoveryRate,
        notional)

    return (upfront2 - upfront)
    
}


