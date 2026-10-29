# Perform Bayesian flood frequency analysis using MCMC

Fetches climate data and annual maximum series (AMS), sets initial
parameter values using probability-weighted moments (P-moments), and
performs MCMC sampling for GEV parameters incorporating regional prior
information.

## Usage

``` r
perform.analysis(
  ams.file,
  climate.file.csv,
  is.specific.discharge = FALSE,
  num.mcmc = 1000,
  spacing = 10,
  burnin = 10000,
  num.temp = 1,
  new.reg.coef = FALSE
)
```

## Arguments

- ams.file:

  Character. Path to the AMS data file (one-column text or similar
  readable via `scan`).

- climate.file.csv:

  Character. Path to the CSV file containing climate variables.

- is.specific.discharge:

  Logical. `TRUE` if units are specific discharge (l/km^2/s), `FALSE`
  for total discharge (m^3/s) (default = `FALSE`).

- num.mcmc:

  Integer. Number of MCMC samples to keep (default = 1000).

- spacing:

  Integer. Thinning interval for MCMC sampling (default = 10).

- burnin:

  Integer. Number of burn-in iterations (default = 10000).

- num.temp:

  Integer. Number of temperatures for parallel tempering (default = 1).

- new.reg.coef:

  Logical. If `TRUE`, uses updated regression coefficients (default =
  `FALSE`).

## Value

A list containing:

- `ams`:

  Numeric vector of original annual maxima.

- `clim`:

  Data frame of standardized climate variables.

- `spec`:

  Numeric vector of specific discharges.

- `scale`:

  Scaling factor applied based on catchment area.

- `mcmc`:

  A [`coda::mcmc`](https://rdrr.io/pkg/coda/man/mcmc.html) object
  containing the posterior parameter samples.

- `is.specific.discharge`:

  Logical indicator.
