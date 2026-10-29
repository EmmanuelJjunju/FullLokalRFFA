# Build a two_panel Leaflet map with optional climate panel and click_to_zoom

This function constructs a two_panel HTML layout consisting of a large
`leaflet` map on the left and an optional information panel on the
right. The map always displays the supplied catchment polygon(s),
together with Geocache WMAS WGS84 basemaps, provider tiles, and optional
popup tables derived from climate mappings. If a klima table is
supplied, it is rendered as a static HTML panel in the right_hand
column.

## Usage

``` r
fx.build.klima.map(
  s = NULL,
  map6190 = NULL,
  map9120 = NULL,
  klima = NULL,
  map.width = "1000%",
  map.height = "900px",
  station_name = "Station",
  station_lon = NULL,
  station_lat = NULL
)
```

## Arguments

- s:

  An `sf` object containing the catchment polygon(s) from NEVINA.
  Required. The geometry is automatically transformed to EPSG:4326 for
  Leaflet.

- map6190:

  Optional named character vector mapping standardized climate variable
  names to shapefile fields for the 1961-1990 period. If provided
  together with `map9120`, popup tables will be generated.

- map9120:

  Optional named character vector mapping standardized climate variable
  names to shapefile fields for the 1991-2020 period. Used together with
  `map6190` to build popup tables.

- klima:

  Optional data frame or matrix containing a combined climate summary
  table (wide format) with columns `Variable`, `1961-1990`, and
  `1991-2020`. If supplied, the table is displayed in a right_hand
  information panel.

- map.width:

  Width of the Leaflet map widget default "100%"

- map.height:

  Height of the Leaflet map widget (default `"900px"`).

- station_name:

  Character. Name of station (default `"Station"`).

- station_lon:

  Numeric. Longitude of station (default `NULL`).

- station_lat:

  Numeric. Latitude of station (default `NULL`).

## Value

A browsable HTML widget containing the two_panel layout. The left panel
contains the Leaflet map; the right panel contains the optional climate
table.

## Details

A click_to_zoom feature is included: clicking the catchment polygon
resets the map view to the full spatial extent of the shapefile. This is
implemented via a small JavaScript handler attached through
[`htmlwidgets::onRender()`](https://rdrr.io/pkg/htmlwidgets/man/onRender.html).
