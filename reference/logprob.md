# Calculate logarithmic probability density (log-likelihood + log-prior)

Computes the unnormalized log-posterior probability density scaled by
temperature (used for parallel tempering / MCMC sampling), combining the
log-prior and log-likelihood.

## Usage

``` r
logprob(loglik, logprior, response, covariate, params, hyperparam, T)
```

## Arguments

- loglik:

  Function to calculate log-likelihood.

- logprior:

  Function to calculate log-prior.

- response:

  Numeric vector of response data (e.g., annual maximum series /
  specific discharge).

- covariate:

  Covariate data or additional predictors (can be `NA` or `NULL`).

- params:

  Numeric vector of current parameter values.

- hyperparam:

  List or object containing hyper-parameters for the prior.

- T:

  Numeric. Temperature parameter for parallel tempering (default usually
  1).

## Value

Numeric value representing the scaled log-probability, or a very small
number (`-1e+200`) if probabilities are invalid or non-finite.
