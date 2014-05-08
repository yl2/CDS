\name{getDates}
\alias{getDates}
\title{The function gets relevant coupon dates for a CDS contract.}
\usage{
getDates(TDate, maturity = "5Y")
}
\arguments{
  \item{TDate}{the trade date}

  \item{maturity}{maturity of the CDS contract. Default
  "5Y".}
}
\value{
a date frame with step-in date (T+1), value date (T+3
business days), start date (accrual begin date), end date
(maturity), backstop date (T-60 day look back from which
'protection' is effective), pen coupon date (second to last
coupon date)
}
\description{
The function gets relevant coupon dates for a CDS contract.
}
\examples{
getDates(as.Date("2014-05-07"), maturity = "5Y")
}

