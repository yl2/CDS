#' Helper function to separate an input date into year, month, and
#' day.
#'
#' @param d is an input date.
#' @return an array contains year, month, date of the input date
#' \code{d}.
#' 
.separateYMD <- function(d){
    ## valueDate format valueDate = "2008-02-01"
    dateYear <- as.numeric(format(as.Date(d), "%Y"))
    dateMonth <- as.numeric(format(as.Date(d), "%m"))
    dateDay <- as.numeric(format(as.Date(d), "%d"))
    return(c(dateYear, dateMonth, dateDay))
}


#' download the rates zip file from a given URL. Unzip and parse the
#' XML
#'
#' @param URL is the link containing the rates.
#' @param verbose option. Default \code{FALSE}.
#'
#' @return a xml file crawled from the \code{URL}.
#' 
.downloadRates <- function(URL, verbose = FALSE){ 
    tf <- tempfile()
    td <- tempdir()
    download.file(URL, tf , method = "curl", quiet = 1-verbose, mode = 'wb')
    files <- unzip(tf , exdir = td)
    
    ## the 2nd file of the unzipped directory contains the rates info
    doc <- xmlTreeParse(files[grep(".xml", files)], getDTD = F)
    r <- xmlRoot(doc)
    return(r)
}


#' get the next business day following 5D bus day convention.
#'
#' @param date of \code{Date} class.
#' @return Date adjusted to the following business day

.adjNextBusDay <- function(date){
    
    dateWday <- as.POSIXlt(date)$wday
    ## change date to the most recent weekday if necessary
    if (dateWday == 0){
        date <- date + 1
    } else if (dateWday == 6) {
        date <- date + 2
    }
    return(date)
}


#' function to convert relevant slots in object of class CDS into a data frame
#'
#'@param object object of class CDS
#'@return returns data frame with relevant data from the CDS function
CDSdf <- function(object){
  CDSdf <- data.frame(TDate = object@TDate,
                      maturity = object@maturity,
                      contract = object@contract,
                      parSpread = round(object@parSpread, digits=2),
                      upfront = round(object@upfront, digits=-4),
                      IRDV01 = round(object@IRDV01, digits=0),
                      price = round(object@price, digits=2),
                      principal = round(object@principal, digits=-3),
                      RecRisk01 = round(object@RecRisk01, digits=-3),
                      defaultExpo = round(object@defaultExpo, digits=-3),
                      spreadDV01 = round(object@spreadDV01, digits=0),
                      currency = object@currency,
                      ptsUpfront = round(object@ptsUpfront, digits=2),
                      freqCDS = object@freqCDS,
                      pencouponDate = object@pencouponDate,
                      backstopDate = object@backstopDate,
                      coupon = object@coupon,
                      recoveryRate = object@recoveryRate,
                      defaultProb = round(object@defaultProb, digits=2),
                      notional = object@notional)
  return(CDSdf)
}


#' Get the first accrual date. If it's a weekend, adjust to the
#' following weekday. March/Jun/Sept/Dec 20th
#'
#' @param TDate of \code{Date} class
#' @return a \code{Date} class object

.getFirstAccrualDate <- function(TDate){

    date <- as.POSIXlt(TDate)

    ## get the remainder X after dividing it by 3 and then move back X
    ## month
    if (date$mon %in% c(2, 5, 8, 11)){
        if (date$mday < 20)
            date$mon <- date$mon - 3
    } else { 
        date$mon <- date$mon - (as.numeric(format(date, "%m")) %% 3)
    }
    date$mday <- 20
    accrualDate <- .adjNextBusDay(as.Date(as.POSIXct(date)))

    return(accrualDate)
}

#' check the length of the input
#'
#' @param dat is a string
#' @return a numeric indicating the length of the input string.
.checkLength <- function(dat){
    return(nchar(as.character(dat)))
}

#' check if argument is not a character and coerce it to character
##
#' @param x input into the function
#' @return true if it is a character 
#' 
.coercetoChar <- function(x) {
  if(class(x)!="character"){
    return(as.character(x))
  }
  else{
    return(x)
  }
}


#' month difference
#' @param d date 
.monnb <- function(d) {
    lt <- as.POSIXlt(as.Date(d, origin="1900-01-01"))
    lt$year*12 + lt$mon
} 


#' compute a month difference as a difference between two monnb's
#' @param d1 date 1
#' @param d2 date 2
#' @return month difference as a difference between two monnb's
#' 
.mondf <- function(d1, d2) { .monnb(d2) - .monnb(d1) }





.cbind.fill<-function(...){
    nm <- list(...) 
    nm <- lapply(nm, as.matrix)
    n <- max(sapply(nm, nrow)) 
    do.call(cbind, lapply(nm, function (x) 
                          rbind(x, matrix(, n-nrow(x), ncol(x))))) 
}
