#' Calculate conventional spread from upfront
#' 
#' @param TDate is the trade date.
#' @param baseDate is the start date for the IR curve. Default is TDate. baseDate <-
#' "2011-03-04"
#' @param currency is the currency of the CDS. Default is USD.
#' @param types is the types of instruments
#' @param rates is the array of rates of the instruments used to build
#' the IR curve
#' @param expiries is an array of characters indicating the maturity
#' of each instrument. The number of characters in \code{types}, the
#' number of elements in \code{rates}, and the number of elements in
#' \code{expiries} must be the same.
#' @param mmDCC a character detailing the DCC of the MM instruments
#' for the IR curve
#' @param fixedSwapFreq is the frequency of the fixed rate of swap
#' being paid.
#' @param floatSwapFreq is the frequency of the floating rate of swap
#' being paid.
#' @param fixedSwapDCC is the day count convention of the fixed leg.
#' @param floatSwapDCC is the day count convention of the floating leg.
#' @param badDayConvZC is a character indicating how bad days are
#' adjusted. 'M' stands for 'modified following'; 'F' stands for
#' 'following'.
#' @param holidays is an input for holiday files to adjust to in day
#' counting. Default is 'None'.
#' @param valueDate is the date for which the present value of the CDS
#' is calculated. aka cash-settle date. The default is T + 3 bus days.
#' @param benchmarkDate Accrual begin date.
#' @param startDate is when the CDS nomially starts in terms of
#' premium payments, i.e. the number of days in the first period (and
#' thus the amount of the first premium payment) is counted from this
#' date. aka accrual begin date. 
#' @param endDate aka maturity date. This is when the contract expires
#' and protection ends. Any default after this date does not trigger a
#' payment.
#' @param stepinDate aka protection effective date. It's when
#' protection and risk starts in terms of the model. Note the legal
#' effective date is T-60 or T-90 for standard contract. The default
#' is T + 1 bus day.
#' @param maturity is the maturity of the CDS contract. Default is
#' "5Y". It has to be in the format of "NM" or "NY" where "N" is a
#' digit, "M" refers to months, and "Y" refers to years.
#' @param dccCDS is the dcc of the CDS contract. Default is "ACT/360".
#' @param freqCDS is the frequency of the coupon payments being
#' made. Default is "1Q", quarterly payments.
#' @param stubCDS is a character indicating the presence of a stub
#' payment. Default is F.
#' @param badDayConvCDS refers to the bay day conversion for the CDS
#' coupon payments. Default is "F", following.
#' @param calendar refers to any calendar adjustment for the CDS
#' contract. Default is "None".
#' @param upfront the dollar amount for upfront payment
#' @param ptsUpfront the fraction of clean upfront
#' payment. \code{upfront} and \code{ptsUpfront} cannot be NULL at the
#' same time. It is in decimal.
#' @param couponRate in bps.
#' @param recoveryRate in decimal. Default is 0.4.
#' @param payAccruedAtStart determines to whether a clean upfront or a
#' dirty upfront is supplied. When TRUE, clean upfront supplied. When
#' FALSE, dirty upfront is supplied. Default is FALSE.
#' @param notional default is 10mm (1e7)
#' @param payAccruedOnDefault determines whether accrued interest is
#' paid on a default. Default is TRUE, which means that accrued
#' interest will need to be paid by the protection buyer, "False"
#' otherwise.
#' @return a number indicating the spread.
#' 

calcSpread <- function(TDate,
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
                       freqCDS = "Q",
                       stubCDS = "F",
                       badDayConvCDS = "F",
                       calendar = "None",
                       
                       upfront = NULL,
                       ptsUpfront = NULL,
                       couponRate, 
                       recoveryRate = 0.4,
                       payAccruedAtStart = FALSE,
                       notional = 1e7,
                       payAccruedOnDefault = TRUE){

    if (is.null(upfront) & is.null(ptsUpfront))
        stop("Please input upfront or pts upfront")
    
    ratesDate <- baseDate
    if (is.null(ptsUpfront)) {
        ptsUpfront <- upfront / notional
        payAccruedAtStart <- FALSE
    } else {
        payAccruedAtStart <- TRUE
    }
    
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
        
        ratesInfo <- getRates(date = ratesDate, currency = currency)
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

    
    .Call('calcCdsoneSpread',
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
          
          couponRate / 1e4,
          payAccruedOnDefault,
          
          dccCDS,
          freqCDS,
          stubCDS,
          badDayConvCDS,
          calendar,

          ptsUpfront,
          recoveryRate,
          payAccruedAtStart,
          PACKAGE = "CDS")

}
