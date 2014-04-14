\name{calcUpfront}
\alias{calcUpfront}
\title{Calculate dirty upfront payments from conventional spread}
\usage{
calcUpfront(baseDate, currency = "USD", userCurve = FALSE, types = NULL,
  rates = NULL, expiries = NULL, mmDCC = NULL, fixedSwapFreq = NULL,
  floatSwapFreq = NULL, fixedSwapDCC = NULL, floatSwapDCC = NULL,
  badDayConvZC = NULL, holidays = NULL, today, valueDate, benchmarkDate,
  startDate, endDate, stepinDate, dccCDS = "ACT/360", freqCDS = "1Q",
  stubCDS = "f/s", badDayConvCDS = "F", calendar = "None", parSpread,
  couponRate, recoveryRate = 0.4, notional = 1e+07)
}
\arguments{
  \item{baseDate}{the start date for the IR curve. baseDate
  <- "2011-03-04"}

  \item{currency}{the currency of the CDS. Default is USD.}

  \item{types}{the types of instruments}

  \item{rates}{the array of rates of the instruments used
  to build the IR curve}

  \item{mmDCC}{a character detailing the DCC of the MM
  instruments for the IR curve}

  \item{parSpread}{in bps}

  \item{couponRate}{in bps}

  \item{recoveryRate}{in decimal. Default is 0.4.}

  \item{notional}{default is 10mm (1e7)}
}
\description{
Calculate dirty upfront payments from conventional spread
}

