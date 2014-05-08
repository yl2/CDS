\docType{class}
\name{CDS, CDS-class}
\alias{CDS,}
\alias{CDS, CDS-class}
\alias{CDS-class}
\title{Class definition for the \code{CDS-Class}}
\description{
Class definition for the \code{CDS-Class}
}
\section{Slots}{

\describe{
\item{\code{contract}}{is the contract type, default SNAC}

\item{\code{entityName}}{is the name of the reference entity. Optional.}

\item{\code{RED}}{alphanumeric code assigned to the reference entity. Optional.}

\item{\code{TDate}}{is when the trade is executed, denoted as T. Default
is \code{Sys.Date}.}

\item{\code{baseDate}}{is the start date for the IR curve. Default is TDate.}

\item{\code{currency}}{in which CDS is denominated.}

\item{\code{types}}{is a string indicating the names of the instruments
used for the yield curve. 'M' means money market rate; 'S' is swap
rate.}

\item{\code{rates}}{is an array of numeric values indicating the rate of
each instrument.}

\item{\code{expiries}}{is an array of characters indicating the maturity
of each instrument.}

\item{\code{mmDCC}}{is the day count convention of the instruments.}

\item{\code{fixedSwapFreq}}{is the frequency of the fixed rate of swap
being paid.}

\item{\code{floatSwapFreq}}{is the frequency of the floating rate of swap
being paid.}

\item{\code{fixedSwapDCC}}{is the day count convention of the fixed leg.}

\item{\code{floatSwapDCC}}{is the day count convention of the floating leg.}

\item{\code{badDayConvZC}}{is a character indicating how non-business days
are converted.}

\item{\code{holidays}}{is an input for holiday files to adjust to business
days.}

\item{\code{valueDate}}{is the date for which the present value of the CDS
is calculated. aka cash-settle date. The default is T + 3.}

\item{\code{benchmarkDate}}{Accrual begin date.}

\item{\code{startDate}}{is when the CDS nomially starts in terms of
premium payments, i.e. the number of days in the first period (and
thus the amount of the first premium payment) is counted from this
date. aka accrual begin date.}

\item{\code{endDate}}{aka maturity date. This is when the contract expires
and protection ends. Any default after this date does not trigger a
payment.}

\item{\code{stepinDate}}{default is T + 1.}

\item{\code{maturity}}{of the CDS contract.}

\item{\code{dccCDS}}{day count convention of the CDS. Default is ACT/360.}

\item{\code{freqCDS}}{date interval of the CDS contract.}

\item{\code{stubCDS}}{is a character indicating the presence of a stub.}

\item{\code{badDayConvCDS}}{refers to the bay day conversion for the CDS
coupon payments. Default is "F", following.}

\item{\code{calendar}}{refers to any calendar adjustment for the CDS.}

\item{\code{parSpread}}{CDS par spread in bps.}

\item{\code{coupon}}{quoted in bps. It specifies the payment amount from
the protection buyer to the seller on a regular basis.}

\item{\code{recoveryRate}}{in decimal. Default is 0.4.}

\item{\code{inputPriceClean}}{records the \code{isPriceClean} argument
input by the user. \code{isPriceClean} refers to the type of
upfront calculated. It is boolean. When \code{TRUE}, calculate
principal only. When \code{FALSE}, calculate principal + accrual.}

\item{\code{notional}}{is the amount of the underlying asset on which the
payments are based. Default is 1e7, i.e. 10MM.}

\item{\code{payAccruedOnDefault}}{is a partial payment of the premium made
to the protection seller in the event of a default. Default is
\code{TRUE}.}

\item{\code{principal}}{is the dirty \code{upfront} less the \code{accrual}.}

\item{\code{accrual}}{is the accrued interest payment.#'}

\item{\code{upfront}}{is quoted in the currency amount. Since a standard
contract is traded with fixed coupons, upfront payment is
introduced to reconcile the difference in contract value due to the
difference between the fixed coupon and the conventional par
spread. There are two types of upfront, dirty and clean. Dirty
upfront, a.k.a. Cash Settlement Amount, refers to the market value
of a CDS contract. Clean upfront is dirty upfront less any accrued
interest payment, and is also called the Principal.}

\item{\code{ptsUpfront}}{is quoted as a percentage of the notional
amount. They represent the upfront payment excluding the accrual
payment. High Yield (HY) CDS contracts are often quoted in points
upfront. The protection buyer pays the upfront payment if points
upfront are positive, and the buyer is paid by the seller if the
points are negative.}

\item{\code{spreadDV01}}{measures the sensitivity of a CDS contract
mark-to-market to a parallel shift in the term structure of the par
spread.}

\item{\code{IRDV01}}{is the change in value of a CDS contract for a 1 bp
parallel increase in the interest rate curve. \code{IRDV01} is,
typically, a much smaller dollar value than \code{spreadDV01}
because moves in overall interest rates have a much smaller effect
on the value of a CDS contract than does a move in the CDS spread
itself.}

\item{\code{RecRisk01}}{is the dollar value change in market value if the
recovery rate used in the CDS valuation were increased by 1\%.}

\item{\code{defaultProb}}{is the approximate the default probability at
time t given the \code{parSpread}.}

\item{\code{defaultExpo}}{calculates the default exposure of a CDS contract
based on the formula: Default Exposure: (1-Recovery Rate)*Notional
- Principal.}
}}

