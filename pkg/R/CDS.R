#' Build a \code{CDS} class object given the input about a CDS
#' contract.
#' 
#' @name CDS
#'
#' @param contract is the contract type, default SNAC
#' @param entityName is the name of the reference entity. Optional.
#' @param RED alphanumeric code assigned to the reference entity. Optional.
#' @param TDate is when the trade is executed, denoted as T. Default
#' is \code{Sys.Date}. The date format should be in "YYYY-MM-DD".
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
#' @param upfront is quoted in the currency amount. Since a standard
#' contract is traded with fixed coupons, upfront payment is
#' introduced to reconcile the difference in contract value due to the
#' difference between the fixed coupon and the conventional par
#' spread. There are two types of upfront, dirty and clean. Dirty
#' upfront, a.k.a. Cash Settlement Amount, refers to the market value
#' of a CDS contract. Clean upfront is dirty upfront less any accrued
#' interest payment, and is also called the Principal.
#' @param ptsUpfront is quoted as a percentage of the notional
#' amount. They represent the upfront payment excluding the accrual
#' payment. High Yield (HY) CDS contracts are often quoted in points
#' upfront. The protection buyer pays the upfront payment if points
#' upfront are positive, and the buyer is paid by the seller if the
#' points are negative.
#' @param isPriceClean refers to the type of upfront calculated. It is
#' boolean. When \code{TRUE}, calculate principal only. When
#' \code{FALSE}, calculate principal + accrual.
#' @param notional is the amount of the underlying asset on which the
#' payments are based. Default is 1e7, i.e. 10MM.
#' @param payAccruedOnDefault is a partial payment of the premium made
#' to the protection seller in the event of a default. Default is
#' \code{TRUE}.
#' 
#' @return a \code{CDS} class object including the input informtion on
#' the contract as well as the valuation results of the contract.
#' 
#' @export
#' @examples
#' # Build a simple CDS class object
#' require(CDS)
#' cds1 <- CDS(TDate = "2014-05-07", parSpread = 50, coupon = 100) 
#' 

CDS <- function(contract = "SNAC", ## CDS contract type, default SNAC
                entityName = NULL,
                RED = NULL,
                
                TDate = Sys.Date(), ## Default is the current date

                ## IR curve
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

                ## CDS 
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

                parSpread = NULL,
                coupon = 100,
                recoveryRate = 0.4,
                upfront = NULL,
                ptsUpfront = NULL,
                isPriceClean = FALSE,
                notional = 1e7,
                payAccruedOnDefault = TRUE
                ){

    checkTDate <- testDate(TDate)
    if (!is.na(checkTDate)) stop (checkTDate)

    if ((is.null(upfront)) & (is.null(ptsUpfront)) & (is.null(parSpread)))
        stop("Please input spread, upfront or pts upfront")

    if (is.null(maturity)) {
        md <- .mondf(TDate, endDate)
        if (md < 12){
            maturity <- paste(md, "M", sep = "", collapse = "")
        } else {
            maturity <- paste(floor(md/12), "Y", sep = "", collapse = "")
        }
    }
    
    ratesDate <- baseDate
    effectiveDate <- as.Date(TDate)
    cdsDates <- getDates(TDate = as.Date(TDate), maturity = maturity)
    if (is.null(valueDate)) valueDate <- cdsDates$valueDate
    if (is.null(benchmarkDate)) benchmarkDate <- cdsDates$startDate
    if (is.null(startDate)) startDate <- cdsDates$startDate
    if (is.null(endDate)) endDate <- cdsDates$endDate
    if (is.null(stepinDate)) stepinDate <- cdsDates$stepinDate
    
    stopifnot(all.equal(length(rates), length(expiries), nchar(types)))    
    if ((is.null(types) | is.null(rates) | is.null(expiries))){
        
        ratesInfo <- getRates(date = ratesDate, currency = currency)
        effectiveDate <- as.Date(as.character(ratesInfo[[2]]$effectiveDate))
        if (is.null(types)) types = paste(as.character(ratesInfo[[1]]$type), collapse = "")
        if (is.null(rates)) rates = as.numeric(as.character(ratesInfo[[1]]$rate))
        if (is.null(expiries)) expiries = as.character(ratesInfo[[1]]$expiry)
        if (is.null(mmDCC)) mmDCC = as.character(ratesInfo[[2]]$mmDCC)
        
        if (is.null(fixedSwapFreq)) fixedSwapFreq = as.character(ratesInfo[[2]]$fixedFreq)
        if (is.null(floatSwapFreq)) floatSwapFreq = as.character(ratesInfo[[2]]$floatFreq)
        if (is.null(fixedSwapDCC)) fixedSwapDCC = as.character(ratesInfo[[2]]$fixedDCC)
        if (is.null(floatSwapDCC)) floatSwapDCC = as.character(ratesInfo[[2]]$floatDCC)
        if (is.null(badDayConvZC)) badDayConvZC = as.character(ratesInfo[[2]]$badDayConvention)
        if (is.null(holidays)) holidays = as.character(ratesInfo[[2]]$swapCalendars)
    }

    if (is.null(entityName)) entityName <- "NA"

    if (is.null(RED)) RED <- "NA"

    cds <- new("CDS",
               contract = as.character(contract),
               entityName = as.character(entityName),
               RED = as.character(RED),
               TDate = as.Date(TDate),
               baseDate = as.Date(baseDate),
               currency = as.character(currency),
               
               types = types,
               rates = rates,
               expiries = expiries,
               mmDCC = mmDCC,

               effectiveDate = effectiveDate,
               fixedSwapFreq = fixedSwapFreq,
               floatSwapFreq = floatSwapFreq,
               fixedSwapDCC = fixedSwapDCC,
               floatSwapDCC = floatSwapDCC,
               badDayConvZC = badDayConvZC,
               holidays = holidays,

               valueDate = as.Date(valueDate),
               benchmarkDate = as.Date(benchmarkDate),
               startDate = as.Date(startDate), 
               endDate = as.Date(endDate), 
               stepinDate = as.Date(stepinDate),
               backstopDate = as.Date(cdsDates$backstopDate),
               firstcouponDate = as.Date(cdsDates$firstcouponDate),
               pencouponDate = as.Date(cdsDates$pencouponDate),
               maturity = maturity,
               
               dccCDS = dccCDS,
               freqCDS = freqCDS,
               stubCDS = stubCDS,
               badDayConvCDS = badDayConvCDS,
               calendar = calendar,

               coupon = coupon,
               recoveryRate = recoveryRate,
               inputPriceClean = isPriceClean,
               notional = notional,
               payAccruedOnDefault = payAccruedOnDefault
               )

    if (!is.null(parSpread)){
        
        ## if parSpread is given, calculate principal and accrual
        cds@parSpread <- parSpread
        cds@principal <- upfront(TDate,
                                 baseDate = baseDate,
                                 currency = currency,
                                 types = types,
                                 rates = rates,
                                 expiries = expiries,
                                 mmDCC = mmDCC,
                                 fixedSwapFreq,
                                 floatSwapFreq,
                                 fixedSwapDCC,
                                 floatSwapDCC,
                                 badDayConvZC,
                                 holidays,
                                 
                                 valueDate, 
                                 benchmarkDate, 
                                 startDate, 
                                 endDate,
                                 stepinDate,
                                 maturity,
                                 
                                 dccCDS,
                                 freqCDS,
                                 stubCDS,
                                 badDayConvCDS,
                                 calendar,
                                 
                                 parSpread,
                                 coupon,
                                 recoveryRate,
                                 TRUE,
                                 payAccruedOnDefault,
                                 notional)
        cds@ptsUpfront <- cds@principal / notional
        cds@upfront <- upfront(TDate,
                               baseDate = baseDate,
                               currency = currency,
                               types = types,
                               rates = rates,
                               expiries = expiries,
                               mmDCC = mmDCC,
                               fixedSwapFreq,
                               floatSwapFreq,
                               fixedSwapDCC,
                               floatSwapDCC,
                               badDayConvZC,
                               holidays,
                               
                               valueDate, 
                               benchmarkDate, 
                               startDate, 
                               endDate,
                               stepinDate,
                               maturity,
                               
                               dccCDS,
                               freqCDS,
                               stubCDS,
                               badDayConvCDS,
                               calendar,
                               
                               parSpread,
                               coupon,
                               recoveryRate,
                               FALSE,
                               payAccruedOnDefault,
                               notional)
       } else if (!is.null(ptsUpfront)){
           cds@ptsUpfront <- ptsUpfront
           cds@parSpread <- spread(TDate,
                                   baseDate,
                                   currency,
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
                                   valueDate,
                                   benchmarkDate,
                                   startDate,
                                   endDate,
                                   stepinDate,
                                   maturity,
                                   dccCDS,
                                   freqCDS,
                                   stubCDS,
                                   badDayConvCDS,
                                   calendar,
                                   upfront,
                                   ptsUpfront,
                                   coupon, 
                                   recoveryRate,
                                   payAccruedAtStart = isPriceClean,
                                   notional,
                                   payAccruedOnDefault)
           cds@principal <- notional * ptsUpfront

           cds@upfront <- upfront(TDate,
                                  baseDate,
                                  currency,
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
                                  valueDate,
                                  benchmarkDate,
                                  startDate,
                                  endDate,
                                  stepinDate,
                                  maturity,
                                  dccCDS,
                                  freqCDS,
                                  stubCDS,
                                  badDayConvCDS,
                                  calendar,
                                  cds@parSpread,
                                  coupon, 
                                  recoveryRate,
                                  FALSE,
                                  payAccruedOnDefault,
                                  notional)
           
       } else {        
           if (isPriceClean == TRUE) {
               cds@principal <- upfront
               cds@ptsUpfront <- upfront / notional
               cds@parSpread <- spread(TDate = TDate,
                                       baseDate = baseDate,
                                       currency = currency,
                                       types = types,
                                       rates = rates,
                                       expiries = expiries,
                                       mmDCC = mmDCC,
                                       fixedSwapFreq = fixedSwapFreq,
                                       floatSwapFreq = floatSwapFreq,
                                       fixedSwapDCC = fixedSwapDCC,
                                       floatSwapDCC = floatSwapDCC,
                                       badDayConvZC = badDayConvZC,
                                       holidays = holidays,
                                       valueDate = valueDate, 
                                       benchmarkDate = benchmarkDate, 
                                       startDate = startDate, 
                                       endDate = endDate,
                                       stepinDate = stepinDate,
                                       maturity = maturity,
                                       dccCDS = dccCDS,
                                       freqCDS = freqCDS,
                                       stubCDS = stubCDS,
                                       badDayConvCDS = badDayConvCDS,
                                       calendar = calendar,
                                       upfront = NULL,
                                       ptsUpfront = cds@ptsUpfront,
                                       coupon = coupon,
                                       recoveryRate = recoveryRate,
                                       payAccruedAtStart = TRUE,
                                       payAccruedOnDefault = payAccruedOnDefault,
                                       notional = notional)
               cds@upfront <- upfront(TDate = TDate,
                                      baseDate = baseDate,
                                      currency = currency,
                                      types = types,
                                      rates = rates,
                                      expiries = expiries,
                                      mmDCC = mmDCC,
                                      fixedSwapFreq = fixedSwapFreq,
                                      floatSwapFreq = floatSwapFreq,
                                      fixedSwapDCC = fixedSwapDCC,
                                      floatSwapDCC = floatSwapDCC,
                                      badDayConvZC = badDayConvZC,
                                      holidays = holidays,
                                      valueDate = valueDate, 
                                      benchmarkDate = benchmarkDate, 
                                      startDate = startDate, 
                                      endDate = endDate,
                                      stepinDate = stepinDate,
                                      maturity = maturity,
                                      dccCDS = dccCDS,
                                      freqCDS = freqCDS,
                                      stubCDS = stubCDS,
                                      badDayConvCDS = badDayConvCDS,
                                      calendar = calendar,
                                      parSpread = cds@parSpread,
                                      coupon = coupon,
                                      recoveryRate = recoveryRate,
                                      isPriceClean = FALSE,
                                      payAccruedOnDefault = payAccruedOnDefault,
                                      notional = notional)
               
               
           } else {
               ## dirty upfront
               cds@upfront <- upfront
               cds@parSpread <- spread(TDate = TDate,
                                       baseDate = baseDate,
                                       currency = currency,
                                       types = types,
                                       rates = rates,
                                       expiries = expiries,
                                       mmDCC = mmDCC,
                                       fixedSwapFreq = fixedSwapFreq,
                                       floatSwapFreq = floatSwapFreq,
                                       fixedSwapDCC = fixedSwapDCC,
                                       floatSwapDCC = floatSwapDCC,
                                       badDayConvZC = badDayConvZC,
                                       holidays = holidays,
                                       valueDate = valueDate, 
                                       benchmarkDate = benchmarkDate, 
                                       startDate = startDate, 
                                       endDate = endDate,
                                       stepinDate = stepinDate,
                                       maturity = maturity,
                                       dccCDS = dccCDS,
                                       freqCDS = freqCDS,
                                       stubCDS = stubCDS,
                                       badDayConvCDS = badDayConvCDS,
                                       calendar = calendar,
                                       upfront = upfront,
                                       ptsUpfront = NULL,
                                       coupon = coupon,
                                       recoveryRate = recoveryRate,
                                       payAccruedAtStart = FALSE,
                                       notional = notional,
                                       payAccruedOnDefault = payAccruedOnDefault)
               
               cds@principal <- upfront(TDate,
                                        baseDate,
                                        currency,
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
                                        valueDate, 
                                        benchmarkDate, 
                                        startDate, 
                                        endDate,
                                        stepinDate,
                                        maturity,
                                        dccCDS,
                                        freqCDS,
                                        stubCDS,
                                        badDayConvCDS,
                                        calendar,
                                        cds@parSpread,
                                        coupon,
                                        recoveryRate,
                                        isPriceClean = TRUE,
                                        payAccruedOnDefault,
                                        notional)
               cds@ptsUpfront <- cds@principal / notional
           }
       }
    
    cds@accrual <- cds@upfront - cds@principal
    
    
    cds@spreadDV01 <- spreadDV01(cds)
    cds@IRDV01 <- IRDV01(cds) 
    cds@RecRisk01 <- recRisk01(cds)
    cds@defaultProb <- defaultProb(parSpread = cds@parSpread,
                                   t = as.numeric(as.Date(endDate) -
                                       as.Date(TDate))/360,
                                   recoveryRate = recoveryRate)
    cds@defaultExpo <- defaultExpo(recoveryRate, notional, cds@principal)
    cds@price <- price(cds@principal, notional)
    
    return(cds)
    
}
    
