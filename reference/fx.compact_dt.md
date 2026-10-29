# Create a compact, left-aligned DT table

This helper produces a compact DataTable widget that:

- shrinks to content width (no full-page stretching)

- left-aligns the table and caption

- applies a small, configurable font size

- works reliably in Jupyter, R Markdown, and VS Code notebooks

## Usage

``` r
fx.compact_dt(df, caption = "", fontsize = 10, pageLength = 25)
```

## Arguments

- df:

  A data frame to display.

- caption:

  A character string used as the table caption.

- fontsize:

  Numeric font size in pixels (default: 10).

- pageLength:

  Numeric number of rows per page (default: 25).

## Value

An htmlwidget containing a compact DT table.
