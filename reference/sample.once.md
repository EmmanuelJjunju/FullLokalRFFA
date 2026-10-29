# Perform a single Metropolis random-walk step with parallel tempering

Single RW Metropolis sampling utilizing a parallel tempering algorithm.
Returns an object containing new parameter values for each chain, an
array of updated log-probabilities, acceptance counts, test counts, and
swap statistics.

## Usage

``` r
sample.once(
  loglik,
  logprior,
  response,
  covariate,
  params,
  rw,
  logprobs,
  acceptances,
  num.tests,
  hyperparam,
  swaps,
  T
)
```

## Arguments

- loglik:

  Function to calculate log-likelihood.

- logprior:

  Function to calculate log-prior.

- response:

  Numeric vector of response data.

- covariate:

  Covariate data or additional predictors.

- params:

  Matrix or collection of parameters, one column for each value in the
  chain array `T`.

- rw:

  Numeric vector of random-walk standard deviations for each parameter.

- logprobs:

  Numeric vector of current log-probabilities for each chain.

- acceptances:

  Numeric vector of acceptance counts for each parameter (chain 1).

- num.tests:

  Numeric vector of total test counts for each parameter (chain 1).

- hyperparam:

  List or object containing hyper-parameters for the prior.

- swaps:

  Numeric vector of chain swap counts.

- T:

  Numeric vector of values for the parallel tempering chains.

## Value

A list containing updated `logprobs`, `params`, `acceptances`,
`num.tests`, and `swaps`.
