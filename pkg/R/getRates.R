#' The function returns the deposits and swap rates for the day
#' input. The day input should be a weekday. If not, go to the most
#' recent weekday.
#'
#' Assume date and currency are in the same location.
#' 
#' @param date ideally a weekday. The effective date of the rates is T
#' + 1.
#' @param currency the three-letter currency code
#' @return a list with two data frames. The first data frame contains
#' the rates based on the ISDA specifications; the second contains all
#' the dcc and calendar specifications of the curve.
#'
#' 


getRates <- function(date, currency = "USD"){

    stopifnot(currency %in% c("USD", "EUR", "JPY"))

    date <- as.Date(date)
    ## determine whether the input date is today according to the currency

    if (date == Sys.Date()){
        ## compare current time with deadlines with respect to the
        ## input currency. If not past deadline, do T-1; otherwise use
        ## input date.
        if (currency == "USD"){
            ## check daylight saving. Positive means there is daylight
            ## saving
            if (as.POSIXlt(Sys.time())$isdst > 0){
                if (((as.POSIXlt(Sys.time(), tz = "UTC")$hour - 4) * 100 +
                     as.POSIXlt(Sys.time(), tz = "UTC")$min) <= 1730)
                    date <- date - 1
            } else {
                ## no daylight saving
                if (((as.POSIXlt(Sys.time(), tz = "UTC")$hour - 5) * 100 +
                     as.POSIXlt(Sys.time(), tz = "UTC")$min) <= 1730)
                    date <- date - 1
            }
        } else if (currency == "EUR"){
            date <- date - 1
            ## use Frankfurt time zone, standard tz UTC + 1
            if (as.POSIXlt(Sys.time())$isdst > 0){
                if (((as.POSIXlt(Sys.time(), tz = "UTC")$hour + 2) * 100 +
                     as.POSIXlt(Sys.time(), tz = "UTC")$min) <= 1730)
                    date <- date - 1
            } else {
                ## no daylight saving
                if (((as.POSIXlt(Sys.time(), tz = "UTC")$hour + 1) * 100 +
                     as.POSIXlt(Sys.time(), tz = "UTC")$min) <= 1730)
                    date <- date - 1
            }
        } else if (currency == "JPY"){
            date <- date - 1
            ## use London time zone, standard tz is UTC
            if (as.POSIXlt(Sys.time())$isdst > 0){
                if (((as.POSIXlt(Sys.time(), tz = "UTC")$hour + 1) * 100 +
                     as.POSIXlt(Sys.time(), tz = "UTC")$min) <= 1430)
                    date <- date - 1
            } else {
                ## no daylight saving
                if ((as.POSIXlt(Sys.time(), tz = "UTC")$hour * 100 +
                     as.POSIXlt(Sys.time(), tz = "UTC")$min) <= 1430)
                    date <- date - 1
            }
        }
    } else if (currency == "JPY") date <- date - 1    
    
    ## 0 is Sunday, 6 is Saturday
    dateWday <- as.POSIXlt(date)$wday
    ## change date to the most recent weekday if necessary
    if (dateWday == 0){
        date <- date - 2
    } else if (dateWday == 6) {
        date <- date - 1
    }
    
    dateInt <- as.numeric(format(date, "%Y%m%d"))
    ratesURL <- paste("https://www.markit.com/news/InterestRates_",
                      currency, "_", dateInt, ".zip", sep ="")
    xmlParsedIn <- .downloadRates(ratesURL)
    
    rates <- xmlSApply(xmlParsedIn, function(x) xmlSApply(x, xmlValue))
    
    curveRates <- c(rates$deposits[names(rates$deposits) == "curvepoint"],
                    rates$swaps[names(rates$swaps) == "curvepoint"])
    
    
    df <- do.call(rbind, strsplit(curveRates, split = "[MY]", perl = TRUE))
    rownames(df) <- NULL
    df <- cbind(df, "Y")
    df[1: (max(which(df[,1] == 1)) - 1), 3] <- "M"
    
    ratesDf <- data.frame(expiry = paste(df[,1], df[,3], sep = ""),
                          matureDate = substring(df[,2], 0, 10),
                          rate = substring(df[,2], 11),
                          type = c(rep("M", sum(names(rates$deposits) == "curvepoint")),
                              rep("S", sum(names(rates$swaps) == "curvepoint"))))
    dccDf <- data.frame(badDayConvention = rates$baddayconvention,
                        mmDCC = rates$deposits[['daycountconvention']],
                        mmCalendars = rates$deposits[['calendars']],
                        fixedDCC = rates$swaps[['fixeddaycountconvention']],
                        floatDCC = rates$swaps[['floatingdaycountconvention']],
                        fixedFreq = rates$swaps[['fixedpaymentfrequency']],
                        floatFreq = rates$swaps[['floatingpaymentfrequency']],
                        swapCalendars = rates$swaps[['calendars']])
    
    return(list(ratesDf, dccDf))
}
