# Read and check climate variables from a CSV file

Read and check the climate file. Rearrange and relabel, in order to
standardize the content before returning it.

## Usage

``` r
get.climate.variables(filename.csv)
```

## Arguments

- filename.csv:

  Character. Path to the climate CSV file.

## Value

A standardized data.frame containing the extracted climate variables, or
NULL if required columns are missing or unreadable.
