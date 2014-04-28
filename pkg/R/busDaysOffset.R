busDaysOffset <- function(fromDate, offset, holidays = NULL){
    fromDate <- .separateYMD(fromDate)
    
    .Call('busDaysOffset',
          fromDate,
          offset,
          holidays,
          PACKAGE = 'CDS')
}
