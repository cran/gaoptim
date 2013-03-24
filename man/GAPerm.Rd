\name{GAPerm}
\alias{GAPerm}
\title{Genetic Algorithm setup}
\usage{
  GAPerm(FUN, n, popSize = 100, mutRate = 0.1,
    cxRate = 0.9, eliteRate = 0.4,
    selection = c("fitness", "uniform"),
    crossover = c("pmx"), mutation = c("swap"))
}
\arguments{
  \item{FUN}{The fitness function, which should take a
  vector as argument and return a numeric value (See
  details).}

  \item{n}{The number of elements to permutate.}

  \item{popSize}{The population size.}

  \item{mutRate}{The mutation rate, a numeric value between
  0 and 1. When implementing a custom mutation function,
  this value should be one of the parameters (see details
  and examples).}

  \item{cxRate}{The crossover rate, a numeric value between
  0 and 1. This parameter specifies the probability of two
  individuals effectively exchange DNA during crossover. In
  case the individuals didn't crossover, the offspring is a
  exact copy of the parents. When implementing a custom
  crossover function, this value should be one of the
  arguments (see details and examples).}

  \item{eliteRate}{A numeric value between 0 and 1. The
  \code{eliteRate * popSize} best-fitted individuals will
  automatically be selected for the next generation.}

  \item{selection}{The selection operator to be used. You
  can also implement a custom selection function (see
  details and examples).}

  \item{crossover}{The crossover operator to be used. You
  can also implement a custom crossover function (see
  details and examples).}

  \item{mutation}{The mutation operator to be used. You can
  also implement a custom mutation function (see details
  and examples).}
}
\value{
  An object of class \code{GAPerm}, which you can pass as
  an argument to \code{plot} or \code{summary}. This object
  is a list with the following accessor functions:
  \tabular{ll}{ \code{bestFit}: \tab Returns a vector with
  the best fitness achieved in each generation.\cr
  \code{meanFit}: \tab Returns a vector with the mean
  fitness achieved in each generation.\cr
  \code{bestIndividual}: \tab Returns a vector with the
  best solution found.\cr \code{evolve(h)}: \tab This is
  the function you call to evolve your population. \cr \tab
  You also need to specify the number of generations to
  evolve.\cr \code{population}: \tab Returns the current
  population matrix. }
}
\description{
  Setup a \code{GAPerm} object that can be used to perform
  a permutation-based optimization.
}
\details{
  This is the function used to configure and fine-tune a
  permutation-based optimization. The basic usage requires
  only the \code{FUN} parameter (function to be maximized),
  together with \code{n} (the number of elements to
  permutate), all the other parameters have sensible
  defaults.

  The parameters \code{selection}, \code{crossover} and
  \code{mutation} can also take a custom function as
  argument, which needs to be in the appropriate format
  (see the examples). The text below explains the default
  behaviour for these parameters, which will be usefull if
  you want to override one or more genetic operators.

  \itemize{ \item \code{selection}: The \code{fitness}
  option performs a \emph{fitness-proportionate} selection,
  so that the fittest individuals will have greater chances
  of being selected. If you choose this option, the value
  returned by \code{FUN} (the fitness value) should be
  \strong{non-negative}. The \code{uniform} option will
  randomly sample the individuals to mate, regardless of
  their fitness value. See the examples if you want to
  implement a custom selection function. }

  \itemize{ \item \code{crossover}: The \code{pmx} option
  will perform a 'partially mapped crossover' of the
  individuals DNA. See the references and examples if you
  need to implement a custom crossover function. The trick
  with permutation crossover is to make sure that the
  resulting children are valid permutations. }

  \itemize{ \item \code{mutation}: The \code{swap} option
  will perform a simple swap between specific gene
  positions, according to the mutation rate specified. }
}
\examples{
# TSP with 10 cities around a circular pattern
 n = 10
 R = 10
 angs = seq(0, 2*pi, length = n)
 xp = R * cos(angs) + rnorm(n)
 yp = R * sin(angs) + rnorm(n)
 xp = c(xp, xp[1])
 yp = c(yp, yp[1])

 base.M = matrix(c(xp, yp), ncol = 2)
 dist.FUN = function(p)
 {
   p = c(p, p[1])
   M.diff = diff(base.M[p, ])
   dists = apply(M.diff, 1, function(x)x[1]^2 + x[2]^2)
   1/sum(dists)
 }

 ga1 = GAPerm(dist.FUN, n, popSize = 100, mutRate = 0.3)
 ga1$evolve(100)
 plot(xp, yp, type = 'n', xlab = '', ylab = '')
 res = ga1$bestIndividual()
 res = c(res, res[1])

 i = 1:n
 xi = base.M[res[i], 1]
 yi = base.M[res[i], 2]
 xf = base.M[res[i + 1], 1]
 yf = base.M[res[i + 1], 2]

 arrows(xi, yi, xf, yf, col = 'red', angle = 10)
 text(base.M[res, 1], base.M[res, 2], 1:n, cex = 0.9, col = 'gray20')


 # Euro tour problem (See ?optim)
 eurodistmat = as.matrix(eurodist)

 # This function will be used for the remaining examples
 distance = function(sq)
 {
   sq = c(sq, sq[1])
   sq2 <- embed(sq, 2)
   1/sum(eurodistmat[cbind(sq2[,2], sq2[,1])])
 }

 loc = -cmdscale(eurodist, add = TRUE)$points
 x = loc[, 1]
 y = loc[, 2]
 n = nrow(eurodistmat)

 set.seed(1)
 ga2 = GAPerm(distance, n, popSize = 100, mutRate = 0.3)
 ga2$evolve(200)
 best = ga2$bestIndividual()
 best = c(best, best[1])
 best.dist = 1/max(ga2$bestFit())
 res = loc[best, ]
 i = 1:n

 plot(x, y, type = 'n', axes = FALSE, ylab = '', xlab = '')
 title ('Euro tour: TSP with 21 cities')
 mtext(paste('Best distance found:', best.dist))
 arrows(res[i, 1], res[i, 2], res[i + 1, 1], res[i + 1, 2], col = 'red', angle = 10)
 text(x, y, labels(eurodist), cex = 0.8, col = 'gray20')


 # Euro tour with custom selection
 selec.FUN = function(population, fitnessVec, nLeft)
 {
   # Chance of being select proportional to fitness sqrt
   idxs = sample(nrow(population), nLeft, prob = sqrt(fitnessVec))

   # Just return the nLeft selected row indexes
   idxs
 }

 ga3 = GAPerm(distance, n, mutRate = 0.3, selection = selec.FUN)
 ga3$evolve(200)
 best.dist = 1/max(ga3$bestFit())
 plot(ga3, main = 'Euro tour: TSP with 21 cities')
 mtext(paste('Best distance found:', best.dist))


 # Euro tour with custom crossover
 # This is the default pmx implementation
 crossover.FUN = function(vec1, vec2, prob)
 {
   # prob is the crossover rate
   if (runif(1) > prob)
     return(matrix(c(vec1, vec2), nrow = 2, byrow = TRUE))

   idxs = sample(1:length(vec1), 2)
   vec1.cp = vec1

   for (i in idxs)
   {
     other.val = vec2[i]
     vec.idx = which(vec1 == other.val)
     vec1[vec.idx] = vec1[i]
     vec1[i] = other.val
   }

   for (i in idxs)
   {
     other.val = vec1.cp[i]
     vec.idx = which(vec2 == other.val)
     vec2[vec.idx] = vec2[i]
     vec2[i] = other.val
   }

   matrix(c(vec1, vec2), nrow = 2, byrow = TRUE)
 }

 ga4 = GAPerm(distance, n, mutRate = 0.3, crossover = crossover.FUN)
 ga4$evolve(200)
 best.dist = 1/max(ga4$bestFit())
 plot(ga4, main = 'Euro tour: TSP with 21 cities')
 mtext(paste('Best distance found:', best.dist))


 # Euro tour with custom mutation
 # This is the default implementation
 mutation.FUN = function(M, mutations)
 {
   # M - The population matrix to apply mutation
   # mutations - The number of mutations you supposed to apply, according to mutRate

   rows = sample(1:nrow(M), mutations, replace = FALSE)
   cols = t(replicate(mutations, sample(1:n, 2)))
   col1 = cols[, 1]
   col2 = cols[, 2]
   extM1 = matrix(c(rows, col1), ncol = 2)
   extM2 = matrix(c(rows, col2), ncol = 2)
   tempCol = M[extM1]
   M[extM1] = M[extM2]
   M[extM2] = tempCol
   M
 }

 ga5 = GAPerm(distance, n, mutRate = 0.3, mutation = mutation.FUN)
 ga5$evolve(200)
 best.dist = 1/max(ga5$bestFit())
 plot(ga5, main = 'Euro tour: TSP with 21 cities')
 mtext(paste('Best distance found:', best.dist))
}
\references{
  Even, S. Algorithmic Combinatorics. The Macmillan
  Company, NY 1973.

  Michalewicz, Zbigniew. Genetic Algorithms + Data
  Structures = Evolution Programs - 3rd ed.
}

