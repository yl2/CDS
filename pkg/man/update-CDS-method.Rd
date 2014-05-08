\docType{methods}
\name{update,CDS-method}
\alias{update,CDS-method}
\title{update spread or ptsUpfront or upfront based on a new CDS class object.}
\usage{
\S4method{update}{CDS}(object, upfront = NULL, isPriceClean = FALSE,
  ptsUpfront = NULL, spread = NULL, ...)
}
\arguments{
  \item{object}{is a \code{CDS} class object.}

  \item{upfront}{is the new upfront payment amount.}

  \item{ptsUpfront}{is the new pts upfront. It's in
  decimal.}

  \item{spread}{is the new spread in bps.}

  \item{isPriceClean}{specifies whether it is a dirty or
  clean upfront.}

  \item{...}{Additional arguments to the call, or arguments
  with changed values. Use \code{name = NULL} to remove the
  argument \code{name}.}
}
\value{
a \code{CDS} class object
}
\description{
update spread or ptsUpfront or upfront based on a new CDS
class object.
}
\examples{
## build a CDS class object
cds1 <- CDS(TDate = "2014-05-07", parSpread = 50, coupon = 100)

## update
update(cds1, spread = 55)
}

