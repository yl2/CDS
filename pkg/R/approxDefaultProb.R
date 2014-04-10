#' Approximate the probability to default at time t given the parSpread
#'
#' @param parSpread in bps
#' @param t in years
#' 
approxDefaultProb <- function(parSpread, t, recovery.rate = 0.4){
    ## Bloomberg Approximation
    prob = 1 - exp(-parSpread/1e4*t/(1 - recovery.rate))

    return(prob)

}


