separateYMD <- function(d){
    ## valueDate format valueDate = "2008-02-01"
    dateYear <- as.numeric(format(as.Date(d), "%Y"))
    dateMonth <- as.numeric(format(as.Date(d), "%m"))
    dateDay <- as.numeric(format(as.Date(d), "%d"))
    return(c(dateYear, dateMonth, dateDay))
}
