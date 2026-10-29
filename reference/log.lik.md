# Calculate log-likelihood for original GEV parameters

Operates on original GEV parameters and computes the log-likelihood for
the observed data.

## Usage

``` r
# S3 method for class 'lik'
log(data, cov, par)
```

## Arguments

- data:

  Numeric vector of annual maximum series (AMS).

- cov:

  Covariate data (included for interface consistency).

- par:

  Numeric vector of length 3: `mu`, `ls` (log-sigma), `k`.

## Value

Numeric value representing the log-likelihood.
