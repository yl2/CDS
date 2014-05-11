\name{impliedRecoveryRate}
\alias{impliedRecoveryRate}
\title{A function that calculates the implied recovery rate.
}
\usage{
impliedRecoveryRate(data, col.spread, col.pd, col.id, col.endDate, col.TDate)
}
\arguments{
  \item{data}{dataframe containing the 1. probability of
  default (pd) over a a certain time period, 2. id and 3.
  spread}

  \item{col.spread}{column number of spread}

  \item{col.endDate}{column number of end dates. maturity
  date. This is when the contract expires and protection
  ends. Any default after this date does not trigger a
  payment.}

  \item{col.TDate}{column number of Trade dates. is when
  the trade is executed, denoted as T. Default is today.}

  \item{col.id}{is the column for the id of the CDS}

  \item{col.pd}{column number of probability of default
  rates}
}
\value{
Implied recovery rate in percentage based on the general
approximation for a probability of default in the Bloomberg
manual. The actual calculation uses a complicated
bootstrapping process, so the results may be marginally
different.
}
\description{Function that uses the ISDA model to calculate the implied
recovery rate for cases in which we have a spread and a probability of
default (pd). This takes a data frame of inputs and returns a vector
of the same length. If we have a data frame like: id,spread,pd which we
pass into a function, this then returns a vector of implied default
rates. }


