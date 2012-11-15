\name{GAReal}
\alias{GAReal}
\title{Genetic Algorithm setup}
\usage{
  GAReal(FUN, lb, ub, popSize = 100, mutRate = 0.01,
    cxRate = 0.9, eliteRate = 0.4,
    selection = c("fitness", "uniform"),
    crossover = c("blend", "two.points"),
    mutation = c("noise"))
}
\arguments{
  \item{FUN}{The fitness function, which should take a
  vector as argument and return a numeric value (See
  details).}

  \item{lb}{A numeric vector specifying the lower bounds
  for the search domain.}

  \item{ub}{A numeric vector specifying the upper bounds
  for the search domain.}

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
  An object of class \code{GAReal}, which you can pass as
  an argument to \code{plot} or \code{summary}. This object
  is a list with the following accessor functions:
  \tabular{ll}{ \code{bestFit}: \tab Returns a vector with
  the best fitness achieved in each generation.\cr
  \code{meanFit}: \tab Returns a vector with the mean
  fitness achieved in each generation.\cr
  \code{bestIndividual}: \tab Returns a vector with the
  best solution found.\cr \code{evolve(h)}: \tab This is
  the function you call to evolve your population. You need
  to specify the number of generations to evolve.\cr
  \code{population}: \tab Returns the current population
  matrix. }
}
\description{
  Setup a \code{GAReal} object that can be used to run the
  algorithm.
}
\details{
  This is the function used to configure and fine-tune the
  algorithm. The basic usage requires only the \code{FUN}
  parameter (function to be maximized), together with the
  \code{lb} and \code{ub} parameters (lower and upper
  search domain), all the other parameters have sensible
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

  \itemize{ \item \code{crossover}: The \code{blend} option
  will perform a linear combination of the individuals DNA,
  effectively introducing new information into the
  resulting offspring. For details, see \emph{Practical
  genetic algorithms} in the references. The
  \code{two.points} option will perform the classic 2-point
  crossover. See the examples if you need to implement a
  custom crossover function. }

  \itemize{ \item \code{mutation}: The default
  implementation will uniformly sample \code{n} mutation
  points along the population matrix, where \code{n} is
  given by \code{mutRate * popSize * nvars} and
  \code{nvars} is the number of variables in your problem.
  Each sampled \emph{locus} will be replaced by a
  random-uniform number between 0 and 1. See the examples
  to learn how to use a custom mutation function. }
}
\examples{
# Maximize a trivial 5 variable function
# The function and search-space below will be used for all examples

fitness.FUN = function(x) sum(x)
lb = c(0, 0, 0, 0, 0)
ub = c(10, 10, 10, 10, 10)

ga1 = GAReal(fitness.FUN, lb, ub)
ga1$evolve(200)
plot(ga1)

# A custom selection example
selec.FUN = function(population, fitnessVec, nleft)
{
 # population - The population matrix
 # fitnessVec - The corresponding fitness vector for the population matrix
 # nleft - The number of individuals you should select

 half = as.integer(nleft/2)
 remain = nleft - half
 idxs = 1:nrow(population)

 # pick half using fitness-proportionate
 rowIdxs = sample(idxs, half, replace = TRUE, prob = fitnessVec)
 # pick the other half randomly
 rowIdxs = c(rowIdxs, sample(idxs, remain, replace = TRUE))

 # Just return the row indexes
 return(rowIdxs)
}

ga2 = GAReal(fitness.FUN, lb, ub, selection = selec.FUN)
ga2$evolve(200)
summary(ga2)

# A custom crossover example
crossover.FUN = function(parent1, parent2, prob)
{
 # parent1, parent2 - The individuals to crossover
 # prob - The probability of a crossover happen (cxRate parameter)

 # Respect the cxRate parameter: if DNA is not exchanged, just return the parents
 if (runif(1) > prob)
   return(matrix(c(parent1, parent2), nrow = 2, byrow = TRUE))

 # A simple uniform crossover - just swap the 'genes' with a probability of 0.5
 for (i in 1:length(parent1))
 {
   if (runif(1) > 0.5)
   {
     tempval = parent1[i]
     parent1[i] = parent2[i]
     parent2[i] = tempval
   }
 }
 # You should return a matrix in this format
 return(matrix(c(parent1, parent2), nrow = 2, byrow = TRUE))
}

ga3 = GAReal(fitness.FUN, lb, ub, crossover = crossover.FUN)
ga3$evolve(200)
plot(ga3)

# A custom mutation example
mutation.FUN = function(population, nMut)
{
 # population - The population matrix to apply mutation
 # nMut - The number of mutations you supposed to apply, according to mutRate

 rows = sample(1:nrow(population), nMut, replace = TRUE)
 cols = sample(1:ncol(population), nMut, replace = TRUE)
 noise = (runif(nMut))^2

 # extract the matrix indexes
 ext = matrix(c(rows, cols), nMut, 2)
 population[ext] = noise
 return(population)
}

ga4 = GAReal(fitness.FUN, lb, ub, mutation = mutation.FUN)
ga4$evolve(200)
summary(ga4)
}
\references{
  Randy L. Haupt, Sue Ellen Haupt (2004). Practical genetic
  algorithms - 2nd ed.

  Michalewicz, Zbigniew. Genetic Algorithms + Data
  Structures = Evolution Programs - 3rd ed.
}

