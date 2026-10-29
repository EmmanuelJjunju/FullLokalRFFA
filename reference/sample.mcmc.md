# Perform MCMC sampling using Metropolis-Hastings with parallel tempering and adaptive random-walk

Runs Markov Chain Monte Carlo (MCMC) sampling using a Metropolis
algorithm featuring parallel tempering, burn-in with adaptive
random-walk step-length tuning, and thinning.

## Usage

``` r
sample.mcmc(
  loglik,
  logprior,
  response,
  covariate,
  hyperparam,
  param.template,
  numsamples,
  burnin = 1000,
  indep = 10,
  numtemp = 1,
  base.temp = 1.25,
  talkative = FALSE
)
```

## Arguments

- loglik:

  Function to calculate log-likelihood.

- logprior:

  Function to calculate log-prior.

- response:

  Response variable vector.

- covariate:

  Covariate data or additional predictors.

- hyperparam:

  Hyper-parameters used in the prior.

- param.template:

  Template object giving an indication of how the parameter vector
  should look like.

- numsamples:

  Number of samples to be returned.

- burnin:

  Burn-in period length (default = 1000).

- indep:

  Spacing (thinning) between samples to be included in the output
  (default = 10).

- numtemp:

  Number of tempering chains (minimum 1, default = 1).

- base.temp:

  Base temperature for parallel tempering (default = 1.25).

- talkative:

  Logical. If `TRUE`, prints progress and debug info (default =
  `FALSE`).

## Value

A matrix containing parameter samples.
