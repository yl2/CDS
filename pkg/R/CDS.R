#' Build a CDS class object to include relevant info about a CDS contract
#'
#' @param contract is the contract type, default SNAC
#' @param TDate 
#' @param entityName is the name of the reference entity. Optional.
#' 
#' @param notional is the notional amount, default is 1e7.
#' @param tradeDate is when the trade is executed, denoted as T. Default is today.
#' @param spread CDS par spread in bps
#' @param couponRate in bps
#' @param DCC day count convention of the CDS. The default is ACT/360.
#' @param freq date interval of the CDS contract
#' @param maturity maturity of the CDS contract
#' @param payAccruedOnDefault is a partial payment of the premium made to
#' the protection seller in the event of a default. Default is TRUE.
#' @param recRate in decimal. Default is 0.4.
#'
#' @param types is a string indicating the names of the instruments
#' used for the yield curve. 'M' means money market rate; 'S' is swap
#' rate.
#' @param expiries is an array of characters indicating the maturity
#' of each instrument.
#' @param rates is an array of numeric values indicating the rate of
#' each instrument.
#' @param mmDCC is the day count convention of the instruments.
#' @param fixedSwapFreq is the frequency of the fixed rate of swap
#' being paid.
#' @param floatSwapFreq is the frequency of the floating rate of swap
#' being paid.
#' @param fixedSwapDCC is the day count convention of the fixed leg.
#' @param floatSwapDCC is the day count convention of the floating leg.
#'
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
#' @export
#' 

CDS <- function(contract = "SNAC", ## CDS contract type, default SNAC
                entityName = NULL,

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
                couponRate,
                recoveryRate = 0.4,
                upfront = NULL,
                isPriceClean = FALSE,
                notional = 1e7,
                payAccruedOnDefault = TRUE
                ){

    ## TDate <- baseDate <- "2014-01-14"
    ratesDate <- baseDate
    cdsDates <- getDates(TDate = as.Date(TDate), maturity = maturity)
    if (is.null(valueDate)) valueDate <- cdsDates$valueDate
    if (is.null(benchmarkDate)) benchmarkDate <- cdsDates$startDate
    if (is.null(startDate)) startDate <- cdsDates$startDate
    if (is.null(endDate)) endDate <- cdsDates$endDate
    if (is.null(stepinDate)) stepinDate <- cdsDates$stepinDate
    
    stopifnot(all.equal(length(rates), length(expiries), nchar(types)))    
    if ((is.null(types) | is.null(rates) | is.null(expiries))){
        
        ratesInfo <- getRates(date = ratesDate, currency = currency)
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

    if (is.null(entityName)) entityName <- "Not Provided"

    cds <- new("CDS",
               contract = contract,
               entityName = entityName,
               TDate = as.Date(TDate),
               baseDate = as.Date(baseDate),
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

               valueDate = as.Date(valueDate),
               benchmarkDate = as.Date(benchmarkDate),
               startDate = as.Date(startDate), 
               endDate = as.Date(endDate), 
               stepinDate = as.Date(stepinDate),
               backstopDate = as.Date(cdsDates$backstopDate),
               firstcouponDate = as.Date(cdsDates$firstcouponDate),
               pencouponDate = as.Date(cdsDates$pencouponDate),
               
               dccCDS = dccCDS,
               freqCDS = freqCDS,
               stubCDS = stubCDS,
               badDayConvCDS = badDayConvCDS,
               calendar = calendar,

               couponRate = couponRate,
               recoveryRate = recoveryRate,
               isPriceClean = isPriceClean,
               notional = notional,
               payAccruedOnDefault = payAccruedOnDefault
               )

    if (is.null(parSpread)){
        stopifnot(!is.null(upfront))
        ## if parSpread is not given, i.e. parSpread == NULL, user
        ## gives a principal (when isPriceClean == TRUE) or
        ## principal+accrual (when isPriceClean == FALSE)
        cds@parSpread <- calcSpread(TDate,
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
                                    couponRate, 
                                    recoveryRate,
                                    isPriceClean,
                                    notional,
                                    payAccruedOnDefault)
        
        if (isPriceClean == TRUE) {
            cds@principal <- upfront
            cds@upfront <- calcUpfront(TDate,
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
                                       cds@parSpread,
                                       couponRate,
                                       recoveryRate,
                                       FALSE,
                                       notional)
        } else {
            cds@upfront <- upfront
            cds@principal <- calcUpfront(TDate,
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
                                         couponRate,
                                         recoveryRate,
                                         TRUE,
                                         notional)
        }
    } else {
        ## if parSpread is given, calculate principal and accrual
        cds@parSpread <- parSpread
        cds@principal <- calcUpfront(TDate,
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
                                     couponRate,
                                     recoveryRate,
                                     TRUE,
                                     notional)
        
        cds@upfront <- calcUpfront(TDate,
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
                                   couponRate,
                                   recoveryRate,
                                   FALSE,
                                   notional)
    }
    cds@accrual <- cds@upfront - cds@principal


    cds@spreadDV01 <- calcSpreadDV01(cds)
    cds@IRDV01 <- calcIRDV01(cds) 
    cds@RecRisk01 <- calcRecRisk01(cds)
    cds@defaultProb <- defaultProb(parSpread = cds@parSpread,
                                   t = as.numeric(as.Date(endDate) -
                                       as.Date(TDate))/360,
                                   recoveryRate = recoveryRate)
    cds@defaultExpo <- defaultExpo(recoveryRate, notional, cds@principal)
    cds@price <- price(cds@principal, notional)
    
    return(cds)
    
}
