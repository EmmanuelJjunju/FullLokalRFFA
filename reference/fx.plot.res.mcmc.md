# Plot MCMC convergence and marginal distributions from GEV parameters

Expert mode function to inspect MCMC samples (original GEV parameters,
except scale which is log-transformed). var1 = mu (location), var2 =
log-sigma (log-scale), var3 = k (shape).

## Usage

``` r
fx.plot.res.mcmc(res, main = "")
```

## Arguments

- res:

  Result list from running
  [`perform.analysis()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/perform.analysis.md).

- main:

  Character string for the main outer plot title (default = "").

## Value

A base R plot is produced as a side effect.
