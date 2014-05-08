\name{defaultExpo}
\alias{defaultExpo}
\title{Calculate the default exposure of a CDS contract based on the
formula: Default Exposure: (1-Recovery Rate)*Notional - Principal}
\usage{
defaultExpo(recoveryRate = 0.4, notional = 1e+07, principal)
}
\arguments{
  \item{recoveryRate}{in decimal. Default is 0.4}

  \item{notional}{is the notional amount of the CDS
  contract. Default is 10MM.}

  \item{principal}{is the principal from the CDS contract.}
}
\value{
a numeric indicating the amount in the event of a default
the following day.
}
\description{
Calculate the default exposure of a CDS contract based on
the formula: Default Exposure: (1-Recovery Rate)*Notional -
Principal
}

