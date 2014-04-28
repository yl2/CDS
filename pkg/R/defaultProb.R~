#' Approximate the default probability at time t given the parSpread
#'
#' @param parSpread in bps
#' @param t in years
#' @param recoveryRate in decimal. Default is 0.4.
#' 
approxDefaultProb <- function(parSpread, t, recoveryRate = 0.4){
    ## Bloomberg Approximation
    prob = 1 - exp(-parSpread/1e4*t/(1 - recoveryRate))

    return(prob)

}


