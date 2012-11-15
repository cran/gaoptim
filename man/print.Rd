\name{print.GAReal}
\alias{print.GAReal}
\alias{print.summaryGAReal}
\title{Print GA results}
\usage{
  \method{print}{GAReal} (x, ...)

  \method{print}{summaryGAReal} (x, ...)
}
\arguments{
  \item{x}{An object of class \code{GAReal} or
  \code{summaryGAReal}}

  \item{...}{Other parameters (will be ignored).}
}
\description{
  Prints the GA results.
}
\examples{
# Easom's function
# This function can return a negative value, so
# we choose a uniform selection (see details on ?GAReal)

easom.FUN = function(x)
{
 x1 = x[1]
 x2 = x[2]
 cos(x1) * cos(x2) * exp(-(x1 - pi)^2 - (x2 - pi)^2)
}

lb = c(-100, -100)
ub = c(100, 100)
ga = GAReal(easom.FUN, lb, ub, popSize = 250, selection = 'uniform')
ga$evolve(300)
print(ga)
}

