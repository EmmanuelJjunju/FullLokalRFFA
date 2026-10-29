# Compare Two Quantile Tables Side by Side

Creates a two_column, side_by_side HTML layout showing compact DT tables
for two selected Hydra/FlomQ quantile scenarios. Each table is formatted
with fixed digits, optional special_column precision, and wrapped in a
coloured container for visual comparison.

## Usage

``` r
fx.compare.two.quantile.tables.sidebyside(
  scenarioA,
  scenarioB,
  scenarios.df,
  results,
  special_col = "Relative",
  fontsize = 12,
  bgA = "#eef6ff",
  bgB = "#ffeff5"
)
```

## Arguments

- scenarioA:

  Character. Name of the first scenario to display. Must correspond to a
  name in `results`.

- scenarioB:

  Character. Name of the second scenario to display.

- scenarios.df:

  Optional data frame describing scenarios (not used internally but kept
  for API symmetry).

- results:

  A named list where each element contains a `$table` data frame with
  quantile results.

- special_col:

  Character. Column name that should receive `special_digits`
  formatting. Default is `"Relative"`.

- fontsize:

  Numeric. Base font size passed to
  [`fx.compact_dt()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.compact_dt.md).

- bgA:

  Character. Background colour for scenario A container.

- bgB:

  Character. Background colour for scenario B container.

## Value

An HTML widget (via
[`htmltools::browsable`](https://rstudio.github.io/htmltools/reference/browsable.html))
showing the two formatted tables side by side.

## Details

The function:

- formats numeric columns using fixed digits

- applies special precision to one column (e.g., "Relative")

- builds compact DT widgets using
  [`fx.compact_dt()`](https://emmanueljjunju.github.io/FullLokalRFFA/reference/fx.compact_dt.md)

- arranges them in a responsive two_column grid
