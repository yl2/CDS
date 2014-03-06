## spreadTest.R calculate conventional spread from upfront

calcSpread <- function(baseDate,
                       types, dates, rates, nInstr,
                       mmDCC, fixedSwapFreq,
                       floatSwapFreq, fixedSwapDcc, floatSwapDcc,
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
          fixedSwapDcc,
          floatSwapDcc,
          badDayConvZC,
          holidays,
          todayDate,
          valueDate,
          benchmarkStartDate,
          startDate,
          endDate,
          stepinDate,
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

## calcSpread("2008-01-03",
##            types = "MMMMMSSSSSSSSS",
##            dates = c(20080201, 20080203, 20080205),
##            rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
##            nInstr = 10,
##            mmDCC = 10,
##            fixedSwapFreq = 10,
##            floatSwapFreq = 10,
##            fixedSwapDcc = 10,
##            floatSwapDcc = 10,
##            badDayConvZC = 'M',
##            holidays = 'None',
##            todayDate = "2008-02-01",
##            valueDate = "2008-02-02",
##            benchmarkStartDate = "2008-02-02",
##            startDate = "2008-02-02",
##            endDate = "2008-02-12",
##            stepinDate = "2008-02-2",
##            couponRate = 100, 
##            payAccruedOnDefault = TRUE, 
##            dateInterval = 'Q',		  
##            stubType = TRUE, 		
##            accrueDCC = as.integer(10),
##            badDayConv = as.integer(0),
##            calendar = 'NONE',
##            upfrontCharge = 100,
##            recoveryRate = .4,
##            payAccruedAtStart = TRUE
##            )
