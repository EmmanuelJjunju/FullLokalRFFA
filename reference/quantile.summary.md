# Compute posterior summary statistics for given return periods

Calculates posterior mean, lower bound (2.5%), and upper bound (97.5%)
for a given set of return periods (or the mean if `T.ret = 0`) based on
MCMC samples.

## Usage

``` r
# S3 method for class 'summary'
quantile(T.ret, analysis)
```

## Arguments

- T.ret:

  Numeric vector of return periods. A value of 0 indicates the mean
  estimate.

- analysis:

  A result list returned by
  [`perform.analysis()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/perform.analysis.md).

## Value

A data.frame with columns `Name`, `Post.mean`, `Lower`, and `Upper`.
