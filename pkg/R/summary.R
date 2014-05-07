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
                  sprintf(paste("Spread:",
                                format(round(object@parSpread, 4),big.mark = ",",
                                       scientific=F),
                                sep = paste0(rep(" ",
                                    40-.checkLength("Spread:") -
                                    .checkLength(
                                        format(round(object@parSpread, 4), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))),
                  sprintf(paste("   Coupon:",
                                format(object@coupon, big.mark = ",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.checkLength("   Coupon:") -
                                    .checkLength(format(object@coupon, big.mark=",",
                                                        scientific=F))),
                                    collapse = ""))), "\n",
                  
                  sprintf(paste("Upfront:",
                                format(round(object@upfront, 0),big.mark=",",
                                       scientific =F ),
                                sep = paste0(rep(" ",
                                    40-.checkLength("Upfront:") -
                                    .checkLength(
                                        format(round(object@upfront, 0),
                                               big.mark=",", scientific=F))),
                                    collapse = ""))),
                  sprintf(paste("   Spread DV01:",
                                format(round(object@spreadDV01, 0), big.mark = ",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.checkLength("   Spread DV01:") -
                                    .checkLength(
                                        format(round(object@spreadDV01, 0), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), "\n",

                  sprintf(paste("IR DV01:",
                                format(round(object@IRDV01, 2),big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ",
                                    40-.checkLength("IR DV01:") -
                                    .checkLength(
                                        format(round(object@IRDV01, 2), big.mark=",",
                                               scientific=F))),
                                    collapse = ""))),
                  sprintf(paste("   Rec Risk (1 pct):",
                                format(round(object@RecRisk01, 2),big.mark=",",
                                       scientific=F),
                                sep = paste0(rep(" ", 40-.checkLength("   Rec Risk (1 pct):") -
                                    .checkLength(
                                        format(round(object@RecRisk01, 2),
                                               big.mark=",",
                                               scientific=F))),
                                    collapse = ""))), "\n",
                  sep = ""
                  )
              
              cat("\n")
          }
          )


