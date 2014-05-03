#' The summary method displays only the essential info about the CDS
#' class object.
#' 

setMethod("summary",
          signature(object = "CDS"),
          function(object,
                   ...){

              cat(sprintf(paste("Contract Type:", object@contract,
                                sep = paste0(rep(" ",
                                    40-.checkLength("Contract Type:") -
                                    .checkLength(object@contract)), collapse = ""))),
                  sprintf(paste("   TDate:", object@TDate,
                                sep = paste0(rep(" ", 40-.checkLength("   TDate:") -
                                    .checkLength(object@TDate)), collapse = ""))), "\n",

                  
                  sprintf(paste("Entity Name:", object@entityName,
                                sep = paste0(rep(" ",
                                    40-.checkLength("Entity Name:") -
                                    .checkLength(object@entityName)), collapse = ""))),
                  sprintf(paste("   RED:", object@RED,
                                sep = paste0(rep(" ", 40-.checkLength("   RED:") -
                                    .checkLength(object@RED)), collapse = ""))), "\n",
                  
                  sprintf(paste("Currency:", object@currency,
                                sep = paste0(rep(" ",
                                    40-.checkLength("Currency:") -
                                    .checkLength(object@currency)), collapse = ""))),
                  sprintf(paste("   End Date:", object@endDate,
                                sep = paste0(rep(" ", 40-.checkLength("   End Date:") -
                                    .checkLength(object@endDate)), collapse = ""))), "\n",
                  sprintf(paste("Spread:", round(object@parSpread, 4),
                                sep = paste0(rep(" ",
                                    40-.checkLength("Spread:") -
                                    .checkLength(round(object@parSpread, 4))), collapse = ""))),
                  sprintf(paste("   Coupon Rate:", object@couponRate,
                                sep = paste0(rep(" ", 40-.checkLength("   Coupon Rate:") -
                                    .checkLength(object@couponRate)),
                                    collapse = ""))), "\n",
                  
                  sprintf(paste("Upfront:", round(object@upfront, 2),
                                sep = paste0(rep(" ",
                                    40-.checkLength("Upfront:") -
                                    .checkLength(round(object@upfront, 2))),
                                    collapse = ""))),
                  sprintf(paste("   Spread DV01:", round(object@spreadDV01, 2),
                                sep = paste0(rep(" ", 40-.checkLength("   Spread DV01:") -
                                    .checkLength(round(object@spreadDV01, 2))),
                                    collapse = ""))), "\n",

                  sprintf(paste("IR DV01:", round(object@IRDV01, 2),
                                sep = paste0(rep(" ",
                                    40-.checkLength("IR DV01:") -
                                    .checkLength(round(object@IRDV01, 2))),
                                    collapse = ""))),
                  sprintf(paste("   Rec Risk (1 pct):", round(object@RecRisk01, 2),
                                sep = paste0(rep(" ", 40-.checkLength("   Rec Risk (1 pct):") -
                                    .checkLength(round(object@RecRisk01, 2))),
                                    collapse = ""))), "\n",
                  sep = ""
                  )
              
              cat("\n")
          }
          )


