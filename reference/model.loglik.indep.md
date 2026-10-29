# Calculate marginal model likelihood using independent normal approximations

Computes the marginal log-likelihood (model evidence) for MCMC samples
using importance sampling based on independent normal distributions for
each parameter.

## Usage

``` r
model.loglik.indep(
  loglik,
  logprior,
  response,
  covariate,
  hyperparam,
  param.template,
  samples,
  num.iterations
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

- hyperparam:

  Hyper-parameters used in the prior.

- param.template:

  Template object giving an indication of how the parameter vector
  should look like.

- samples:

  Matrix or data.frame of MCMC posterior parameter samples (parameters
  in rows, samples in columns).

- num.iterations:

  Integer. Number of importance sampling iterations.

## Value

Numeric value representing the estimated marginal log-likelihood (log
evidence).
