#' Build a CDS class object to include info like the Bloomberg deal
#' and market sections.
#'
#' @param contract is the contract type, default SNAC
#' @param today present date, default is the current date
#' @param entityName is the name of the reference entity. Optional.
#' 
#' @param notional is the notional amount, default is 1e7.
#' @param tradeDate is when the trade is executed, denoted as T. Default is today.
#' @param spread CDS par spread in bps
#' @param couponRate in bps
#' @param DCC day count convention of the CDS. The default is ACT/360.
#' @param freq
#' @param maturity
#' @param payAccOnDefault is a partial payment of the premium made to
#' the protection seller in the event of a default. Default is TRUE.
#' @param recRate in decimal. Default is 0.4.
#' @param bizDay
#' 
#'
#' @param userCurve boolean. if TRUE, user has to specify the IR
#' curve; if FALSE, grab historical data from Markit.
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
#' @param stepinDate aka protection effective date. It's when
#' protection and risk starts in terms of the model. Note the legal
#' effective date is T-60 or T-90 for standard contract. The default
#' is T + 1.
#' 
#' 

CDS <- function(contract = "SNAC", ## CDS contract type, default SNAC
                today = Sys.Date(), ## present date, default is the current date
                entityName = NULL,
                
                ## deal section
                notional = 1e7,
                currency = "USD",
                TDate = today, ## T, default same as today
                spread,
                couponRate,

                dccCDS = "ACT/360",
                freqCDS = "1Q",
                stubCDS = "f/s",
                badDayConvCDS = "F",
                calendarCDS = "None",

                maturity, ## input 5Y or 10Y
                payAccOnDefault = TRUE,
                recRate = 0.4,
                
                ## curve
                userCurve = FALSE,
                baseDate = today,
                types = NULL,
                rates = NULL,
                expiries = NULL,
                mmDCC = NULL,
                fixedSwapFreq = NULL,
                floatSwapFreq = NULL,
                fixedSwapDCC = NULL,
                floatSwapDCC = NULL,
                badDayConvZC = NULL,
                holidays = NULL,

                valueDate = today + 3, ## T + 3      
                benchmarkDate, ## accrual begin date
                startDate, 
                endDate, 
                stepinDate = today + 1 

                ){

    cds <- new("CDS",
               contract = contract,
               entityName = entityName,
               today = today,
               notional = notional,
               currency = currency,
               TDate = TDate,
               spread = spread,
               couponRate = couponRate,
               dccCDS = dccCDS,
               freqCDS = freqCDS,
               stubCDS = stubCDS,
               badDayConvCDS = badDayConvCDS,
               calendarCDS = calendarCDS,
               maturity = maturity,
               payAccOnDefault = payAccOnDefault,
               recRate = recRate,
               userCurve = userCurve,
               baseDate = baseDate,
               valueDate = valueDate,
               benchmarkDate = benchmarkDate,
               startDate = startDate, 
               endDate = endDate, 
               stepinDate = stepinDate)


    ## user doesn't specify the IR curve
    if (userCurve == FALSE){
        ratesInfo <- getRates(date = baseDate, currency = currency)
        
        cds@types = paste(as.character(ratesInfo[[1]]$type), collapse = "")
        cds@rates = as.numeric(as.character(ratesInfo[[1]]$rate))
        cds@expiries = as.character(ratesInfo[[1]]$expiry)
        cds@mmDCC = as.character(ratesInfo[[2]]$mmDCC)
        
        cds@fixedSwapFreq = as.character(ratesInfo[[2]]$fixedFreq)
        cds@floatSwapFreq = as.character(ratesInfo[[2]]$floatFreq)
        cds@fixedSwapDCC = as.character(ratesInfo[[2]]$fixedDCC)
        cds@floatSwapDCC = as.character(ratesInfo[[2]]$floatDCC)
        cds@badDayConvZC = as.character(ratesInfo[[2]]$badDayConvention)
        cds@holidays = as.character(ratesInfo[[2]]$swapCalendars)
    } else {
        cds@types = types
        cds@rates = rates
        cds@expiries = expiries
        cds@mmDCC = mmDCC
        
        cds@fixedSwapFreq = fixedSwapFreq
        cds@floatSwapFreq = floatSwapFreq
        cds@fixedSwapDCC = fixedSwapDCC
        cds@floatSwapDCC = floatSwapDCC
        cds@badDayConvZC = badDayConvZC
        cds@holidays = holidays
    }

    cds@upfront <- calcUpfront(baseDate = baseDate,
                               currency = currency,
                               userCurve = userCurve,

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
                               
                               today = today,
                               valueDate = valueDate,
                               benchmarkDate = benchmarkDate,
                               startDate = startDate,
                               endDate = endDate,
                               stepinDate = stepinDate,
                               
                               dccCDS = dccCDS,
                               freqCDS = freqCDS,
                               stubCDS = stubCDS,
                               badDayConvCDS = badDayConvCDS,
                               calendar = calendarCDS,
                               parSpread = spread,
                               couponRate = couponRate,
                               recoveryRate = recRate,
                               notional = notional)

    cds@spreadDV01 <- calcSpreadDV01(baseDate = baseDate,
                                     currency = currency,
                                     userCurve = userCurve,
                                     
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
                                     
                                     today = today,
                                     valueDate = valueDate,
                                     benchmarkDate = benchmarkDate,
                                     startDate = startDate,
                                     endDate = endDate,
                                     stepinDate = stepinDate,
                                     
                                     dccCDS = dccCDS,
                                     freqCDS = freqCDS,
                                     stubCDS = stubCDS,
                                     badDayConvCDS = badDayConvCDS,
                                     calendar = calendarCDS,
                                     parSpread = spread,
                                     couponRate = couponRate,
                                     recoveryRate = recRate,
                                     notional = notional)

    cds@IRDV01 <- calcIRDV01(baseDate = baseDate,
                             currency = currency,
                             userCurve = userCurve,
                             
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
                             
                             today = today,
                             valueDate = valueDate,
                             benchmarkDate = benchmarkDate,
                             startDate = startDate,
                             endDate = endDate,
                             stepinDate = stepinDate,
                             
                             dccCDS = dccCDS,
                             freqCDS = freqCDS,
                             stubCDS = stubCDS,
                             badDayConvCDS = badDayConvCDS,
                             calendar = calendarCDS,
                             parSpread = spread,
                             couponRate = couponRate,
                             recoveryRate = recRate,
                             notional = notional)

    cds@RecRisk01 <- calcRecRisk01(baseDate = baseDate,
                                   currency = currency,
                                   
                                   userCurve = userCurve,
                                   
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
                                   
                                   today = today,
                                   valueDate = valueDate,
                                   benchmarkDate = benchmarkDate,
                                   startDate = startDate,
                                   endDate = endDate,
                                   stepinDate = stepinDate,
                                   
                                   dccCDS = dccCDS,
                                   freqCDS = freqCDS,
                                   stubCDS = stubCDS,
                                   badDayConvCDS = badDayConvCDS,
                                   calendar = calendarCDS,
                                   parSpread = spread,
                                   couponRate = couponRate,
                                   recoveryRate = recRate,
                                   notional = notional)
    
    cds@defaultProb <- approxDefaultProb(parSpread = spread,
                                         t = as.numeric(as.Date(endDate) -
                                             as.Date(today))/360,
                                         recoveryRate = recRate)
    
    

    

    return(cds)
    
}
