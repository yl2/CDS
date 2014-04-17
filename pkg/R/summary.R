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
              cat(sprintf("Contact Type:                        %s",
                          object@contract), "\n",
                  sprintf("Entity Name:                         %s",
                          object@entityName), "\n",
                  sprintf("currency:                            %s",
                          object@currency), "\n",
                  sprintf("Trade Date:                          %s",
                          object@TDate), "\n",
                  sprintf("Maturity:                            %s",
                          object@maturity), "\n",
                  sprintf("Day Cnt:                             %s",
                          object@dccCDS), "\n",
                  sprintf("Freq:                                %s",
                          object@freqCDS), "\n",
                  sprintf("Trade Spread (bp):                   %s",
                          round(object@parSpread, 0)), "\n",
                  sprintf("Coupon (bp):                         %d",
                          round(object@couponRate, 0)), "\n",
                  sprintf("Recovery Rate:                       %.2f",
                          round(object@recRate, 2)), "\n",
                  sep = "")
              cat("\n")
              cat("Calculator \n")
              
              cat(sprintf("Value Date:                          %s",
                          object@valueDate), "\n",
                  sprintf("Upfront:                             %.2f",
                          object@upfront), "\n",
                  sprintf("Principal:                           %.2f",
                          object@principal), "\n",
                  sprintf("Spread DV01:                         %.2f",
                          object@spreadDV01), "\n",
                  sprintf("IR DV01:                             %.2f",
                          object@IRDV01), "\n",
                  sprintf("RecRisk 01:                          %.2f",
                          object@RecRisk01), "\n",
                  sprintf("Default Probability:                 %.3f",
                          object@defaultProb), "\n",
                  sep = ""
                  )
              
              cat("\n")
          
      }
)

