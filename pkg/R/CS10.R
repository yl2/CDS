#' Calculate the CS10 of a CDS contract
#'
#' Calculate the change in value of the contract when there is a 10%
#' on the spread of the contract.
#' 
#' @param object is a \code{CDS} class object.
#' @return a numeric indicating the CS10 of the contract.
#' @examples
#' # construct a CDS class object
#' cds1 <- CDS(TDate = "2014-05-07", parSpread = 50, coupon = 100)
#'
#' # use CS10
#' CS10(cds1)
#' 
#' @export

CS10 <- function(object){
    baseDate <- .separateYMD(object@baseDate)
    today <- .separateYMD(object@TDate)
    valueDate <- .separateYMD(object@valueDate)
    benchmarkDate <- .separateYMD(object@benchmarkDate)
    startDate <- .separateYMD(object@startDate)
    endDate <- .separateYMD(object@endDate)
    stepinDate <- .separateYMD(object@stepinDate)

    upfront.new <- .Call('calcUpfrontTest',
                         baseDate,
                         object@types,
                         object@rates,
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
                         object@calendar,
                         
                         object@parSpread * 1.1,
                         object@coupon,
                         object@recoveryRate,
                         object@isPriceClean,
                         object@payAccruedOnDefault,
                         object@notional,
                         PACKAGE = "CDS")
    return (upfront.new - object@upfront)

}

#' The CS10 method for CDS class
#' 
#' @name CS10-method
#' @title S4 method CS10 
#' @aliases CS10,CDS-method
#' @docType methods
#' @rdname CS10-methods
#' @param object the input CDS class object
#' @export

setMethod("CS10",
          signature(object = "CDS"),
          function(object){
              baseDate <- .separateYMD(object@baseDate)
              today <- .separateYMD(object@TDate)
              valueDate <- .separateYMD(object@valueDate)
              benchmarkDate <- .separateYMD(object@benchmarkDate)
              startDate <- .separateYMD(object@startDate)
              endDate <- .separateYMD(object@endDate)
              stepinDate <- .separateYMD(object@stepinDate)

              upfront.new <- .Call('calcUpfrontTest',
                                   baseDate,
                                   object@types,
                                   object@rates,
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
                                   object@calendar,
                                   
                                   object@parSpread * 1.1,
                                   object@coupon,
                                   object@recoveryRate,
                                   isPriceClean = FALSE,
                                   object@payAccruedOnDefault,
                                   object@notional,
                                   PACKAGE = "CDS")
              return (upfront.new - object@upfront)
              
          }
          )
