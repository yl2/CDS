#' \code{Date-class} predefined in R
#' @name Date, Date-class
#' @aliases Date, Date-class
#' @docType class
#' @rdname Date
#' @export
#' 

setOldClass(c("Date"))


#' Class definition for the \code{CDS-Class}
#'
#' @slot contract is the contract type, default SNAC
#' @slot entityName is the name of the reference entity. Optional.
#' @slot RED alphanumeric code assigned to the reference entity. Optional.
#' @slot TDate is when the trade is executed, denoted as T. Default
#' is \code{Sys.Date}.
#' @slot baseDate is the start date for the IR curve. Default is TDate. 
#' @slot currency in which CDS is denominated. 
#' @slot types is a string indicating the names of the instruments
#' used for the yield curve. 'M' means money market rate; 'S' is swap
#' rate.
#' @slot rates is an array of numeric values indicating the rate of
#' each instrument.
#' @slot expiries is an array of characters indicating the maturity
#' of each instrument.
#' @slot mmDCC is the day count convention of the instruments.
#' @slot fixedSwapFreq is the frequency of the fixed rate of swap
#' being paid.
#' @slot floatSwapFreq is the frequency of the floating rate of swap
#' being paid.
#' @slot fixedSwapDCC is the day count convention of the fixed leg.
#' @slot floatSwapDCC is the day count convention of the floating leg.
#' @slot badDayConvZC is a character indicating how non-business days
#' are converted.
#' @slot holidays is an input for holiday files to adjust to business
#' days.
#' @slot valueDate is the date for which the present value of the CDS
#' is calculated. aka cash-settle date. The default is T + 3.
#' @slot benchmarkDate Accrual begin date.
#' @slot startDate is when the CDS nomially starts in terms of
#' premium payments, i.e. the number of days in the first period (and
#' thus the amount of the first premium payment) is counted from this
#' date. aka accrual begin date.
#' @slot endDate aka maturity date. This is when the contract expires
#' and protection ends. Any default after this date does not trigger a
#' payment.
#' @slot stepinDate default is T + 1.
#' @slot maturity of the CDS contract.
#' @slot dccCDS day count convention of the CDS. Default is ACT/360.
#' @slot freqCDS date interval of the CDS contract.
#' @slot stubCDS is a character indicating the presence of a stub.
#' @slot badDayConvCDS refers to the bay day conversion for the CDS
#' coupon payments. Default is "F", following.
#' @slot calendar refers to any calendar adjustment for the CDS.
#' @slot parSpread CDS par spread in bps.
#' @slot coupon quoted in bps. It specifies the payment amount from
#' the protection buyer to the seller on a regular basis.
#' @slot recoveryRate in decimal. Default is 0.4.
#' @slot inputPriceClean records the \code{isPriceClean} argument
#' input by the user. \code{isPriceClean} refers to the type of
#' upfront calculated. It is boolean. When \code{TRUE}, calculate
#' principal only. When \code{FALSE}, calculate principal + accrual.
#' @slot notional is the amount of the underlying asset on which the
#' payments are based. Default is 1e7, i.e. 10MM.
#' @slot payAccruedOnDefault is a partial payment of the premium made
#' to the protection seller in the event of a default. Default is
#' \code{TRUE}.
#' @slot principal is the dirty \code{upfront} less the \code{accrual}.
#' @slot accrual is the accrued interest payment.#' 
#' @slot upfront is quoted in the currency amount. Since a standard
#' contract is traded with fixed coupons, upfront payment is
#' introduced to reconcile the difference in contract value due to the
#' difference between the fixed coupon and the conventional par
#' spread. There are two types of upfront, dirty and clean. Dirty
#' upfront, a.k.a. Cash Settlement Amount, refers to the market value
#' of a CDS contract. Clean upfront is dirty upfront less any accrued
#' interest payment, and is also called the Principal.
#' @slot ptsUpfront is quoted as a percentage of the notional
#' amount. They represent the upfront payment excluding the accrual
#' payment. High Yield (HY) CDS contracts are often quoted in points
#' upfront. The protection buyer pays the upfront payment if points
#' upfront are positive, and the buyer is paid by the seller if the
#' points are negative.
#' @slot spreadDV01 measures the sensitivity of a CDS contract
#' mark-to-market to a parallel shift in the term structure of the par
#' spread.
#' @slot IRDV01 is the change in value of a CDS contract for a 1 bp
#' parallel increase in the interest rate curve. \code{IRDV01} is,
#' typically, a much smaller dollar value than \code{spreadDV01}
#' because moves in overall interest rates have a much smaller effect
#' on the value of a CDS contract than does a move in the CDS spread
#' itself.
#' @slot RecRisk01 is the dollar value change in market value if the
#' recovery rate used in the CDS valuation were increased by 1\%.
#' @slot defaultProb is the approximate the default probability at
#' time t given the \code{parSpread}.
#' @slot defaultExpo calculates the default exposure of a CDS contract
#' based on the formula: Default Exposure: (1-Recovery Rate)*Notional
#' - Principal.
#'  
#' @name CDS, CDS-class
#' @aliases CDS, CDS-class
#' @docType class
#' @rdname CDS-class
#' @export
#' 

setClass("CDS",
         representation = representation(
             contract = "character",
             entityName = "character",
             RED = "character",
             TDate = "Date",
             baseDate = "Date",
             currency = "character",
             types = "character",
             rates = "numeric",
             expiries = "character",
             mmDCC = "character",
             effectiveDate = "Date",
             fixedSwapFreq = "character",
             floatSwapFreq = "character",
             fixedSwapDCC = "character",
             floatSwapDCC = "character",
             badDayConvZC = "character",
             holidays = "character",
             valueDate = "Date",
             benchmarkDate = "Date",
             startDate = "Date",
             endDate = "Date",
             stepinDate = "Date",
             backstopDate = "Date",
             firstcouponDate = "Date",
             pencouponDate = "Date",
             maturity = "character",
             dccCDS = "character",
             freqCDS ="character",
             stubCDS ="character",
             badDayConvCDS ="character",
             calendar = "character",
             
             parSpread = "numeric",
             coupon = "numeric",
             recoveryRate = "numeric",
             inputPriceClean = "logical",
             notional = "numeric",
             payAccruedOnDefault = "logical",

             principal = "numeric",
             accrual = "numeric",
             upfront = "numeric",
             ptsUpfront = "numeric",
             spreadDV01 = "numeric",
             IRDV01 = "numeric",
             RecRisk01 = "numeric",
             defaultProb = "numeric",
             defaultExpo = "numeric",
             price = "numeric"
             ),
         prototype = prototype(
             contract = character(),
             entityName = character(),
             RED = character(),
             TDate = character(),
             baseDate = character(),
             currency = character(),
             types = character(),
             rates = numeric(),
             expiries = character(),
             mmDCC = character(),
             effectiveDate = character(),
             fixedSwapFreq = character(),
             floatSwapFreq = character(),
             fixedSwapDCC = character(),
             floatSwapDCC = character(),
             badDayConvZC = character(),
             holidays = character(),
             valueDate = character(),
             benchmarkDate = character(),
             startDate = character(),
             endDate = character(),
             stepinDate = character(),
             backstopDate = character(),
             firstcouponDate = character(),
             pencouponDate = character(),
             maturity = character(),
             dccCDS = character(),
             freqCDS =character(),
             stubCDS =character(),
             badDayConvCDS =character(),
             calendar = character(),
             parSpread = numeric(),
             coupon = numeric(),
             recoveryRate = numeric(),
             inputPriceClean = logical(),
             notional = numeric(),
             payAccruedOnDefault = logical(),
             principal = numeric(),
             accrual = numeric(),
             upfront = numeric(),
             ptsUpfront = numeric(),
             spreadDV01 = numeric(),
             IRDV01 = numeric(),
             RecRisk01 = numeric(),
             defaultProb = numeric(),
             defaultExpo = numeric(),
             price = numeric()
             )
         )

