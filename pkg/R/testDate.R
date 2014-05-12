#' Function for testing the date entered
#
#' @param date date entered
#' @return TRUE if date is valid, FALSE if date is in future, and 
#' "Invalid date format. Must be YYYY-MM-DD" if format is wrong
#' 
testDate <- function(date){
  date <- tryCatch(as.Date(date, format = "%Y-%m-%d"),
                   error = function(e) {
                       return("Invalid date format. Must be YYYY-MM-DD")
                   })
  today <- Sys.Date()
  if (is.na(date)){
      return("Input date invalid")
  } else if (date > today){
      return("Trade date should not be in the future")
  } else if (as.numeric(format(date, "%Y")) < 1994){
      return("Trade date too early!")
  } else {
      return(NA)
  }
} 
