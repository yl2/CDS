#' Calculate the price of a CDS contract
#'
#' based on the formula Price = (1 - Principal/Notional)*100.
#'
#' @param principal is the principal amount of a CDS contract
#' @param notional is the notional amount of a CDS contract
#' @return a number indicating the price of a CDS contract

price <- function(principal, notional){
    return((1 - principal /  notional)*100)
}
