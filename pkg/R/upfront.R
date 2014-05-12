#' Calculate dirty upfront payments from conventional spread
#'
#' @param TDate is when the trade is executed, denoted as T. 
#' @param baseDate is the start date for the IR curve. Default is TDate. 
#' @param currency in which CDS is denominated. 
#' @param types is a string indicating the names of the instruments
#' used for the yield curve. 'M' means money market rate; 'S' is swap
#' rate.
#' @param rates is an array of numeric values indicating the rate of
#' each instrument.
#' @param expiries is an array of characters indicating the maturity
#' of each instrument.
#' @param mmDCC is the day count convention of the instruments.
#' @param fixedSwapFreq is the frequency of the fixed rate of swap
#' being paid.
#' @param floatSwapFreq is the frequency of the floating rate of swap
#' being paid.
#' @param fixedSwapDCC is the day count convention of the fixed leg.
#' @param floatSwapDCC is the day count convention of the floating leg.
#' @param badDayConvZC is a character indicating how non-business days
#' are converted.
#' @param holidays is an input for holiday files to adjust to business
#' days.
#' @param valueDate is the date for which the present value of the CDS
#' is calculated. aka cash-settle date. The default is T + 3.
#' @param benchmarkDate Accrual begin date.
#' @param startDate is when the CDS nomially starts in terms of
#' premium payments, i.e. the number of days in the first period (and
#' thus the amount of the first premium payment) is counted from this
#' date. aka accrual begin date.
#' @param endDate aka maturity date. This is when the contract expires
#' and protection ends. Any default after this date does not trigger a
#' payment.
#' @param stepinDate default is T + 1.
#' @param maturity of the CDS contract.
#' @param dccCDS day count convention of the CDS. Default is ACT/360.
#' @param freqCDS date interval of the CDS contract.
#' @param stubCDS is a character indicating the presence of a stub.
#' @param badDayConvCDS refers to the bay day conversion for the CDS
#' coupon payments. Default is "F", following.
#' @param calendar refers to any calendar adjustment for the CDS.
#' @param parSpread CDS par spread in bps.
#' @param coupon quoted in bps. It specifies the payment amount from
#' the protection buyer to the seller on a regular basis. The default
#' is 100 bps.
#' @param recoveryRate in decimal. Default is 0.4.
#' @param isPriceClean refers to the type of upfront calculated. It is
#' boolean. When \code{TRUE}, calculate principal only. When
#' \code{FALSE}, calculate principal + accrual.
#' @param payAccruedOnDefault is a partial payment of the premium made
#' to the protection seller in the event of a default. Default is
#' \code{TRUE}.
#' @param notional is the amount of the underlying asset on which the
#' payments are based. Default is 1e7, i.e. 10MM.
#' @return a numeric indicating the amount of upfront payments from a
#' protection buyer's perspective.
#' @export
#' 
#' @examples
#' upf <- upfront(baseDate = "2014-01-13", currency = "USD", TDate
#' = "2014-01-14", maturity = "5Y", dccCDS = "ACT/360", freqCDS = "Q",
#' stubCDS = "F", badDayConvCDS = "F", calendar = "None", parSpread =
#' 32, coupon = 100, recoveryRate = 0.4, isPriceClean = FALSE,
#' notional = 1e7)
#' 

upfront <- function(TDate,
                    baseDate = TDate,
                    currency = "USD",

                    types = NULL,
                    rates = NULL,
                    expiries = NULL,
                    mmDCC = "ACT/360",
                    fixedSwapFreq = "6M",
                    floatSwapFreq = "3M",
                    fixedSwapDCC = "30/360",
                    floatSwapDCC = "ACT/360",
                    badDayConvZC = "M",
                    holidays = "None",
                    
                    valueDate = NULL,
                    benchmarkDate = NULL,
                    startDate = NULL,
                    endDate = NULL,
                    stepinDate = NULL,
                    maturity = "5Y",
                    
                    dccCDS = "ACT/360",
                    freqCDS = "1Q",
                    stubCDS = "F",
                    badDayConvCDS = "F",
                    calendar = "None",
                    
                    parSpread,
                    coupon = 100,
                    recoveryRate = 0.4,
                    isPriceClean = FALSE,
                    payAccruedOnDefault = TRUE,
                    notional = 1e7){

    ratesDate <- baseDate
    cdsDates <- getDates(TDate = as.Date(TDate), maturity = maturity)
    if (is.null(valueDate)) valueDate <- cdsDates$valueDate
    if (is.null(benchmarkDate)) benchmarkDate <- cdsDates$startDate
    if (is.null(startDate)) startDate <- cdsDates$startDate
    if (is.null(endDate)) endDate <- cdsDates$endDate
    if (is.null(stepinDate)) stepinDate <- cdsDates$stepinDate

    baseDate <- .separateYMD(baseDate)
    today <- .separateYMD(TDate)
    valueDate <- .separateYMD(valueDate)
    benchmarkDate <- .separateYMD(benchmarkDate)
    startDate <- .separateYMD(startDate)
    endDate <- .separateYMD(endDate)
    stepinDate <- .separateYMD(stepinDate)

    stopifnot(all.equal(length(rates), length(expiries), nchar(types)))    
    if ((is.null(types) | is.null(rates) | is.null(expiries))){
        
        ratesInfo <- getRates(date = ratesDate, currency = as.character(currency))
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

    .Call('calcUpfrontTest',
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
          coupon,
          recoveryRate,
          isPriceClean,
          payAccruedOnDefault,
          notional,
          PACKAGE = "CDS")

}


