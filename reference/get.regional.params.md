# Get hyper parameters from the regional model and climate variables

Get hyper parameters from the regional model and the given climate
variable values. Parameter set for regional analysis is re-parametrized
to log-index flood (index flood for log-transformed specific
discharges), alpha = log(scale/log.index.flood), and ksi = -0.5 + 1 /
(1 + exp(-k)).

## Usage

``` r
get.regional.params(clim, new.reg.coef = FALSE)
```

## Arguments

- clim:

  A data.frame containing the standardized climate variables.

- new.reg.coef:

  Logical. If `TRUE`, uses updated regression coefficients (default =
  FALSE).

## Value

A list containing the estimated means and standard deviations for
log-index flood, alpha, and ksi.
