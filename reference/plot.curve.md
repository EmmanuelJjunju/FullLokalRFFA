# Plot Bayesian flood quantile curves using base R graphics

Produces a log-log return period plot showing posterior mean curves,
credibility intervals, and observed plotting positions.

## Usage

``` r
# S3 method for class 'curve'
plot(
  analysis,
  T.start = 1.01,
  T.end = 1000,
  plotting.formula = 0.44,
  add = FALSE
)
```

## Arguments

- analysis:

  A result list returned by
  [`perform.analysis()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/perform.analysis.md).

- T.start:

  Minimum return period for the curve (default = 1.01).

- T.end:

  Maximum return period for the curve (default = 1000).

- plotting.formula:

  Plotting-position constant(s) for observed points (default = 0.44).

- add:

  Logical. If `TRUE`, adds curves to an existing plot (default =
  `FALSE`).

## Value

A base R plot is produced as a side effect.
