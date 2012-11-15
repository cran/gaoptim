\name{summary.GAReal}
\alias{summary}
\alias{summary.GAReal}
\title{Genetic Algorithm summary}
\usage{
  \method{summary}{GAReal} (object, ...)
}
\arguments{
  \item{object}{An object of class \code{GAReal}.}

  \item{...}{Other parameters (will be ignored).}
}
\value{
  An object of class \code{summaryGAReal}, which is a list
  that can be inspected or printed on-screen.
}
\description{
  A simple summary of the GA results.
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
summary(ga)
}

