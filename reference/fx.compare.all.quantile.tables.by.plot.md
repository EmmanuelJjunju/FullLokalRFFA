# Compare quantile tables from multiple results objects using a two_panel plot

This function extracts quantile tables from a `results` list, converts
return_period labels (Mean, T2, T5, ) into numeric values, and produces
a two_panel ggplot:

## Usage

``` r
fx.compare.all.quantile.tables.by.plot(results, colors = NULL)
```

## Arguments

- results:

  A named list where each element contains a `$table` with columns Name,
  Post.mean, Lower, Upper, Relative.

- colors:

  color vector

## Value

A ggplot object with two vertically stacked panels.

## Details

- **Panel 1:** Post.mean (m^3/s) with uncertainty ribbon (Lower-Upper)

- **Panel 2:** Relative (ratio), no ribbon

The x_axis is log_scaled (1-1000 years), and all datasets are shown with
a shared legend. Numeric conversion warnings are suppressed to handle
text_formatted tables gracefully.
