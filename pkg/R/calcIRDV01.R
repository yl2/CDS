#' Calculate the IR DV01 from conventional spread
#'
#' @param parSpread in bps
#' @param couponRate in bps
#' @param recoveryRate in decimal. Default is 0.4.
#' @param notional default is 10mm (1e7)
#' 

calcIRDV01 <- function(object = NULL,
                       baseDate,
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
                       
                       today,
                       valueDate,
                       benchmarkDate,
                       startDate,
                       endDate,
                       stepinDate,
                       
                       dccCDS = "ACT/360",
                       freqCDS = "1Q",
                       stubCDS = "f/s",
                       badDayConvCDS = "F",
                       calendar = "None",
                       
                       parSpread,
                       couponRate,
                       recoveryRate = 0.4,
                       notional = 1e7
                       ){

    ratesDate <- baseDate
    baseDate <- .separateYMD(baseDate)
    today <- .separateYMD(today)
    valueDate <- .separateYMD(valueDate)
    benchmarkDate <- .separateYMD(benchmarkDate)
    startDate <- .separateYMD(startDate)
    endDate <- .separateYMD(endDate)
    stepinDate <- .separateYMD(stepinDate)


    if (userCurve == FALSE){

        ratesInfo <- getRates(date = ratesDate, currency = currency)

        types = paste(as.character(ratesInfo[[1]]$type), collapse = "")
        rates = as.numeric(as.character(ratesInfo[[1]]$rate))
        expiries = as.character(ratesInfo[[1]]$expiry)
        mmDCC = as.character(ratesInfo[[2]]$mmDCC)
        
        fixedSwapFreq = as.character(ratesInfo[[2]]$fixedFreq)
        floatSwapFreq = as.character(ratesInfo[[2]]$floatFreq)
        fixedSwapDCC = as.character(ratesInfo[[2]]$fixedDCC)
        floatSwapDCC = as.character(ratesInfo[[2]]$floatDCC)
        badDayConvZC = as.character(ratesInfo[[2]]$badDayConvention)
        holidays = as.character(ratesInfo[[2]]$swapCalendars)
    }

    upfront.orig <- .Call('calcUpfrontTest',
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
                          FALSE,
                          notional,
                          PACKAGE = "CDS")


    upfront.new <- .Call('calcUpfrontTest',
                         baseDate,
                         types,
                         rates + 1/1e4,
                         expiries,

                         mmDCC,
                         fixedSwapFreq,
                         floatSwapFreq,
                         fixedSwapDCC,
                         floatSwapDCC,
                         badDayConvZC,
                         holidays,
                         
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
                         FALSE,
                         notional,
                         PACKAGE = "CDS")

    
    return (upfront.new - upfront.orig)
    
}

setMethod("calcIRDV01",
          signature(object = "CDS"),
          function(object){
              baseDate <- .separateYMD(object@baseDate)
              today <- .separateYMD(object@today)
              valueDate <- .separateYMD(object@valueDate)
              benchmarkDate <- .separateYMD(object@benchmarkDate)
              startDate <- .separateYMD(object@startDate)
              endDate <- .separateYMD(object@endDate)
              stepinDate <- .separateYMD(object@stepinDate)

              
              upfront.new <- .Call('calcUpfrontTest',
                                   baseDate,
                                   object@types,
                                   object@rates + 1/1e4,
                                   object@expiries,
                                   
                                   object@mmDCC,
                                   object@fixedSwapFreq,
                                   object@floatSwapFreq,
                                   object@fixedSwapDCC,
                                   object@floatSwapDCC,
                                   object@badDayConvZC,
                                   object@holidays,
                                   
                                   today,
                                   valueDate,
                                   benchmarkDate,
                                   startDate,
                                   endDate,
                                   stepinDate,
                                   
                                   object@dccCDS,
                                   object@freqCDS,
                                   object@stubCDS,
                                   object@badDayConvCDS,
                                   object@calendarCDS,
                                   
                                   object@parSpread,
                                   object@couponRate,
                                   object@recRate,
                                   FALSE,
                                   object@notional,
                                   PACKAGE = "CDS")


                 return (upfront.new - object@upfront)
          }
          
          )
