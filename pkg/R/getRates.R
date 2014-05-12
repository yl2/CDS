#' The function returns the deposits and swap rates for the day
#' input. The day input should be a weekday. If not, go to the most
#' recent weekday.
#'
#' Assume date and currency are in the same location.
#' 
#' @param date ideally a weekday. The rates for a trade date T are
#' published on T-1 weekday.
#' @param currency the three-letter currency code. As of now, it works
#' for USD, EUR, and JPY. The default is USD.
#' 
#' @return a list with two data frames. The first data frame contains
#' the rates based on the ISDA specifications; the second contains all
#' the dcc and calendar specifications of the curve.
#'
#' @export
#' @examples
#'
#' getRates(as.Date("2014-05-07"), currency = "USD")
#' 


getRates <- function(date = Sys.Date(), currency = "USD"){

    ## coerce into character and change to upper case
    stopifnot(toupper(as.character(currency)) %in% c( "USD", "GBP", "EUR",
"JPY", "CHF", "CAD" , "AUD", "NZD", "SGD", "HKD"))
    
    currency <- as.character(currency)
    date <- as.Date(date) - 1

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
    dccDf <- data.frame(effectiveDate = rates$effectiveasof[[1]],
                        badDayConvention = rates$baddayconvention,
                        mmDCC = rates$deposits[['daycountconvention']],
                        mmCalendars = rates$deposits[['calendars']],
                        fixedDCC = rates$swaps[['fixeddaycountconvention']],
                        floatDCC = rates$swaps[['floatingdaycountconvention']],
                        fixedFreq = rates$swaps[['fixedpaymentfrequency']],
                        floatFreq = rates$swaps[['floatingpaymentfrequency']],
                        swapCalendars = rates$swaps[['calendars']])
    
    return(list(ratesDf, dccDf))
}
