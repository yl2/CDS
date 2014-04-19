#' Calculate the default exposure of a CDS contract based on the
#' formula: Default Exposure: (1-Recovery Rate)*Notional - Principal
#' 
#' @param recoveryRate in decimal. Default is 0.4
#' @param notional is the notional amount of the CDS contract. Default is 10MM.
#' @param principal is the principal from the CDS contract.
#' @return a number indicating the amount in the event of a default
#' the following day.
#' 

defaultExpo <- function(recoveryRate = 0.4,
                        notional = 1e7,
                        principal){

    return((1-recoveryRate) * notional - principal)
}



