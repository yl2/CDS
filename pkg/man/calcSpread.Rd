\name{calcSpread}
\alias{calcSpread}
\title{Calculate conventional spread from upfront}
\usage{
calcSpread(baseDate, currency = "USD", userCurve = FALSE, types = NULL,
  rates = NULL, expiries = NULL, mmDCC = NULL, fixedSwapFreq = NULL,
  floatSwapFreq = NULL, fixedSwapDCC = NULL, floatSwapDCC = NULL,
  badDayConvZC = NULL, holidays = NULL, todayDate, valueDate, benchmarkDate,
  startDate, endDate, stepinDate, couponRate, payAccruedOnDefault, dccCDS,
  dateInterval, stubType = "f/s", badDayConvCDS = "F", calendar = "None",
  upfrontCharge, recoveryRate = 0.4, payAccruedAtStart, notional = 1e+07)
}
\arguments{
  \item{couponRate}{in bps}

  \item{recoveryRate}{in decimal. Default is 0.4.}

  \item{notional}{default is 10mm (1e7)}

  \item{upfrontCharge}{the dollar amount for upfront
  payment}
}
\description{
Calculate conventional spread from upfront
}

