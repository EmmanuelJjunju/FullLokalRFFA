# Plot Bayesian flood quantile curves with PP uncertainty and observations

Produces a hydrology-style return-period plot (log-x) with:
scenario-specific posterior quantile curves, pointwise credible
intervals, plotting-position uncertainty bars, and observed annual
maxima.

## Usage

``` r
fx.plot.quantile.curves.gg(
  analyses,
  labels = NULL,
  color = NULL,
  T.start = 1.01,
  T.end = 1000,
  plotting.formula = 0.44,
  show.pp.uncertainty = TRUE,
  eps = 1e-30
)
```

## Arguments

- analyses:

  List of analysis objects, one per scenario. Each element must contain
  at least:

  - `ams`: numeric vector of annual maxima (or other extremes).

  - `is.specific.discharge`: logical; `TRUE` if units are specific
    discharge (l/km^2/s), `FALSE` for discharge (m^3/s).

  - any additional components required by
    [`quantile.summary()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/quantile.summary.md).

- labels:

  Optional character vector of scenario labels, same length as
  `analyses`. If `NULL`, labels are generated as `"Scenario 1"`,
  `"Scenario 2"`, etc.

- color:

  Optional character vector of colors for the scenarios.

- T.start:

  Numeric; minimum return period (years) used for the model curves (on
  the x-axis, in log scale). Must be strictly greater than 1.

- T.end:

  Numeric; maximum return period (years) used for the model curves (on
  the x-axis, in log scale).

- plotting.formula:

  Numeric; plotting-position constant \\a\\ used to compute empirical
  return periods for the observed series, via \$\$p = ((n + 1 - i) - a)
  / (n + 1 - 2a), \quad T = 1 / (1 - p).\$\$ Defaults to `0.44`
  (Gringorten).

- show.pp.uncertainty:

  Logical; if `TRUE`, plotting-position uncertainty is shown as
  horizontal segments for each observed value, based on a set of
  alternative plotting-position constants.

- eps:

  Numeric; small positive value used to clamp plotting probabilities
  away from 0 and 1 when computing return periods for the uncertainty
  bars.

## Value

A `ggplot` object representing the return-period plot.
