# Plot Bayesian flood frequency curve with extended NVE-style uncertainty

This version expands the lower-tail plotting-position uncertainty by
clamping probabilities \\p \le 0\\ to an extremely small positive value
(\\10^{-30}\\), allowing the uncertainty bars to extend much further
left, consistent with NVE's Hydra/FlomQ implementation. Ascending ranks
are used for uncertainty, and no lower-bound filtering is applied to the
resulting return periods. The upper tail is also clamped to \\1 -
\varepsilon\\ to avoid premature truncation.

## Usage

``` r
fx.plot.quantile.curve.base(
  analysis,
  T.start = 1.01,
  T.end = 1000,
  plotting.formula = 0.44,
  add = FALSE,
  label = NULL,
  show.pp.uncertainty = TRUE,
  eps = 0
)
```

## Arguments

- analysis:

  Output from perform.analysis().

- T.start:

  Minimum return period for the posterior curve.

- T.end:

  Maximum return period for the posterior curve.

- plotting.formula:

  Plotting-position constant for observed points.

- add:

  If TRUE, add to an existing plot.

- label:

  Legend label.

- show.pp.uncertainty:

  If TRUE, draw plotting-position uncertainty bars.

- eps:

  Small positive value for probability clamping.

## Value

A plot is produced as a side effect.
