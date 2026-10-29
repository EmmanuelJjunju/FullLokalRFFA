# Extract posterior quantile samples from MCMC results

Computes GEV quantiles across all MCMC posterior parameter samples for a
given probability.

## Usage

``` r
get.quantile.samples(p, analysis)
```

## Arguments

- p:

  Numeric probability value.

- analysis:

  A result list returned by
  [`perform.analysis()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/perform.analysis.md).

## Value

Numeric vector of quantile samples corresponding to each MCMC iteration.
