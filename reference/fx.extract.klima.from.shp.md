# Extract climate statistics (1961-1990 and 1991-2020) from a NEVINA catchment shapefile

This function reads a NEVINA catchment shapefile, extracts climate
variables for the periods 1961-1990 and 1991-2020, and returns
standardized climate tables together with an interactive `leaflet` map.
The map includes a static information panel in the bottom-left corner
showing a combined climate table (wide format) with values rounded to
two decimals, and a small popup table displayed when clicking the
catchment polygon.

## Usage

``` r
fx.extract.klima.from.shp(
  shpfile,
  params6190 = "klima6190.csv",
  params9120 = "klima9120.csv",
  plot.map = TRUE,
  map.width = "1200px",
  map.height = "900px",
  fontsize = 12,
  sep.klima = ";",
  station_name = "Station",
  station_lon = NULL,
  station_lat = NULL
)
```

## Arguments

- shpfile:

  Character. Path to the NEVINA shapefile (e.g., `"NedbfeltF_v4.shp"`).

- params6190:

  Character. Output file path for the 1961-1990 climate table (default
  `"klima6190.csv"`).

- params9120:

  Character. Output file path for the 1991-2020 climate table (default
  `"klima9120.csv"`).

- plot.map:

  Logical. If `TRUE`, an interactive `leaflet` map is generated and
  returned (default `TRUE`).

- map.width:

  Character. Width of the leaflet map widget (default `"1200px"`).

- map.height:

  Character. Height of the leaflet map widget (default `"900px"`).

- fontsize:

  Numeric. Font size (px) used in the DT climate table (default `12`).

- sep.klima:

  Character. Field separator used when writing CSV files (default
  `";"`).

- station_name:

  Character. Name of station (default `"Station"`).

- station_lon:

  Numeric. Longitude of station (default `NULL`).

- station_lat:

  Numeric. Latitude of station (default `NULL`).

## Value

A list containing:

- `s`:

  The `sf` object read from the shapefile.

- `s.tab`:

  The attribute table with geometry removed.

- `klima6190`:

  Data frame of standardized climate variables for 1961-1990.

- `klima9120`:

  Data frame of standardized climate variables for 1991-2020.

- `klima.tbl`:

  A [`DT::datatable`](https://rdrr.io/pkg/DT/man/datatable.html) object
  showing both climate periods.

- `map`:

  A `leaflet` map object with static info panel and popup tables (if
  `plot.map = TRUE`).
