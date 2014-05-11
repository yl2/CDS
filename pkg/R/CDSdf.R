#' function to convert relevant slots in object of class CDS into a data frame
#'
#'@param object object of class CDS
#'@return returns data frame with relevant data from the CDS function

CDSdf <- function(object){
  CDSdf <- data.frame(TDate = object@TDate,
                      maturity = object@maturity,
                      contract = object@contract,
                      parSpread = round(object@parSpread, digits=2),
                      upfront = round(object@upfront, digits=-4),
                      IRDV01 = round(object@IRDV01, digits=0),
                      price = round(object@price, digits=2),
                      principal = round(object@principal, digits=-3),
                      RecRisk01 = round(object@RecRisk01, digits=-3),
                      defaultExpo = round(object@defaultExpo, digits=-3),
                      spreadDV01 = round(object@spreadDV01, digits=0),
                      currency = object@currency,
                      ptsUpfront = round(object@ptsUpfront, digits=2),
                      freqCDS = object@freqCDS,
                      pencouponDate = object@pencouponDate,
                      backstopDate = object@backstopDate,
                      coupon = object@coupon,
                      recoveryRate = object@recoveryRate,
                      defaultProb = round(object@defaultProb, digits=2),
                      notional = object@notional)
return(CDSdf)
}