\name{calcRecRisk01}
\alias{calcRecRisk01}
\title{Calculate RecRisk01}
\usage{
calcRecRisk01(baseDate, currency = "USD", userCurve = FALSE, types = NULL,
  rates = NULL, expiries = NULL, mmDCC = NULL, fixedSwapFreq = NULL,
  floatSwapFreq = NULL, fixedSwapDCC = NULL, floatSwapDCC = NULL,
  badDayConvZC = NULL, holidays = NULL, today, valueDate, benchmarkDate,
  startDate, endDate, stepinDate, dccCDS = "ACT/360", freqCDS = "1Q",
  stubCDS = "f/s", badDayConvCDS = "F", calendar = "None", parSpread,
  couponRate, recoveryRate = 0.4, notional = 1e+07)
}
\arguments{
  \item{parSpread}{in bps}

  \item{couponRate}{in bps}

  \item{recoveryRate}{in decimal. Default is 0.4.}

  \item{notional}{default is 10mm (1e7)}
}
\description{
Calculate RecRisk01
}

