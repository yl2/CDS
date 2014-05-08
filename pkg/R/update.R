#' update spread or ptsUpfront or upfront based on a new CDS class object.
#'
#' @param object is a \code{CDS} class object.
#' @param upfront is the new upfront payment amount.
#' @param ptsUpfront is the new pts upfront. It's in decimal.
#' @param spread is the new spread in bps.
#' @param isPriceClean specifies whether it is a dirty or clean
#' upfront.
#' @return a \code{CDS} class object
#'
#' @export
#'
#' @examples
#'
#' ## build a CDS class object
#' cds1 <- CDS(TDate = "2014-05-07", parSpread = 50, coupon = 100)
#'
#' ## update
#' update(cds1, spread = 55)
#' 

setMethod("update",
          signature(object = "CDS"),
          function(object,
                   upfront = NULL,
                   isPriceClean = FALSE,
                   ptsUpfront = NULL,
                   spread = NULL,
                   ...){

              if ((as.numeric(!is.null(upfront)) + 
                   as.numeric(!is.null(ptsUpfront)) + 
                   as.numeric(!is.null(spread))) > 1)
                  stop ("Please only update one option -- upfront, ptsUpfront or spread")
              
              if (!is.null(upfront)){
                  newSpread <- NULL
                  newUpfront <- upfront
                  newPtsUpfront <- NULL
              } else if (!is.null(ptsUpfront)){
                  newSpread <- NULL
                  newUpfront <- NULL
                  newPtsUpfront <- ptsUpfront
              } else if (!is.null(spread)){
                  newSpread <- spread
                  newUpfront <- NULL
                  newPtsUpfront <- NULL
              }
                  newCDS <- CDS(object@contract,
                                object@entityName,
                                object@RED,
                                object@TDate,
                                object@baseDate,
                                object@currency,
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
                                object@valueDate,
                                object@benchmarkDate,
                                object@startDate,
                                object@endDate,
                                object@stepinDate,
                                object@maturity,
                                object@dccCDS,
                                object@freqCDS,
                                object@stubCDS,
                                object@badDayConvCDS,
                                object@calendar,
                                newSpread,
                                object@coupon,
                                object@recoveryRate,
                                newUpfront,
                                newPtsUpfront, 
                                isPriceClean,
                                object@notional,
                                object@payAccruedOnDefault)
                  
                  return(newCDS)

          }
          )
