\name{upfront}
\alias{upfront}
\title{Calculate dirty upfront payments from conventional spread}
\usage{
upfront(TDate, baseDate = TDate, currency = "USD", types = NULL,
  rates = NULL, expiries = NULL, mmDCC = "ACT/360",
  fixedSwapFreq = "6M", floatSwapFreq = "3M", fixedSwapDCC = "30/360",
  floatSwapDCC = "ACT/360", badDayConvZC = "M", holidays = "None",
  valueDate = NULL, benchmarkDate = NULL, startDate = NULL,
  endDate = NULL, stepinDate = NULL, maturity = "5Y",
  dccCDS = "ACT/360", freqCDS = "1Q", stubCDS = "F",
  badDayConvCDS = "F", calendar = "None", parSpread, coupon = 100,
  recoveryRate = 0.4, isPriceClean = FALSE, payAccruedOnDefault = TRUE,
  notional = 1e+07)
}
\arguments{
  \item{TDate}{is when the trade is executed, denoted as
  T.}

  \item{baseDate}{is the start date for the IR curve.
  Default is TDate.}

  \item{currency}{in which CDS is denominated.}

  \item{types}{is a string indicating the names of the
  instruments used for the yield curve. 'M' means money
  market rate; 'S' is swap rate.}

  \item{rates}{is an array of numeric values indicating the
  rate of each instrument.}

  \item{expiries}{is an array of characters indicating the
  maturity of each instrument.}

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

  \item{badDayConvZC}{is a character indicating how
  non-business days are converted.}

  \item{holidays}{is an input for holiday files to adjust
  to business days.}

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

  \item{stepinDate}{default is T + 1.}

  \item{maturity}{of the CDS contract.}

  \item{dccCDS}{day count convention of the CDS. Default is
  ACT/360.}

  \item{freqCDS}{date interval of the CDS contract.}

  \item{stubCDS}{is a character indicating the presence of
  a stub.}

  \item{badDayConvCDS}{refers to the bay day conversion for
  the CDS coupon payments. Default is "F", following.}

  \item{calendar}{refers to any calendar adjustment for the
  CDS.}

  \item{parSpread}{CDS par spread in bps.}

  \item{coupon}{quoted in bps. It specifies the payment
  amount from the protection buyer to the seller on a
  regular basis. The default is 100 bps.}

  \item{recoveryRate}{in decimal. Default is 0.4.}

  \item{isPriceClean}{refers to the type of upfront
  calculated. It is boolean. When \code{TRUE}, calculate
  principal only. When \code{FALSE}, calculate principal +
  accrual.}

  \item{payAccruedOnDefault}{is a partial payment of the
  premium made to the protection seller in the event of a
  default. Default is \code{TRUE}.}

  \item{notional}{is the amount of the underlying asset on
  which the payments are based. Default is 1e7, i.e. 10MM.}
}
\value{
a numeric indicating the amount of upfront payments from a
protection buyer's perspective.
}
\description{
Calculate dirty upfront payments from conventional spread
}
\examples{
upf <- upfront(baseDate = "2014-01-13", currency = "USD", TDate
= "2014-01-14", maturity = "5Y", dccCDS = "ACT/360", freqCDS = "Q",
stubCDS = "F", badDayConvCDS = "F", calendar = "None", parSpread =
32, coupon = 100, recoveryRate = 0.4, isPriceClean = FALSE,
notional = 1e7)
}

