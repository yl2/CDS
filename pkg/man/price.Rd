\name{price}
\alias{price}
\title{Calculate the price of a CDS contract}
\usage{
price(principal, notional)
}
\arguments{
  \item{principal}{is the principal amount of a CDS
  contract}

  \item{notional}{is the notional amount of a CDS contract}
}
\value{
a numeric indicating the price of a CDS contract
}
\description{
based on the formula Price = (1 - Principal/Notional)*100.
}

