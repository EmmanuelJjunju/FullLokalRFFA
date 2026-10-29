# Calculate marginal model likelihood (evidence) using importance sampling —————

Computes the marginal log-likelihood (model evidence) for an MCMC sample
using a Gaussian mixture / importance sampling approximation based on
the multivariate normal distribution.

## Usage

``` r
model.loglik(
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

  Integer. Number of importance sampling iterations (default usually
  large, e.g., 10000+).

## Value

Numeric value representing the estimated marginal log-likelihood (log
evidence).
