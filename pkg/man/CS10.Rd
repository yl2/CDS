\name{CS10}
\alias{CS10}
\title{Calculate the CS10 of a CDS contract}
\usage{
CS10(object)
}
\arguments{
  \item{object}{is a \code{CDS} class object.}
}
\value{
a numeric indicating the CS10 of the contract.
}
\description{
Calculate the change in value of the contract when there is
a 10% on the spread of the contract.
}
\examples{
# construct a CDS class object
cds1 <- CDS(TDate = "2014-05-07", parSpread = 50, coupon = 100)

# use CS10
CS10(cds1)
}

