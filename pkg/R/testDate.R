## function for testing the date entered
##
#' @param date date entered
#' @return TRUE if date is valid, FALSE if date is in future, and 
#' "Invalid date format. Must be YYYY-MM-DD" if format is wrong
#' 

testDate <- function(date){
  date <- tryCatch(as.Date(date),  error = function(e) 
  {print(paste("Invalid date format. Must be YYYY-MM-DD"))})
  today <- Sys.Date()
  if(date>today){
      return(FALSE)
  }
  else {
      return(TRUE)
    }
  } 