## calcSpread.test.R

library(CDS)

## truth1 <- calcSpread(TDate = "2014-01-14",
##                      currency = "USD",

##                      types = "MMMMMSSSSSSSSS",
##                      rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
##                      expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),

##                      mmDCC = "Act/360",
##                      fixedSwapFreq = "6M",
##                      floatSwapFreq = "6M",
##                      fixedSwapDCC = "30/360",
##                      floatSwapDCC = "30/360",
##                      badDayConvZC = 'M',
##                      holidays = 'None',

##                      valueDate = "2014-01-17",
##                      benchmarkDate = "2013-12-20",
##                      startDate = "2013-12-20",
##                      endDate = "2019-03-20",
##                      stepinDate = "2014-01-15",

##                      dccCDS = "ACT/360",
##                      freqCDS = 'Q',		  
##                      stubCDS = "F", 		
##                      badDayConvCDS = "F",
##                      calendar = 'None',

##                      upfront = -1e7*3.48963/100,
##                      couponRate = 100, 
##                      recoveryRate = .4,
##                      payAccruedAtStart = FALSE,
##                      notional = 1e7,
##                      payAccruedOnDefault = TRUE)



## truth2 <- calcSpread(TDate = "2014-01-14",
##                      baseDate = "2014-01-13",
##                      currency = "USD",
##                      maturity = "5Y",

##                      dccCDS = "ACT/360",
##                      freqCDS = 'Q',		  
##                      stubCDS = "F", 		
##                      badDayConvCDS = "F",
##                      calendar = 'None',

##                      upfront = -1e7*3.41/100,
##                      couponRate = 100, 
##                      recoveryRate = .4,
##                      payAccruedAtStart = TRUE,
##                      notional = 1e7,
##                      payAccruedOnDefault = TRUE)

## save(truth1, truth2, file = "calcSpread.test.RData")

load("calcSpread.test.RData")

result1 <- calcSpread(TDate = "2014-01-14",
                      currency = "USD",
                      
                      types = "MMMMMSSSSSSSSS",
                      rates = c(1.550e-3, 1.993e-3, 2.344e-3, 3.320e-3, 5.552e-3, 5.130e-3, 9.015e-3, 1.3240e-2, 1.7105e-2, 2.0455e-2, 2.3205e-2, 2.5405e-2, 2.7230e-2, 2.8785e-2),
                      expiries = c("1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"),
                      
                      mmDCC = "Act/360",
                      fixedSwapFreq = "6M",
                      floatSwapFreq = "6M",
                      fixedSwapDCC = "30/360",
                      floatSwapDCC = "30/360",
                      badDayConvZC = 'M',
                      holidays = 'None',
                      
                      valueDate = "2014-01-17",
                      benchmarkDate = "2013-12-20",
                      startDate = "2013-12-20",
                      endDate = "2019-03-20",
                      stepinDate = "2014-01-15",

                      dccCDS = "ACT/360",
                      freqCDS = 'Q',		  
                      stubCDS = "F", 		
                      badDayConvCDS = "F",
                      calendar = 'None',

                      upfront = -1e7*3.48963/100,
                      couponRate = 100, 
                      recoveryRate = .4,
                      payAccruedAtStart = FALSE,
                      notional = 1e7,
                      payAccruedOnDefault = TRUE)

stopifnot(all.equal(result1, truth1))

result2 <- calcSpread(TDate = "2014-01-14",
                      baseDate = "2014-01-13",
                      currency = "USD",
                      maturity = "5Y",
                      
                      dccCDS = "ACT/360",
                      freqCDS = 'Q',		  
                      stubCDS = "F", 		
                      badDayConvCDS = "F",
                      calendar = 'None',

                      upfront = -1e7*3.41/100,
                      couponRate = 100, 
                      recoveryRate = .4,
                      payAccruedAtStart = TRUE,
                      notional = 1e7,
                      payAccruedOnDefault = TRUE)


stopifnot(all.equal(result2, truth2))
