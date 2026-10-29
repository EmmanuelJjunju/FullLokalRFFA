# Calculate log-prior for a given GEV parameter set

Computes the log-prior for a given parameter set. Hyper-parameters come
from regional analysis for the given climate dataset. Note that in the
prior, the parameter set is re-parametrized to log-index flood, alpha,
and ksi.

## Usage

``` r
# S3 method for class 'prior'
log(par, hyper)
```

## Arguments

- par:

  Numeric vector of length 3: `mu` (location), `ls` (log-sigma), `k`
  (shape).

- hyper:

  List of regional hyper-parameters (`log.index.flood.est`,
  `log.index.flood.sd`, `alpha.est`, `alpha.sd`, `ksi.est`, `ksi.sd`).

## Value

Numeric value representing the log-prior probability.
