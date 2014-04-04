#' Build a CDS class object to include info like the Bloomberg deal
#' and market sections.
#'
#' @param contract is the contract type
#' @param notional is the notional amount, default is 1e7.
#' @param tradeDate is when the trade is executed, denoted as T.
#' @param spread
#' @param couponRate in bps
#' @param DCC day count convention. The default is ACT/360.
#' @param freq
#' @param maturity
#' @param payAccOnDefault is a partial payment of the premium made to
#' the protection seller in the event of a default. Default is TRUE.
#' @param recRate in decimal. Default is 0.4.
#' @param bizDay
#'
#' @param today
#' @param valueDate is the date for which the present value of the CDS
#' is calculated. aka cash-settle date. The default is T + 3.
#' @param benchmarkDate aka curve date, is when the discount curve
#' starts. The default is today.
#' @param instrNames is a string indicating the names of
#' the instruments used for the yield curve. 'M' means money market
#' rate; 'S' is swap rate.
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
#' @param stepinDate aka protection effective date. It's when
#' protection and risk starts in terms of the model. Note the legal
#' effective date is T-60 or T-90 for standard contract. The default
#' is T + 1.
#' @param startDate is when the CDS nomially starts in terms of
#' premium payments, i.e. the number of days in the first period (and
#' thus the amount of the first premium payment) is counted from this
#' date. aka accrual begin date.
#' @param endDate aka maturity date. This is when the contract expires
#' and protection ends. Any default after this date does not trigger a
#' payment.
#' @param entityName is the name of the reference entity. Optional.
#' 

CDS <- function(contract,
                today,
                
                ## deal section
                notional = 1e7,
                tradeDate, ## T 
                spread,
                couponRate,
                DCC,
                freq,
                maturity,
                payAccOnDefault = TRUE,
                recRate = 0.4,

                ## curve
                valueDate, ## T + 3      
                benchmarkDate = today, ## curve date, default is today
                instrNames = "MMMMMSSSSSSSSS", ## Array of 'M' or 'S'
                expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y",
                    "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),
                rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9,
                    1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
                mmDCC,       ## DCC of MM instruments     
                fixedSwapFreq, ## Fixed leg freqency               */
                floatSwapFreq, ## (I) Floating leg freqency            */
                fixedSwapDCC,  ## (I) DCC of fixed leg                 */
                floatSwapDCC,  ## (I) DCC of floating leg              */

                stepinDate, 
                startDate, 
                endDate, 
                entityName = NULL
                ){
    
    cds <- new("CDS",
               contract = contract,
               today = today,
               notional = notional,
               tradeDate = tradeDate,
               spread = spread,
               couponRate = couponRate,
               DCC = DCC,
               
               freq = freq,
               maturity = maturity,
               payAccOnDefault = payAccOnDefault,
               recRate = recRate,
               
               valueDate = valueDate,
               benchmarkDate = benchmarkDate,
               instrNames = instrNames,
               expiries = expiries,
               rates = rates,
               mmDCC = mmDCC,
               fixedSwapFreq = fixedSwapFreq,
               floatSwapFreq = floatSwapFreq,
               fixedSwapDCC = fixedSwapDCC, 
               floatSwapDCC = floatSwapDCC, 
               
               stepinDate = stepinDate, 
               startDate = startDate, 
               endDate = endDate, 
               entityName = entityName)
    ## calculate spreadDV01, IR DV01, price, default exposure?


    return(cds)
    
}
