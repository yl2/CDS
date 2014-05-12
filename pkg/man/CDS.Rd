\name{CDS}
\alias{CDS}
\title{Build a \code{CDS} class object given the input about a CDS
contract.}
\usage{
CDS(contract = "SNAC", entityName = NULL, RED = NULL,
  TDate = Sys.Date(), baseDate = TDate, currency = "USD", types = NULL,
  rates = NULL, expiries = NULL, mmDCC = "ACT/360",
  fixedSwapFreq = "6M", floatSwapFreq = "3M", fixedSwapDCC = "30/360",
  floatSwapDCC = "ACT/360", badDayConvZC = "M", holidays = "None",
  valueDate = NULL, benchmarkDate = NULL, startDate = NULL,
  endDate = NULL, stepinDate = NULL, maturity = "5Y",
  dccCDS = "ACT/360", freqCDS = "Q", stubCDS = "F", badDayConvCDS = "F",
  calendar = "None", parSpread = NULL, coupon = 100, recoveryRate = 0.4,
  upfront = NULL, ptsUpfront = NULL, isPriceClean = FALSE,
  notional = 1e+07, payAccruedOnDefault = TRUE)
}
\arguments{
  \item{contract}{is the contract type, default SNAC}

  \item{entityName}{is the name of the reference entity.
  Optional.}

  \item{RED}{alphanumeric code assigned to the reference
  entity. Optional.}

  \item{TDate}{is when the trade is executed, denoted as T.  Default is
  \code{Sys.Date}. The date format should be in "YYYY-MM-DD".}

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

  \item{upfront}{is quoted in the currency amount. Since a
  standard contract is traded with fixed coupons, upfront
  payment is introduced to reconcile the difference in
  contract value due to the difference between the fixed
  coupon and the conventional par spread. There are two
  types of upfront, dirty and clean. Dirty upfront, a.k.a.
  Cash Settlement Amount, refers to the market value of a
  CDS contract. Clean upfront is dirty upfront less any
  accrued interest payment, and is also called the
  Principal.}

  \item{ptsUpfront}{is quoted as a percentage of the
  notional amount. They represent the upfront payment
  excluding the accrual payment. High Yield (HY) CDS
  contracts are often quoted in points upfront. The
  protection buyer pays the upfront payment if points
  upfront are positive, and the buyer is paid by the seller
  if the points are negative.}

  \item{isPriceClean}{refers to the type of upfront
  calculated. It is boolean. When \code{TRUE}, calculate
  principal only. When \code{FALSE}, calculate principal +
  accrual.}

  \item{notional}{is the amount of the underlying asset on
  which the payments are based. Default is 1e7, i.e. 10MM.}

  \item{payAccruedOnDefault}{is a partial payment of the
  premium made to the protection seller in the event of a
  default. Default is \code{TRUE}.}
}
\value{
a \code{CDS} class object including the input informtion on
the contract as well as the valuation results of the
contract.
}
\description{
Build a \code{CDS} class object given the input about a CDS
contract.
}
\examples{
# Build a simple CDS class object
require(CDS)
cds1 <- CDS(TDate = "2014-05-07", parSpread = 50, coupon = 100)
}

