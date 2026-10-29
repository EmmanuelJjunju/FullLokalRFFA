# Calculate GEV quantile for given probabilities

Computes the GEV quantile corresponding to cumulative probabilities `p`
given the parameter vector (location, log-scale, shape).

## Usage

``` r
gev.quantile(p, par)
```

## Arguments

- p:

  Numeric vector of cumulative probabilities.

- par:

  Numeric vector of length 3: `mu` (location), `ls` (log-sigma), `k`
  (shape).

## Value

Numeric vector of GEV quantiles.
