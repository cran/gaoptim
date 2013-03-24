\name{plot.GAReal}
\alias{plot.GAReal}
\title{Genetic Algorithm plot}
\usage{
  \method{plot}{GAReal} (x, xlab = "Generation",
    ylab = "Fitness", main = "GA optimization",
    bestcol = "steelblue", meancol = "tomato", lwd = 2,
    legend.pos = c("bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right", "center"),
    ...)
}
\arguments{
  \item{x}{An object of class \code{GAReal}.}

  \item{xlab}{The label for the x-axis.}

  \item{ylab}{The label for the y-axis.}

  \item{main}{The plot title.}

  \item{bestcol}{The color for the best fitness evolution
  line}

  \item{meancol}{The color for the mean fitness evolution
  line}

  \item{lwd}{The line width.}

  \item{legend.pos}{The legend position, as a character
  vector.}

  \item{...}{Other parameters (will be ignored).}
}
\description{
  A quick way to visualize the GA results.
}
\examples{
ga = GAReal(function(x) sum(x), rep(0, 5), rep(10, 5))
ga$evolve(200)
plot(ga)
}

