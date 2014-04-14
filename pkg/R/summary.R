#' The summary method for CDS class
#' 
#' @name summary
#' @aliases summary,summary-method
#' @docType methods
#' @rdname summary-methods
#' @param object,... the input CDS class object
#' @keywords summary
#' @export
#' 
setMethod("summary",
          signature(object = "CDS"),
          function(object,
                   ...){
              
              cat("Deal \n")
              cat(sprintf("Contact Type:                        %-s",
                          object@contract), "\n",
                  sprintf("Entity Name:                         %-s",
                          object@entityName), "\n",
                  sprintf("currency:                            %-s",
                          object@currency), "\n",
                  sprintf("Trade Date:                          %-s",
                          object@TDate), "\n",
                  sprintf("Maturity:                            %-s",
                          object@maturity), "\n",
                  sprintf("Day Cnt:                             %-s",
                          object@dccCDS), "\n",
                  sprintf("Freq:                                %-s",
                          object@freqCDS), "\n",
                  sprintf("Trade Spread (bp):                   %-s",
                          round(object@spread, 0)), "\n",
                  sprintf("Coupon (bp):                         %-s",
                          round(object@couponRate, 0)), "\n",
                  sprintf("Recovery Rate:                       %-s",
                          round(object@recRate, 2)), "\n",
                  sep = "")
              cat("\n")
              cat("Calculator \n")
              
              cat(sprintf("Value Date:                          %-s",
                          object@valueDate), "\n",
                  sprintf("Upfront:                             %-s",
                          round(object@upfront,2)), "\n",
                  sprintf("Spread DV01:                         %-s",
                          round(object@spreadDV01, 2)), "\n",
                  sprintf("IR DV01:                             %-s",
                          round(object@IRDV01, 2)), "\n",
                  sprintf("Rec Risk (percent):                  %-s",
                          round(object@RecRisk01, 2)), "\n",
                  sprintf("Default Probability:                 %-s",
                          round(object@defaultProb, 3)), "\n",
                  sep = ""
                  )
              
              cat("\n")
          
      }
)

