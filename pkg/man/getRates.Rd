\name{getRates}
\alias{getRates}
\title{The function returns the deposits and swap rates for the day
input. The day input should be a weekday. If not, go to the most
recent weekday.}
\usage{
getRates(date, currency = "USD")
}
\arguments{
  \item{date}{ideally a weekday. The effective date of the
  rates is T + 1.}

  \item{currency}{the three-letter currency code}
}
\value{
a list with two data frames. The first data frame contains
the rates based on the ISDA specifications; the second
contains all the dcc and calendar specifications of the
curve.
}
\description{
Assume date and currency are in the same location.
}

