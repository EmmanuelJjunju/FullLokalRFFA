# Calculate expected value (mean) of GEV distribution

Computes the theoretical mean of the Generalized Extreme Value (GEV)
distribution for a given parameter set.

## Usage

``` r
gev.mean(par)
```

## Arguments

- par:

  Numeric vector of length 3: `mu` (location), `ls` (log-sigma), `k`
  (shape).

## Value

Numeric value representing the GEV mean, or `NA` if the shape parameter
is out of bounds.
