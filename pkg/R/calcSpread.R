#' Calculate conventional spread from upfront
#'
#' @param couponRate in bps
#' @param recoveryRate in decimal. Default is 0.4.
#' @param notional default is 10mm (1e7)
#' @param upfrontCharge the dollar amount for upfront payment
#' 

calcSpread <- function(baseDate,
                       currency = "USD",
                       userCurve = FALSE,

                       types = NULL,
                       rates = NULL,
                       expiries = NULL,
                       mmDCC = NULL,
                       fixedSwapFreq = NULL,
                       floatSwapFreq = NULL,
                       fixedSwapDCC = NULL,
                       floatSwapDCC = NULL,
                       badDayConvZC = NULL,
                       holidays = NULL,
                       
                       todayDate, 
                       valueDate, 
                       benchmarkDate,
                       startDate,  
                       endDate,  
                       stepinDate,
                       
                       couponRate, 
                       payAccruedOnDefault, 

                       dccCDS,
                       dateInterval,		  
                       stubType = "f/s", 		
                       badDayConvCDS = "F",
                       calendar = "None",

                       upfrontCharge,
                       recoveryRate = 0.4,
                       payAccruedAtStart,
                       notional = 1e7){

    ratesDate <- baseDate
    ptsUpf <- upfrontCharge / notional
    baseDate <- .separateYMD(baseDate)
    todayDate <- .separateYMD(todayDate)
    valueDate <- .separateYMD(valueDate)
    benchmarkDate <- .separateYMD(benchmarkDate)
    startDate <- .separateYMD(startDate)
    endDate <- .separateYMD(endDate)
    stepinDate <- .separateYMD(stepinDate)


    if (userCurve == FALSE){
        ratesInfo <- getRates(date = ratesDate, currency = currency)
        .Call('calcCdsoneSpread',
              baseDate,
              types = paste(as.character(ratesInfo[[1]]$type), collapse = ""),
              rates = as.numeric(as.character(ratesInfo[[1]]$rate)),
              expiries = as.character(ratesInfo[[1]]$expiry),
              mmDCC = as.character(ratesInfo[[2]]$mmDCC),
              
              fixedSwapFreq = as.character(ratesInfo[[2]]$fixedFreq),
              floatSwapFreq = as.character(ratesInfo[[2]]$floatFreq),
              fixedSwapDcc = as.character(ratesInfo[[2]]$fixedDCC),
              floatSwapDcc = as.character(ratesInfo[[2]]$floatDCC),
              badDayConvZC = as.character(ratesInfo[[2]]$badDayConvention),
              holidays = as.character(ratesInfo[[2]]$swapCalendars),

              todayDate,
              valueDate,
              benchmarkDate,
              startDate,
              endDate,
              stepinDate,
              
              couponRate / 1e4,
              payAccruedOnDefault,
              
              dccCDS,
              dateInterval,
              stubType,
              badDayConvCDS,
              calendar,

              ptsUpf,
              recoveryRate,
              payAccruedAtStart)

    } else {
        
        .Call('calcCdsoneSpread',
              baseDate,
              types,
              rates,
              expiries,
              mmDCC,
              
              fixedSwapFreq,
              floatSwapFreq,
              fixedSwapDCC,
              floatSwapDCC,
              badDayConvZC,
              holidays,

              todayDate,
              valueDate,
              benchmarkDate,
              startDate,
              endDate,
              stepinDate,
              
              couponRate / 1e4,
              payAccruedOnDefault,
              
              dccCDS,
              dateInterval,
              stubType,
              badDayConvCDS,
              calendar,

              ptsUpf,
              recoveryRate,
              payAccruedAtStart)
    }
}
