.separateYMD <- function(d){
    ## valueDate format valueDate = "2008-02-01"
    dateYear <- as.numeric(format(as.Date(d), "%Y"))
    dateMonth <- as.numeric(format(as.Date(d), "%m"))
    dateDay <- as.numeric(format(as.Date(d), "%d"))
    return(c(dateYear, dateMonth, dateDay))
}


## download the rates zip file from a given URL. Unzip and parse the
## XML
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
#' @param date of Date class.
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


#' Get the first accrual date. If it's a weekend, adjust to the
#' following weekday. March/Jun/Sept/Dec 20th
#'
#' @param TDate of Date class
#' @return Date class object

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


.checkLength <- function(dat){
    return(nchar(as.character(dat)))
}


## month diff
monnb <- function(d) {
    lt <- as.POSIXlt(as.Date(d, origin="1900-01-01"))
    lt$year*12 + lt$mon
} 
## compute a month difference as a difference between two monnb's
mondf <- function(d1, d2) { monnb(d2) - monnb(d1) }





cbind.fill<-function(...){
    nm <- list(...) 
    nm <- lapply(nm, as.matrix)
    n <- max(sapply(nm, nrow)) 
    do.call(cbind, lapply(nm, function (x) 
                          rbind(x, matrix(, n-nrow(x), ncol(x))))) 
}
