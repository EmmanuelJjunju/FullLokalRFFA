# Extract posterior mean samples from MCMC results

Computes the GEV mean across all MCMC posterior parameter samples.

## Usage

``` r
get.mean.samples(analysis)
```

## Arguments

- analysis:

  A result list returned by
  [`perform.analysis()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/perform.analysis.md).

## Value

Numeric vector of mean samples corresponding to each MCMC iteration.
