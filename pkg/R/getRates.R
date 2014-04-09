#' The function returns the deposits and swap rates for the day
#' input. The day input should be a weekday. If not, go to the most
#' recent weekday.
#' 
#' @param date ideally a weekday. The effective date of the rates is T
#' + 1.
#' @param currency the three-letter currency code
#' @return data frame containing the rates based on the ISDA
#' specifications
#'
#' @references
#' \url{"http://www.cdsmodel.com/assets/cds-model/docs/Interest%20Rate%20Curve%20Specification%20-%20All%20Currencies%20%28Updated%20May%202013%29.pdf"}
#' 

getRates <- function(date, currency = "USD"){
    
    date <- as.Date(date)

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
    
    ratesDf <- data.frame(expiries = paste(df[,1], df[,3], sep = ""),
                          matureDates = substring(df[,2], 0, 10),
                          rates = substring(df[,2], 11))
    return(ratesDf)
}
