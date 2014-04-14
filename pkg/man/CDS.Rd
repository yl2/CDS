\name{CDS}
\alias{CDS}
\title{Build a CDS class object to include info like the Bloomberg deal
and market sections.}
\usage{
CDS(contract = "SNAC", today = Sys.Date(), entityName = NULL,
  notional = 1e+07, currency = "USD", TDate = today, spread, couponRate,
  dccCDS = "ACT/360", freqCDS = "1Q", stubCDS = "f/s",
  badDayConvCDS = "F", calendarCDS = "None", maturity,
  payAccOnDefault = TRUE, recRate = 0.4, userCurve = FALSE,
  baseDate = today, types = NULL, rates = NULL, expiries = NULL,
  mmDCC = NULL, fixedSwapFreq = NULL, floatSwapFreq = NULL,
  fixedSwapDCC = NULL, floatSwapDCC = NULL, badDayConvZC = NULL,
  holidays = NULL, valueDate = today + 3, benchmarkDate, startDate, endDate,
  stepinDate = today + 1)
}
\arguments{
  \item{contract}{is the contract type, default SNAC}

  \item{today}{present date, default is the current date}

  \item{entityName}{is the name of the reference entity.
  Optional.}

  \item{notional}{is the notional amount, default is 1e7.}

  \item{tradeDate}{is when the trade is executed, denoted
  as T. Default is today.}

  \item{spread}{CDS par spread in bps}

  \item{couponRate}{in bps}

  \item{DCC}{day count convention of the CDS. The default
  is ACT/360.}

  \item{freq}{date interval of the CDS contract}

  \item{maturity}{maturity of the CDS contract}

  \item{payAccOnDefault}{is a partial payment of the
  premium made to the protection seller in the event of a
  default. Default is TRUE.}

  \item{recRate}{in decimal. Default is 0.4.}

  \item{userCurve}{boolean. if TRUE, user has to specify
  the IR curve; if FALSE, grab historical data from
  Markit.}

  \item{types}{is a string indicating the names of the
  instruments used for the yield curve. 'M' means money
  market rate; 'S' is swap rate.}

  \item{expiries}{is an array of characters indicating the
  maturity of each instrument.}

  \item{rates}{is an array of numeric values indicating the
  rate of each instrument.}

  \item{mmDCC}{is the day count convention of the
  instruments.}

  \item{fixedSwapFreq}{is the frequency of the fixed rate
  of swap being paid.}

  \item{floatSwapFreq}{is the frequency of the floating
  rate of swap being paid.}

  \item{fixedSwapDCC}{is the day count convention of the
  fixed leg.}

  \item{floatSwapDCC}{is the day count convention of the
  floating leg.}

  \item{valueDate}{is the date for which the present value
  of the CDS is calculated. aka cash-settle date. The
  default is T + 3.}

  \item{benchmarkDate}{Accrual begin date.}

  \item{startDate}{is when the CDS nomially starts in terms
  of premium payments, i.e. the number of days in the first
  period (and thus the amount of the first premium payment)
  is counted from this date. aka accrual begin date.}

  \item{endDate}{aka maturity date. This is when the
  contract expires and protection ends. Any default after
  this date does not trigger a payment.}

  \item{stepinDate}{aka protection effective date. It's
  when protection and risk starts in terms of the model.
  Note the legal effective date is T-60 or T-90 for
  standard contract. The default is T + 1.}
}
\description{
Build a CDS class object to include info like the Bloomberg
deal and market sections.
}

