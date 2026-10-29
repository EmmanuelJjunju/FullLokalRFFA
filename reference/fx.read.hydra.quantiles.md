# Read quantile table from Hydra2/Flomanalyse output (daily values)

This function reads the quantile table from a Hydra2/Flomanalyse output
file for one station. It:

## Usage

``` r
fx.read.hydra.quantiles(file)
```

## Arguments

- file:

  Path to the Hydra2/Flomanalyse quantile file.

## Value

A cleaned data.frame with columns: Name, Post.mean, Lower, Upper,
Relative.

## Details

- Skips the header lines

- Reads the 10 quantile rows

- Cleans Hydra's irregular spacing

- Parses Name, Post.mean, Relative, Lower, Upper

- Computes the "Mean" row (RP = 1)

- Reorders columns to: Name, Post.mean, Lower, Upper, Relative

- Formats numeric values consistently
