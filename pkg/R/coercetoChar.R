#' check if argument is not a character and coerce it to character
##
#' @param x input into the function
#' @return true if it is a character 
#' 
cercetoChar <- function(x) {
  if(class(x)!="character"){
    return(as.character(x))
  }
  else{
    return(TRUE)
  }
}