#' The function gets relevant coupon dates for a CDS contract.
#' 
#' @param TDate the trade date
#' @param maturity maturity of the CDS contract. default "5Y"
#' @return a date frame with step-in date (T+1), value date (T+3
#' business days), start date (accrual begin date), end date
#' (maturity), backstop date (T-60 day look back from which
#' 'protection' is effective), pen coupon date (second to last coupon
#' date)

getDates <- function(TDate, maturity = "5Y"){

    ## check maturity. Has to be "6M" of "NY" where N is an integer
    duration <- gsub("[[:digit:]]", "", maturity)
    if (!(duration %in% c("M", "Y"))) stop ("Maturity must end with 'M' or 'Y'")
    length <- as.numeric(gsub("[^[:digit:]]", "", maturity))
    
    ## TDate T
    dateWday <- as.POSIXlt(TDate)$wday
    if (!(dateWday %in% c(1:5))) stop("TDate must be a weekday")

    ## stepinDate T + 1 bus day
    stepinDate <- .adjNextBusDay(TDate + 1)

    ## valueDate T + 3 bus day
    valueDate <- stepinDate
    for (i in 1:2){valueDate <- .adjNextBusDay(valueDate + 1)}
    
    ## startDate accrual date
    startDate <- .getFirstAccrualDate(TDate)

    ## firstcouponDate the next IMM date approx after
    ## startDate. adjust to bus day
    firstcouponDate <- as.POSIXlt(startDate)
    firstcouponDate$mon <- firstcouponDate$mon + 3
    firstcouponDate <- as.Date(.adjNextBusDay(firstcouponDate))
    
    ## endDate firstcouponDate + maturity. IMM dates. No adjustment.
    endDate <- as.POSIXlt(firstcouponDate)
    if (duration == "M"){
        endDate$mon <- endDate$mon + length
    } else {
        endDate$year <- endDate$year + length
    }
    endDate <- as.Date(endDate)
    
    ## pencouponDate T + maturity - 1 accrual interval. adj to bus day
    pencouponDate <- as.POSIXlt(endDate)
    pencouponDate$mon <- pencouponDate$mon - 3
    pencouponDate <- as.Date(.adjNextBusDay(pencouponDate))
    
    ## backstopDate T - 60
    backstopDate <- TDate - 60

    return(data.frame(TDate, stepinDate, valueDate, startDate,
                      firstcouponDate, pencouponDate, endDate, 
                      backstopDate))
    
}
