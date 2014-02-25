separateYMD <- function(d){
    ## valueDate format valueDate = "2008-02-01"
    dateYear <- as.numeric(format(as.Date(d), "%Y"))
    dateMonth <- as.numeric(format(as.Date(d), "%m"))
    dateDay <- as.numeric(format(as.Date(d), "%d"))
    return(c(dateYear, dateMonth, dateDay))
}
    
calcUpfront <- function(valueDate, ## valueDateYear, valueDateMonth, valueDateDay,
                        types, dates, rates, nInstr,
                        mmDCC, fixedSwapFreq,
                        floatSwapFreq, fixedSwapDcc, floatSwapDcc,
                        badDayConvZC, holidays,
                        today,
                        benchmarkDate,
                        startDate,
                        endDate,
                        couponRate){
    valueDate <- separateYMD(valueDate)
    today <- separateYMD(today)
    benchmarkDate <- separateYMD(benchmarkDate)
    startDate <- separateYMD(startDate)
    endDate <- separateYMD(endDate)
 
    .Call('calcUpfrontTest',
          valueDate[1], valueDate[2], valueDate[3],
          types, dates, rates, nInstr, mmDCC, fixedSwapFreq,
          floatSwapFreq, fixedSwapDcc, floatSwapDcc, badDayConvZC, holidays,
          today[1],today[2],today[3],
          benchmarkDate[1], benchmarkDate[2], benchmarkDate[3],
          startDate[1],startDate[2],startDate[3],
          endDate[1],endDate[2],endDate[3],
          couponRate)
}


## calcUpfront("2008-01-03",
##             types = "MMMMMSSSSSSSSS",
##             dates = c(20080201, 20080203, 20080205),
##             rates = c(1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9),
##             nInstr = 10,
##             mmDCC = 10,
##             fixedSwapFreq = 10,
##             floatSwapFreq = 10,
##             fixedSwapDcc = 10,
##             floatSwapDcc = 10,
##             badDayConvZC = 'M',
##             holidays = 'None',
##             today = "2008-02-01",
##             benchmarkDate = "2008-02-02",
##             startDate = "2008-02-08",
##             endDate = "2008-02-12",
##             couponRate = 100)
