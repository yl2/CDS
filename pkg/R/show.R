#' The show method for CDS class
#' 
#' @name show
#' @aliases show,show-method
#' @docType methods
#' @rdname show-methods
#' @param object the input CDS class object
#' 

setMethod("show",
          signature(object = "CDS"),
          function(object){

              if (object@entityName == "Not Provided") {
                  cat("CDS Contract \n")
              } else {
                  cat(paste("CDS Contract", object@entityName, sep = " "), "\n")
              }

              cat(sprintf(paste("Contract Type:", object@contract,
                                sep = paste0(rep(" ",
                                    40-.checkLength("Contract Type:") -
                                    .checkLength(object@contract)), collapse = ""))),
                  sprintf(paste("   Currency:", object@currency,
                                sep = paste0(rep(" ",
                                    40-.checkLength("   Currency:") -
                                    .checkLength(object@currency)),
                                    collapse = ""))), "\n",

                  sprintf(paste("Entity Name:", object@entityName,
                                sep = paste0(rep(" ",
                                    40-.checkLength("Entity Name:") -
                                    .checkLength(object@entityName)), collapse = ""))),
                  sprintf(paste("   RED:", object@RED,
                                sep = paste0(rep(" ",
                                    40-.checkLength("   RED:") -
                                    .checkLength(object@RED)),
                                    collapse = ""))), "\n",

                  sprintf(paste("TDate:", object@TDate,
                                sep = paste0(rep(" ", 40-.checkLength("TDate:") -
                                    .checkLength(object@TDate)), collapse = ""))),
                  sprintf(paste("   End Date:", object@endDate,
                                sep = paste0(rep(" ", 40-.checkLength("   End Date:") -
                                    .checkLength(object@endDate)),
                                    collapse = ""))), "\n",

                  sprintf(paste("Start Date:", object@startDate,
                                sep = paste0(rep(" ", 40-.checkLength("Start Date:") -
                                    .checkLength(object@startDate)), collapse = ""))),
                  sprintf(paste("   Backstop Date:", object@backstopDate,
                                sep = paste0(rep(" ", 40-
                                    .checkLength("   Backstop Date:") -
                                    .checkLength(object@backstopDate)),
                                    collapse = ""))), "\n",

                  sprintf(paste("1st Coupon:", object@firstcouponDate,
                                sep = paste0(rep(" ", 40-.checkLength("1st Coupon:") -
                                    .checkLength(object@firstcouponDate)),
                                    collapse = ""))),
                  sprintf(paste("   Pen Coupon:", object@pencouponDate,
                                sep = paste0(rep(" ", 40-
                                    .checkLength("   Pen Coupon:") -
                                    .checkLength(object@pencouponDate)),
                                    collapse = ""))), "\n",

                  sprintf(paste("Day Cnt:", object@dccCDS,
                                sep = paste0(rep(" ",
                                    40-.checkLength("Day Cnt:") -
                                    .checkLength(object@dccCDS)), collapse = ""))),
                  sprintf(paste("   Freq:", object@freqCDS,
                                sep = paste0(rep(" ", 40-.checkLength("   Freq:") -
                                    .checkLength(object@freqCDS)),
                                    collapse = ""))), "\n",
                  sep = ""
                  )

              cat("\n")
              cat("Calculation \n")
              
              cat(sprintf(paste("Value Date:", object@valueDate,
                                sep = paste0(rep(" ",
                                    40-.checkLength("Value Date:") -
                                    .checkLength(object@valueDate)),
                                    collapse = ""))),
                  sprintf(paste("   Price:", round(object@price, 2),
                                sep = paste0(rep(" ", 40-.checkLength("   Price:") -
                                    .checkLength(round(object@price, 2))),
                                    collapse = ""))), "\n",

                  sprintf(paste("Spread:", round(object@parSpread, 4),
                                sep = paste0(rep(" ",
                                    40-.checkLength("Spread:") -
                                    .checkLength(round(object@parSpread, 4))),
                                    collapse = ""))),
                  sprintf(paste("   Pts Upfront:", round(object@ptsUpfront, 4),
                                sep = paste0(rep(" ", 40-.checkLength("   Pts Upfront:") -
                                    .checkLength(round(object@ptsUpfront, 4))),
                                    collapse = ""))), "\n",

                  sprintf(paste("Principal:", round(object@principal, 2),
                                sep = paste0(rep(" ",
                                    40-.checkLength("Principal:") -
                                    .checkLength(round(object@principal, 2))),
                                    collapse = ""))),
                  sprintf(paste("   Spread DV01:", round(object@spreadDV01, 2),
                                sep = paste0(rep(" ", 40-.checkLength("   Spread DV01:") -
                                    .checkLength(round(object@spreadDV01, 2))),
                                    collapse = ""))), "\n",
                  
                  sprintf(paste("Accrual:", round(object@accrual, 2),
                                sep = paste0(rep(" ",
                                    40-.checkLength("Accrual:") -
                                    .checkLength(round(object@accrual, 2))),
                                    collapse = ""))), 
                  sprintf(paste("   IR DV01:", round(object@IRDV01, 2),
                                sep = paste0(rep(" ",
                                    40-.checkLength("   IR DV01:") -
                                    .checkLength(round(object@IRDV01, 2))),
                                    collapse = ""))), "\n",

                  sprintf(paste("Upfront:", round(object@upfront, 2),
                                sep = paste0(rep(" ",
                                    40-.checkLength("Upfront:") -
                                    .checkLength(round(object@upfront, 2))),
                                    collapse = ""))), 
                  sprintf(paste("   Rec Risk (1 pct):", round(object@RecRisk01, 2),
                                sep = paste0(rep(" ", 40-.checkLength("   Rec Risk (1 pct):") -
                                    .checkLength(round(object@RecRisk01, 2))),
                                    collapse = ""))), "\n",

                  sprintf(paste("Default Prob:", round(object@defaultProb, 4),
                                sep = paste0(rep(" ",
                                    40-.checkLength("Default Prob:") -
                                    .checkLength(round(object@defaultProb, 4))),
                                    collapse = ""))), 
                  sprintf(paste("   Default Expo:", round(object@defaultExpo, 2),
                                sep = paste0(rep(" ", 40-.checkLength("   Default Expo:") -
                                    .checkLength(round(object@defaultExpo, 2))),
                                    collapse = ""))), "\n",

                  sep = ""
                  )
              cat("\n")
              cat("Credit Curve \n")

              ratesDf <- data.frame(Term = object@expiries, Rate = object@rates)
              rowN <- ceiling(dim(ratesDf)[1]/2)
              
              print(cbind.fill(ratesDf[1:rowN,], ratesDf[(rowN+1):dim(ratesDf)[1],]),
                    row.names = F, quote = F, na.print = "")
              
              cat("\n")
          
      }
)

