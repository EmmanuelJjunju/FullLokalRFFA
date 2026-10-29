# Custom functions and packages
#packages

#'Function: install missing packages and load all
#'@param pkgs package names
#' @export
fx.load_packages <- function(pkgs) {
  pkgs <- unique(pkgs)  # remove duplicates
  missing <- pkgs[!pkgs %in% utils::installed.packages()[, "Package"]]

  if (length(missing) > 0) {
    utils::install.packages(missing)
  }

  invisible(lapply(pkgs, library, character.only = TRUE))
}


# Package list (merged + deduplicated + short comments)

pkgs <- c(
  "sf",              # Modern spatial vector data handling
  "leaflet",         # Interactive web maps
  "leaflet.extras",  # Additional functionality & plugins for leaflet, e.g heatmaps, drawing tools, search capabilities, and custom markers.
  "leafpop",         # Popups for leaflet (tables, images, html)
  "DT",              # Interactive HTML data tables
  "htmltools",       # HTML generation utilities
  "dplyr",           # Data manipulation (filter, mutate, etc.)
  "ggplot2",         # Grammar of Graphics plotting
  "purrr",           # Functional programming (map, reduce)
  "tidyr",           # Data tidying (pivot_longer, pivot_wider)
  "coda",            # MCMC diagnostics + convergence tools
  "repr",            # Controls plot sizes in Jupyter/IRkernel
  "MASS",            # Stats functions incl. multivariate sampling
  "mapview",         # Quick interactive spatial maps
  "leaflet.extras2", # Extra Leaflet plugins (draw, heatmaps, etc.)
  "reader" ,         # Fast line-by-line file reading (n.readLines)
  "plotly",          # Creates interactive, web-based charts with hover and zoom.
  "htmlwidgets",     # Connects JavaScript visualizations to R and Shiny.
  "leafem",          #  Adds extra UI tools and enhancements to Leaflet.
  "readxl"           # Imports Excel files (.xls/.xlsx) into R data frames.
)


# Load everything

fx.load_packages(pkgs)



#Plot AMS_data som stolpediagram----
  #' Plot AMS_data som stolpediagram
  #'
  #' Lager et tydelig stolpediagram av AMS_data (dato og verdi),
  #' med aarlige datoetiketter, roterte aksetekster og uten luft
  #' mellom y = 0 og x_aksen.
  #'
  #' @param ams En data.frame med kolonnene \code{date} (Date) og \code{value} (numeric).
  #' @param fontsize Tall som angir skriftstorrelse for aksetekst (default = 12).
  #' @param title Tekst/streng som legges til i tittelen (default = "").
  #' @param label_offset Prosentvis forskyvning av tekstetiketter over soylene (default = 0.05).
  #'
  #' @return En ggplot_figur.
  #' @export
  fx.plot.df.ams <- function(
    ams,
    fontsize = 12,
    title = "",
    label_offset = 0.05   # proportion of max height
  ) {
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop("Pakken 'ggplot2' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # Compute headroom
    ymax <- max(ams$value, na.rm = TRUE)
    pad  <- ymax * 0.20   # 20% padding for safety
    ams$value <- round(ams$value, 1)

    p <- ggplot2::ggplot(ams, ggplot2::aes(x = date, y = value)) +
      ggplot2::geom_col(fill = "lightblue") +

      # Text labels above bars
      ggplot2::geom_text(
        ggplot2::aes(
          label = value,
          y = value + ymax * label_offset   # offset above bar
        ),
        angle = 90,
        color = "darkblue",
        size = fontsize / 3
      ) +

      ggplot2::scale_x_date(
        date_breaks = "1 year",
        date_labels = "%Y"
      ) +
      ggplot2::scale_y_continuous(
        expand = c(0, 0),
        limits = c(0, ymax + pad)
      ) +

      ggplot2::theme_bw() +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(
          angle = 90,
          vjust = 0.5,
          hjust = 1,
          size = fontsize
        ),
        axis.text.y = ggplot2::element_text(size = fontsize)
      ) +
      ggplot2::labs(
        x = "Year",
        y = "Value",
        title = paste0("AMS.", title)
      ) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(size = fontsize)) +
      ggplot2::theme(axis.text.y = ggplot2::element_text(size = fontsize))

    return(p)
  }

##Read AMS data from a Hydra export, save as one_column text, and optionally plot-------
  #' Read AMS data from a Hydra export, save as one_column text, and optionally plot
  #'
  #' Leser dognverdier fra en Hydra_eksport (AMS), rydder formatet,
  #' konverterer dato og verdi til riktig R_format, lagrer verdiene som
  #' en en_kolonne tekstfil, og kan valgfritt plotte dataserien.
  #'
  #' @param ams.hydra.txt Filsti til Hydra_eksporten (tekstfil med dognverdier).
  #' @param ams.txt Filsti for lagring av en_kolonne AMS_verdier.
  #' @param plot Logical. Hvis \code{TRUE}, returneres ogsaa et ggplot_objekt (default = TRUE).
  #' @param title Tittel paa plottet/tabellen (default = "HYDRA2").
  #'
  #' @return En liste med \code{ams} (data.frame), \code{DT} og eventuelt \code{plot}.
  #' @export
  #'
  #'
  fx.read.save.ams.from.hydra <- function(ams.hydra.txt, ams.txt, plot = TRUE, title = "HYDRA2") {
    if (!requireNamespace("DT", quietly = TRUE)) {
      stop("Pakken 'DT' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
      stop("Pakken 'htmlwidgets' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # les fra hydra-eksport (dogndata)
    ams <- readLines(ams.hydra.txt)
    ams <- ams[-(1:5)]                  # fjern header
    ams <- trimws(ams)
    ams <- as.data.frame(do.call(rbind, strsplit(ams, " +")))
    ams <- ams[, 2:3]                   # behold dato og verdi
    names(ams) <- c("date", "value")

    # konverter typer
    ams$value <- round(as.numeric(ams$value), 1)
    ams$date  <- as.Date(ams$date, format = "%d.%m.%Y")

    DT <- DT::datatable(ams, caption = paste0("AMS.Qdogn.", title), options = list(dom = 'tp')) |>
      htmlwidgets::onRender("function(el,x){$('table.dataTable').css('font-size','10px');}")

    out <- list(ams = ams, DT = DT)

    # lagre en-kolonne AMS-verdier
    utils::write.table(
      ams$value,
      ams.txt,
      quote = FALSE,
      row.names = FALSE,
      col.names = FALSE,
      sep = ","
    )

    # valgfritt plott
    if (plot) {
      p <- fx.plot.df.ams(ams, title = title)
      out <- list(ams = ams, plot = p, DT = DT)
    }

    return(out)
  }

#Create a compact, left-aligned DT table------
  #' Create a compact, left-aligned DT table
  #'
  #' This helper produces a compact DataTable widget that:
  #' - shrinks to content width (no full-page stretching)
  #' - left-aligns the table and caption
  #' - applies a small, configurable font size
  #' - works reliably in Jupyter, R Markdown, and VS Code notebooks
  #'
  #' @param df A data frame to display.
  #' @param caption A character string used as the table caption.
  #' @param fontsize Numeric font size in pixels (default: 10).
  #' @param pageLength Numeric number of rows per page (default: 25).
  #'
  #' @return An htmlwidget containing a compact DT table.
  #' @export
  #'
  fx.compact_dt <- function(df, caption = "", fontsize = 10, pageLength = 25) {
    if (!requireNamespace("DT", quietly = TRUE)) {
      stop("Pakken 'DT' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
      stop("Pakken 'htmlwidgets' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("htmltools", quietly = TRUE)) {
      stop("Pakken 'htmltools' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # Build DT widget WITHOUT caption
    dt <- DT::datatable(
      df,
      caption = NULL,   # IMPORTANT: do NOT use DT caption for styled text
      options = list(
        dom = 'tp',
        pageLength = pageLength,
        autoWidth = TRUE
      )
    ) |>
      htmlwidgets::onRender(
        sprintf("
        function(el,x){
          $('table.dataTable').css('font-size','%spx');
          $(el).find('table').css('width','auto');
          $(el).css('margin-left','0');
        }
      ", fontsize)
      )

    # Wrap caption ABOVE the table
    htmltools::div(
      style = "width: fit-content; text-align: left;",
      if (!is.null(caption) && caption != "")
        htmltools::div(
          htmltools::tags$strong(caption),
          style = "margin-bottom:4px; font-size:14px;"
        ),
      dt
    )
  }

#Read Sildre/Hydra time series--------
  #' Read Sildre/Hydra time series, aggregate to daily values, extract AMS, save results, and optionally plot
  #' Leser en timesopplost eller dognopplost Sildre/Hydra_tidsserie, konverterer verdier,
  #' aggregerer til dognmiddel (og dognmaksimum hvis timesopplost), beregner aarlige maksimumsverdier (AMS),
  #' lagrer AMS_seriene som en_kolonne tekstfiler, og kan valgfritt generere plott.
  #' Hvis input allerede er dognopplost (dvs. ingen tidssteg < 24 timer), beregnes kun dognmiddel og AMS
  #' for denne serien, og dognmaks_grenen utelates.
  #'
  #' @param file Filsti til Sildre/Hydra tidsseriefilen.
  #' @param sep Feltseparator i filen (default \code{";"}).
  #' @param ams.qdogn.txt Filsti for lagring av AMS basert paa dognmiddel.
  #' @param ams.qmom.txt Filsti for lagring av AMS basert paa dognmaksimum (kun hvis timesopplost input).
  #' @param plot Logical. Hvis \code{TRUE}, inkluderes ggplot_objekter i returstrukturen.
  #' @param title Tittel paa plott/tabeller (default = "AMS SILDRE").
  #' @param fontsize Skriftstorrelse for tabell (default = 12).
  #' @param start_year NULL eller et tall som angir startaar (default = NULL, bruker forste aar i data).
  #' @param end_year Tall som angir sluttaar (default = 2025, NULL bruker siste aar i data).
  #'
  #' @return En liste med en eller to hovedkomponenter:
  #'   \describe{
  #'     \item{\code{daily_mean}}{Liste med \code{ams}, \code{plot}, og \code{DT}.}
  #'     \item{\code{daily_max}}{Kun hvis timesopplost input: liste med \code{ams}, \code{plot}, og \code{DT}.}
  #'   }
  #' @export
  fx.sildre.timeseries.to.ams <- function(file, sep = ";",
                                          ams.qdogn.txt,
                                          ams.qmom.txt,
                                          plot = TRUE,
                                          title = "AMS SILDRE",
                                          fontsize = 12,
                                          start_year = NULL,
                                          end_year = 2025) {
    if (!requireNamespace("dplyr", quietly = TRUE)) {
      stop("Pakken 'dplyr' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # ---- read raw data ----
    raw <- utils::read.table(
      file,
      sep = sep,
      header = TRUE,
      stringsAsFactors = FALSE,
      skip = 1
    )

    # rename first two columns (Sildre/Hydra standard)
    names(raw)[1:2] <- c("datetime", "value")

    # convert decimal comma -> decimal point
    raw$value <- as.numeric(gsub(",", ".", raw$value))

    # convert datetime
    raw$datetime <- as.POSIXct(raw$datetime, format = "%Y-%m-%d %H:%M:%SZ", tz = "UTC")

    # ---- detect hourly vs daily using actual time differences ----
    datesi <- as.Date(raw$datetime)
    dt <- diff(datesi) # gives time difference in days
    is_hourly <- any(dt < 1)

    # always create date column
    raw$date <- as.Date(raw$datetime)

    # ---- daily mean always computed ----
    daily_mean <- stats::aggregate(value ~ date, data = raw, FUN = mean, na.rm = TRUE)
    daily_mean$value <- daily_mean$value
    daily_mean$year <- format(daily_mean$date, "%Y")
    ams_mean <- stats::aggregate(value ~ year, data = daily_mean, FUN = max)

    # ams_mean has columns: year, value
    ams_mean$year <- as.integer(ams_mean$year)
    # Handle NULL start_year and end_year
    start_year_use <- if (is.null(start_year)) min(ams_mean$year) else start_year
    end_year_use   <- if (is.null(end_year))   max(ams_mean$year) else end_year

    # Filter AMS to the selected window
    ams_mean <- dplyr::filter(
      ams_mean,
      year >= start_year_use,
      year <= end_year_use
    )

    # save AMS mean
    utils::write.table(
      ams_mean$value,
      ams.qdogn.txt,
      quote = FALSE, row.names = FALSE, col.names = FALSE, sep = ","
    )

    # plot mean
    plot_mean <- NULL
    if (plot) {
      plot_mean <- fx.plot.df.ams(
        data.frame(
          date  = as.Date(paste0(ams_mean$year, "-01-01")),
          value = ams_mean$value
        ),
        fontsize = 12, title = paste0("Qdogn.", title)
      )
    }

    # ---- if hourly: compute daily max + AMS max ----
    if (is_hourly) {

      daily_max <- stats::aggregate(value ~ date, data = raw, FUN = max, na.rm = TRUE)
      daily_max$year <- format(daily_max$date, "%Y")
      ams_max <- stats::aggregate(value ~ year, data = daily_max, FUN = max)

      ams_max$year <- as.integer(ams_max$year)
      start_year_use <- if (is.null(start_year)) min(ams_max$year) else start_year
      end_year_use   <- if (is.null(end_year))   max(ams_max$year) else end_year

      # Filter AMS to the selected window
      ams_max <- dplyr::filter(
        ams_max,
        year >= start_year_use,
        year <= end_year_use
      )

      # save AMS max
      utils::write.table(
        ams_max$value,
        ams.qmom.txt,
        quote = FALSE, row.names = FALSE, col.names = FALSE, sep = ","
      )

      plot_max <- NULL
      if (plot) {
        plot_max <- fx.plot.df.ams(
          data.frame(
            date  = as.Date(paste0(ams_max$year, "-01-01")),
            value = ams_max$value
          ),
          fontsize = 12, title = paste0("Qmom.", title)
        )
      }

      return(list(
        daily_mean = list(
          ams   = ams_mean,
          plot  = plot_mean,
          DT = fx.compact_dt(ams_mean, caption = paste0("AMS.Qdogn.", title), fontsize = fontsize)
        ),
        daily_max = list(
          ams   = ams_max,
          plot  = plot_max,
          DT = fx.compact_dt(ams_max, caption = paste0("AMS.Qmom.", title), fontsize = fontsize)
        )
      ))
    }

    # ---- if daily input: return only mean branch ----
    return(list(
      daily_mean = list(
        ams   = ams_mean,
        plot  = plot_mean,
        DT = fx.compact_dt(ams_mean, caption = paste0("AMS.Qdogn.", title), fontsize = fontsize)
      )
    ))
  }

#Build a two_panel Leaflet map----------
  #' Build a two_panel Leaflet map with optional climate panel and click_to_zoom
  #'
  #' This function constructs a two_panel HTML layout consisting of a large
  #' \code{leaflet} map on the left and an optional information panel on the
  #' right. The map always displays the supplied catchment polygon(s), together
  #' with Geocache WMAS WGS84 basemaps, provider tiles, and optional popup tables
  #' derived from climate mappings. If a klima table is supplied, it is rendered
  #' as a static HTML panel in the right_hand column.
  #'
  #' A click_to_zoom feature is included: clicking the catchment polygon resets
  #' the map view to the full spatial extent of the shapefile. This is implemented
  #' via a small JavaScript handler attached through \code{htmlwidgets::onRender()}.
  #'
  #' @param s An \code{sf} object containing the catchment polygon(s) from NEVINA. Required.
  #'   The geometry is automatically transformed to EPSG:4326 for Leaflet.
  #'
  #' @param map6190 Optional named character vector mapping standardized climate
  #'   variable names to shapefile fields for the 1961-1990 period. If provided
  #'   together with \code{map9120}, popup tables will be generated.
  #'
  #' @param map9120 Optional named character vector mapping standardized climate
  #'   variable names to shapefile fields for the 1991-2020 period. Used together
  #'   with \code{map6190} to build popup tables.
  #'
  #' @param klima Optional data frame or matrix containing a combined climate
  #'   summary table (wide format) with columns \code{Variable}, \code{1961-1990},
  #'   and \code{1991-2020}. If supplied, the table is displayed in a right_hand
  #'   information panel.
  #' @param map.width Width of the Leaflet map widget default "100%"
  #' @param map.height Height of the Leaflet map widget (default \code{"900px"}).
  #' @param station_name Character. Name of station (default \code{"Station"}).
  #' @param station_lon Numeric. Longitude of station (default \code{NULL}).
  #' @param station_lat Numeric. Latitude of station (default \code{NULL}).
  #'
  #' @return A browsable HTML widget containing the two_panel layout. The left
  #'   panel contains the Leaflet map; the right panel contains the optional
  #'   climate table.
  #' @importFrom dplyr %>%
  #' @importFrom methods show
  #' @importFrom utils install.packages installed.packages
  #' @export
  fx.build.klima.map <- function(
    s = NULL,
    map6190 = NULL,
    map9120 = NULL,
    klima = NULL,
    map.width = "1000%",
    map.height = "900px",
    station_name = "Station",
    station_lon = NULL,
    station_lat = NULL
  ) {
    if (is.null(s)) {
      return(NULL)
    }

    if (!requireNamespace("sf", quietly = TRUE)) {
      stop("Pakken 'sf' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("leaflet", quietly = TRUE)) {
      stop("Pakken 'leaflet' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("leafpop", quietly = TRUE)) {
      stop("Pakken 'leafpop' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("htmltools", quietly = TRUE)) {
      stop("Pakken 'htmltools' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
      stop("Pakken 'htmlwidgets' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    if (!requireNamespace("dplyr", quietly = TRUE)) {
      stop("Pakken 'dplyr' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # station.lon and station.lat are function arguments, default NULL
    if (!is.null(station_lon) && !is.null(station_lat)) {
      print(station_name)
      sf_station <- sf::st_as_sf(
        data.frame(
          lon = station_lon,
          lat = station_lat,
          name = station_name
        ),
        coords = c("lon", "lat"),
        crs = 4326
      )
    } else {
      sf_station <- NULL
    }

    # Always transform geometry
    s.ll <- sf::st_transform(s, 4326)


    # 1) POPUP TABLE (only if map6190/map9120 provided)

    popup.tbl <- NULL

    if (!is.null(map6190) && !is.null(map9120)) {

      popup.fields <- unique(c(map6190, map9120))
      s.popup <- s[, popup.fields]

      popup.tbl <- lapply(
        seq_len(nrow(s.popup)),
        function(i) {
          tbl <- leafpop::popupTable(
            s.popup[i, , drop = FALSE],
            feature.id = FALSE,
            row.numbers = FALSE
          )
          as.character(
            htmltools::tags$div(
              style = "
                            background:white;
                            padding:2px;
                            border:1px solid #999;
                            font-size:8px;
                            max-width:250px;
                            overflow-x:auto;
                        ",
              htmltools::HTML(tbl)
            )
          )
        }
      )
    }


    # 2) KLIMA PANEL HTML (only if klima provided)

    klima.panel <- NULL

    if (!is.null(klima)) {
      klima.html <- paste0(
        "<table style='font-size:11px; border-collapse:collapse;'>",
        "<tr><th style='text-align:left; padding:4px; border-bottom:1px solid #ccc;'>Variable</th>",
        "<th style='text-align:right; padding:4px; border-bottom:1px solid #ccc;'>1961-1990</th>",
        "<th style='text-align:right; padding:4px; border-bottom:1px solid #ccc;'>1991-2020</th></tr>",
        paste(
          apply(klima, 1, function(row) {
            sprintf(
              "<tr>
                            <td style='padding:3px;'>%s</td>
                            <td style='padding:3px; text-align:right;'>%s</td>
                            <td style='padding:3px; text-align:right;'>%s</td>
                        </tr>",
              row[1], row[2], row[3]
            )
          }),
          collapse = ""
        ),
        "</table>"
      )

      klima.panel <- htmltools::tags$div(
        style = "
                background:rgba(255,255,255,0.95);
                padding:10px;
                border:1px solid #666;
                font-size:11px;
                max-width:350px;
                overflow-y:auto;
                max-height:850px;
            ",
        htmltools::tags$b("Klima (1961-1990 vs 1991-2020)"),
        htmltools::HTML(klima.html)
      )
    }


    # 3) BUILD LEAFLET MAP (always)

    bbox <- sf::st_bbox(s.ll)
    map <- leaflet::leaflet(width = "100%", height = map.height,
                            options = leaflet::leafletOptions(zoomControl = TRUE,
                                                              attributionControl = FALSE)) |>
      leaflet::addScaleBar(
        position = "bottomleft",
        options = leaflet::scaleBarOptions(maxWidth = 200, metric = TRUE, imperial = FALSE)
      ) |>
      htmlwidgets::onRender("
        function(el, x) {
          var scaleLine = el.querySelector('.leaflet-control-scale-line');
          scaleLine.style.height = '30px';
          scaleLine.style.background = 'none';
          scaleLine.style.border = 'none';
          scaleLine.style.backgroundImage = 'linear-gradient(90deg, #000 50%, #fff 50%)';
          scaleLine.style.backgroundSize = '40px 12px';
          scaleLine.style.backgroundRepeat = 'repeat-x';
          scaleLine.style.backgroundPosition = 'bottom';
          scaleLine.style.borderBottom = '2px solid #000';
          scaleLine.style.borderLeft = '2px solid #000';
          scaleLine.style.borderRight = '2px solid #000';
          scaleLine.style.color = '#000';
          scaleLine.style.fontWeight = 'bold';
          scaleLine.style.fontSize = '12px';
          scaleLine.style.lineHeight = '1';
          scaleLine.style.textAlign = 'center';
          scaleLine.style.display = 'flex';
          scaleLine.style.alignItems = 'flex-start';
          scaleLine.style.justifyContent = 'center';
        }
    ") |>
      leaflet::addProviderTiles("OpenStreetMap", group = "OSM") |>
      leaflet::addProviderTiles("CartoDB.Positron", group = "Carto Light") |>
      leaflet::addProviderTiles("Esri.WorldImagery", group = "Esri Satellite") |>
      leaflet::addProviderTiles("OpenTopoMap", group = "Topo") |>
      leaflet::addTiles(
        urlTemplate = "https://services.geodataonline.no/arcgis/rest/services/Geocache_WMAS_WGS84/GeocacheBasis/MapServer/tile/{z}/{y}/{x}",
        group = "Geocache Basis"
      ) |>
      leaflet::addTiles(
        urlTemplate = "https://services.geodataonline.no/arcgis/rest/services/Geocache_WMAS_WGS84/GeocacheBilder/MapServer/tile/{z}/{y}/{x}",
        group = "Geocache Bilder"
      ) |>
      leaflet::addTiles(
        urlTemplate = "https://services.geodataonline.no/arcgis/rest/services/Geocache_WMAS_WGS84/GeocacheLandskap/MapServer/tile/{z}/{y}/{x}",
        group = "Geocache Landskap"
      ) |>
      leaflet::addTiles(
        urlTemplate = "https://services.geodataonline.no/arcgis/rest/services/Geocache_WMAS_WGS84/GeocacheTerreng/ImageServer/tile/{z}/{y}/{x}",
        group = "Geocache Terreng"
      ) |>
      leaflet::addTiles(
        urlTemplate = "https://services.geodataonline.no/arcgis/rest/services/Geocache_WMAS_WGS84/GeocacheTerrengskygge/MapServer/tile/{z}/{y}/{x}",
        group = "Geocache Terrengskygge",
        options = leaflet::tileOptions(opacity = 0.4)
      ) |>
      leaflet::addPolygons(
        data = s.ll,
        color = "black",
        weight = 2,
        fillOpacity = 0.2,
        popup = popup.tbl,
        group = "Catchment",
        layerId = "Catchment"
      ) |>
      leafem::addHomeButton(group = "Catchment", position = "topright") |>
      leaflet::addLayersControl(
        baseGroups = c(
          "Topo",
          "Geocache Basis",
          "Geocache Bilder",
          "Geocache Landskap",
          "Geocache Terreng",
          "OSM",
          "Carto Light",
          "Esri Satellite"
        ),
        overlayGroups = c(
          "Station",
          "Catchment",
          "Geocache Terrengskygge"
        ),
        position = "bottomright",
        options = leaflet::layersControlOptions(collapsed = TRUE)
      ) |>
      htmlwidgets::onRender("
            function(el, x) {
              var toggle = el.querySelector('.leaflet-control-layers-toggle');
              var label = document.createElement('span');
              label.innerHTML = ' Select Layers';
              label.style.paddingLeft = '15px';
              label.style.lineHeight = '20px';
              label.style.fontWeight = 'bold';
              label.style.color = '#333';
              toggle.appendChild(label);
              toggle.style.width = 'auto';
              toggle.style.backgroundPosition = '5px 50%';
              toggle.style.paddingRight = '10px';
            }
        ") |>
      htmlwidgets::onRender("
            function(el, x) {
              $('.leaflet-control-layers-base').prepend('<label style=\"text-align:center; font-weight:bold\">Basemaps</label>');
              $('.leaflet-control-layers-overlays').prepend('<label style=\"text-align:center; font-weight:bold\">TOC</label>');
            }
        ") |>
      leaflet::fitBounds(
        lng1 = bbox[["xmin"]], lat1 = bbox[["ymin"]],
        lng2 = bbox[["xmax"]], lat2 = bbox[["ymax"]],
        options = list(padding = c(10, 10))
      ) |>
      htmlwidgets::prependContent(
        htmltools::tags$style(htmltools::HTML("
                .leaflet-control-layers-expanded {
                max-height: 300px;
                overflow-y: auto;
                }
                .leaflet-control-layers {
                opacity: 0.7;
                transition: opacity 0.2s;
                }
                .leaflet-control-layers:hover {
                opacity: 1;
                }
            "))
      ) |>
      leaflet.extras::addFullscreenControl(
        position = "topleft",
        pseudoFullscreen = FALSE
      ) |>
      htmlwidgets::onRender("
            function(el, x) {
              var fsButton = el.querySelector('.leaflet-control-fullscreen a');
              var fsLabel = document.createElement('span');
              fsLabel.innerHTML = '&#x26F6';
              fsLabel.style.paddingLeft = '10px';
              fsLabel.style.lineHeight = '10px';
              fsLabel.style.fontWeight = 'bold';
              fsLabel.style.color = '#333';
              fsButton.appendChild(fsLabel);
              fsButton.style.width = 'auto';
              fsButton.style.display = 'flex';
              fsButton.style.alignItems = 'center';
              fsButton.style.paddingRight = '10px';
            }
        ")

    # add station point
    if (!is.null(sf_station)) {
      map <- map |>
        leaflet::addTiles() |>
        leaflet::addCircleMarkers(
          data = sf_station,
          radius = 8,
          color = "blue",
          fillColor = "blue",
          fillOpacity = 0.9,
          group = "Station",
          label = ~paste("VM:", name),
          labelOptions = leaflet::labelOptions(noHide = TRUE, textsize = "12px")
        )
    }

    map <- htmlwidgets::onRender(
      map,
      sprintf("
            function(el, x) {
                var map = el.querySelector('.leaflet-container')._leaflet_map;
                var bounds = [[%f, %f], [%f, %f]];

                map.on('click', function(e) {
                    if (e.layer && e.layer.options.layerId === 'Catchment') {
                        map.fitBounds(bounds);
                    }
                });
            }
        ",
              sf::st_bbox(s.ll)[2],  # ymin (south)
              sf::st_bbox(s.ll)[1],  # xmin (west)
              sf::st_bbox(s.ll)[4],  # ymax (north)
              sf::st_bbox(s.ll)[3]   # xmax (east)
      )
    )


    # 4) RETURN TWO-PANEL LAYOUT

    htmltools::browsable(
      htmltools::div(
        style = "display:flex; gap:10px;",

        # LEFT PANEL: MAP (big)
        htmltools::div(
          style = "
                    width:700px;
                    display:flex;
                    flex-direction:column;
                    gap:15px;
                ",
          map
        ),

        # RIGHT PANEL: Controls + Klima table
        htmltools::div(
          style = "
                    width:300px;
                    display:flex;
                    flex-direction:column;
                    gap:15px;
                ",
          if (!is.null(klima.panel)) klima.panel
        )
      )
    )
  }
#Extract climate stats (1961-1990 and 1991-2020) from a NEVINA shapefile--------
  #' Extract climate statistics (1961-1990 and 1991-2020) from a NEVINA catchment shapefile
  #'
  #' This function reads a NEVINA catchment shapefile, extracts climate variables
  #' for the periods 1961-1990 and 1991-2020, and returns standardized climate
  #' tables together with an interactive \code{leaflet} map. The map includes a
  #' static information panel in the bottom-left corner showing a combined climate
  #' table (wide format) with values rounded to two decimals, and a small popup
  #' table displayed when clicking the catchment polygon.
  #'
  #' @param shpfile Character. Path to the NEVINA shapefile
  #'   (e.g., \code{"NedbfeltF_v4.shp"}).
  #' @param params6190 Character. Output file path for the 1961-1990 climate table
  #'   (default \code{"klima6190.csv"}).
  #' @param params9120 Character. Output file path for the 1991-2020 climate table
  #'   (default \code{"klima9120.csv"}).
  #' @param plot.map Logical. If \code{TRUE}, an interactive \code{leaflet} map is
  #'   generated and returned (default \code{TRUE}).
  #' @param map.width Character. Width of the leaflet map widget
  #'   (default \code{"1200px"}).
  #' @param map.height Character. Height of the leaflet map widget
  #'   (default \code{"900px"}).
  #' @param fontsize Numeric. Font size (px) used in the DT climate table
  #'   (default \code{12}).
  #' @param sep.klima Character. Field separator used when writing CSV files
  #'   (default \code{";"}).
  #' @param station_name Character. Name of station (default \code{"Station"}).
  #' @param station_lon Numeric. Longitude of station (default \code{NULL}).
  #' @param station_lat Numeric. Latitude of station (default \code{NULL}).
  #'
  #' @return A list containing:
  #' \describe{
  #'   \item{\code{s}}{The \code{sf} object read from the shapefile.}
  #'   \item{\code{s.tab}}{The attribute table with geometry removed.}
  #'   \item{\code{klima6190}}{Data frame of standardized climate variables for 1961-1990.}
  #'   \item{\code{klima9120}}{Data frame of standardized climate variables for 1991-2020.}
  #'   \item{\code{klima.tbl}}{A \code{DT::datatable} object showing both climate periods.}
  #'   \item{\code{map}}{A \code{leaflet} map object with static info panel and popup tables
  #'     (if \code{plot.map = TRUE}).}
  #' }
  #'
  #'
  #' @export
  fx.extract.klima.from.shp <- function(
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
  ) {
    if (!requireNamespace("sf", quietly = TRUE)) {
      stop("Pakken 'sf' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("leaflet", quietly = TRUE)) {
      stop("Pakken 'leaflet' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("leafpop", quietly = TRUE)) {
      stop("Pakken 'leafpop' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("DT", quietly = TRUE)) {
      stop("Pakken 'DT' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("htmltools", quietly = TRUE)) {
      stop("Pakken 'htmltools' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # ---- read shapefile ----
    s <- sf::st_read(shpfile, quiet = TRUE)
    s.tab <- sf::st_drop_geometry(s)

    # ---- mapping for 1961-1990 ----
    map6190 <- c(
      area.km2 = "areal_km2",
      avr.specific.discharge = "QN6190_lsk",
      eff.lake.perc = "effsjoPro",
      river.length.main.km = "elveLengde",
      temp.feb.celcius = "tmFeb_6190",
      temp.mar.celcius = "tmMar_6190",
      precip.melt.may = "qtMai_6190",
      glacier.perc = "brePro",
      forest.perc = "skoPro",
      hypso.height.10perc = "height10",
      precipitation.july = "rrJul_6190",
      sum.precip.melt.june = "qtJun_6190",
      total.river.length.without.lakes.all.km = "sumElvLen"
    )

    # ---- mapping for 1991-2020 ----
    map9120 <- c(
      area.km2 = "areal_km2",
      avr.specific.discharge = "QN9120_lsk",
      eff.lake.perc = "effsjoPro",
      river.length.main.km = "elveLengde",
      temp.feb.celcius = "tmFeb_9120",
      temp.mar.celcius = "tmMar_9120",
      precip.melt.may = "qtMai_9120",
      glacier.perc = "brePro",
      forest.perc = "skoPro",
      hypso.height.10perc = "height10",
      precipitation.july = "rrJul_9120",
      sum.precip.melt.june = "qtJun_9120",
      total.river.length.without.lakes.all.km = "sumElvLen"
    )

    # ---- extract and rename ----
    klima6190 <- s.tab[, map6190]
    names(klima6190) <- names(map6190)

    klima9120 <- s.tab[, map9120]
    names(klima9120) <- names(map9120)

    # ---- combined table (wide format, 2 decimals) ----
    klima <- cbind(
      Variable = names(klima6190),
      `1961-1990` = sprintf("%.2f", as.numeric(klima6190[1, ])),
      `1991-2020` = sprintf("%.2f", as.numeric(klima9120[1, ]))
    )

    # ---- DT table output ----
    klima.tbl <- fx.compact_dt(
      df = t(rbind(klima6190, klima9120)),
      caption = "Klima 1961-1990 | Klima 1991-2020 (Feltparametre)",
      fontsize = fontsize
    )

    # ---- write CSV files ----
    utils::write.table(klima6190, params6190, sep = sep.klima, quote = FALSE, row.names = FALSE)
    utils::write.table(klima9120, params9120, sep = sep.klima, quote = FALSE, row.names = FALSE)

    # ---- leaflet map ----
    map <- NULL
    if (plot.map) {
      map <- fx.build.klima.map(
        s = s,
        map6190 = map6190,
        map9120 = map9120,
        klima = klima,
        map.width = map.width,
        map.height = map.height,
        station_name = station_name,
        station_lon = station_lon,
        station_lat = station_lat
      )
    }

    list(
      s = s,
      s.tab = s.tab,
      klima6190 = klima6190,
      klima9120 = klima9120,
      klima.tbl = klima.tbl,
      map = map
    )
  }

#Plot Bayesian flood frequency curve--------------
  #' Plot Bayesian flood frequency curve with extended NVE-style uncertainty
  #'
  #' This version expands the lower-tail plotting-position uncertainty by clamping
  #' probabilities \eqn{p \le 0} to an extremely small positive value
  #' (\eqn{10^{-30}}), allowing the uncertainty bars to extend much further left,
  #' consistent with NVE's Hydra/FlomQ implementation. Ascending ranks are used
  #' for uncertainty, and no lower-bound filtering is applied to the resulting
  #' return periods. The upper tail is also clamped to \eqn{1 - \varepsilon} to
  #' avoid premature truncation.
  #'
  #' @param analysis Output from perform.analysis().
  #' @param T.start Minimum return period for the posterior curve.
  #' @param T.end Maximum return period for the posterior curve.
  #' @param plotting.formula Plotting-position constant for observed points.
  #' @param add If TRUE, add to an existing plot.
  #' @param label Legend label.
  #' @param show.pp.uncertainty If TRUE, draw plotting-position uncertainty bars.
  #' @param eps Small positive value for probability clamping.
  #'
  #' @return A plot is produced as a side effect.
  #' @export
  fx.plot.quantile.curve.base <- function(
    analysis,
    T.start = 1.01,
    T.end = 1000,
    plotting.formula = 0.44,
    add = FALSE,
    label = NULL,
    show.pp.uncertainty = TRUE,
    eps = 1e-1000
  ){
    cols <- list(
      main = "#F8766D",
      main.band = "#F8766D",
      add.mean = "#00BFC4",
      add.band = "#00BFC4",
      obs = "black",
      pp.uncert = "grey50"
    )

    pp.constants <- c(
      Gringorten = 0.44,
      Blom       = 0.375,
      Bernard    = 0.30,
      Hazen      = 0.50,
      Beard      = 0.31,
      Larsen     = 0.567,
      OneThird   = 1/3,
      Cunane     = 0.40,
      HerdJohnson = 0,
      Modal       = 1
    )

    # Posterior curve
    T.ret <- exp(seq(log(T.start), log(T.end), length.out = 200))
    res2 <- quantile.summary(T.ret, analysis)

    T.ret <- T.ret[res2$Post.mean > 0.9 * min(analysis$ams) & res2$Lower > 0]
    res2 <- res2[res2$Post.mean > 0.9 * min(analysis$ams) & res2$Lower > 0, ]

    y.title <- if (analysis$is.specific.discharge)
      "Specific discharge (l/km^2/s)"
    else
      "Discharge (m^3/s)"

    if (is.null(label))
      label <- if (!add) "Scenario A" else "Scenario B"

    # Standard hydrology gridlines
    T.grid <- c(1, 2, 5, 10, 20, 50, 100, 200, 500, 1000)
    Y.grid <- pretty(c(res2$Lower, res2$Upper), n = 8)

    if (!add) {

      # Empty plot first
      graphics::plot(
        T.ret, res2$Post.mean,
        log = "x",
        ylim = c(min(res2$Lower), max(res2$Upper)),
        type = "n",
        xaxt = "n",
        xlab = "Return period (years)",
        ylab = y.title
      )
      graphics::axis(1, T.grid, T.grid)

      # Gridlines
      graphics::abline(v = T.grid, col = "grey85", lty = 3)
      graphics::abline(h = Y.grid, col = "grey85", lty = 3)

      # Posterior curve
      graphics::lines(T.ret, res2$Post.mean, col = cols$main, lwd = 3)
      graphics::lines(T.ret, res2$Lower, col = cols$main.band, lty = 2)
      graphics::lines(T.ret, res2$Upper, col = cols$main.band, lty = 2)

      # Observations
      n   <- length(analysis$ams)
      obs <- sort(analysis$ams, decreasing = TRUE)

      i <- 1:n
      p <- ((n + 1 - i) - plotting.formula) / (n + 1 - 2 * plotting.formula)
      T.obs <- 1 / (1 - p)

      graphics::points(T.obs, obs, pch = 1, col = cols$obs)

      # Uncertainty bars
      if (show.pp.uncertainty) {

        for (k in 1:n) {

          # ASCENDING ranks (NVE)
          i <- n + 1 - k

          Tvals <- sapply(pp.constants, function(a) {

            p_val <- (i - a) / (n + 1 - 2 * a)

            # Lower tail clamp
            if (p_val <= 0) p_val <- eps

            # Upper tail clamp
            if (p_val >= 1) p_val <- 1 - eps

            1 / (1 - p_val)
          })

          Tvals <- Tvals[is.finite(Tvals)]

          if (length(Tvals) >= 2) {
            graphics::segments(
              x0 = min(Tvals),
              y0 = obs[k],
              x1 = max(Tvals),
              y1 = obs[k],
              lty = 3,
              col = cols$pp.uncert
            )
          }
        }
      }

      graphics::legend(
        "topleft",
        legend = c(label, "95% CI", "Observed", "Plotting-position uncertainty"),
        col = c(cols$main, cols$main.band, cols$obs, cols$pp.uncert),
        lty = c(1, 2, NA, 3),
        pch = c(NA, NA, 1, NA),
        bty = "n"
      )

    } else {

      # Add mode
      graphics::lines(T.ret, res2$Post.mean, col = cols$add.mean, lwd = 3)
      graphics::lines(T.ret, res2$Lower, col = cols$add.band, lty = 3, lwd = 2)
      graphics::lines(T.ret, res2$Upper, col = cols$add.band, lty = 3, lwd = 2)

      graphics::legend(
        "bottomright",
        legend = c(label, "95% CI"),
        col = c(cols$add.mean, cols$add.band),
        lty = c(1, 3),
        bty = "n"
      )
    }
  }

#Plot Bayesian flood quantile curves with PP uncertainty and observations---------------
  #' Plot Bayesian flood quantile curves with PP uncertainty and observations
  #'
  #' @description
  #' Produces a hydrology-style return-period plot (log-x) with:
  #' scenario-specific posterior quantile curves, pointwise credible intervals,
  #' plotting-position uncertainty bars, and observed annual maxima.
  #'
  #' @param analyses List of analysis objects, one per scenario. Each element must
  #'   contain at least:
  #'   \itemize{
  #'     \item \code{ams}: numeric vector of annual maxima (or other extremes).
  #'     \item \code{is.specific.discharge}: logical; \code{TRUE} if units are
  #'       specific discharge (l/km^2/s), \code{FALSE} for discharge (m^3/s).
  #'     \item any additional components required by \code{quantile.summary()}.
  #'   }
  #' @param labels Optional character vector of scenario labels, same length as
  #'   \code{analyses}. If \code{NULL}, labels are generated as
  #'   \code{"Scenario 1"}, \code{"Scenario 2"}, etc.
  #' @param color Optional character vector of colors for the scenarios.
  #' @param T.start Numeric; minimum return period (years) used for the model
  #'   curves (on the x-axis, in log scale). Must be strictly greater than 1.
  #' @param T.end Numeric; maximum return period (years) used for the model
  #'   curves (on the x-axis, in log scale).
  #' @param plotting.formula Numeric; plotting-position constant \eqn{a} used to
  #'   compute empirical return periods for the observed series, via
  #'   \deqn{p = ((n + 1 - i) - a) / (n + 1 - 2a), \quad T = 1 / (1 - p).}
  #'   Defaults to \code{0.44} (Gringorten).
  #' @param show.pp.uncertainty Logical; if \code{TRUE}, plotting-position
  #'   uncertainty is shown as horizontal segments for each observed value,
  #'   based on a set of alternative plotting-position constants.
  #' @param eps Numeric; small positive value used to clamp plotting probabilities
  #'   away from 0 and 1 when computing return periods for the uncertainty bars.
  #'
  #' @return
  #' A \code{ggplot} object representing the return-period plot.
  #'
  #' @export
  fx.plot.quantile.curves.gg <- function(
    analyses,
    labels = NULL,
    color = NULL,
    T.start = 1.01,
    T.end = 1000,
    plotting.formula = 0.44,
    show.pp.uncertainty = TRUE,
    eps = 1e-30
  ){
    if (!requireNamespace("dplyr", quietly = TRUE)) {
      stop("Pakken 'dplyr' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop("Pakken 'ggplot2' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("purrr", quietly = TRUE)) {
      stop("Pakken 'purrr' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("scales", quietly = TRUE)) {
      stop("Pakken 'scales' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # Colors for scenarios
    n <- length(analyses)
    if (!is.null(color)) { color <- color[1:n] }
    if (is.null(labels)) labels <- paste0("Scenario ", seq_len(n))

    if (!is.null(color) && length(color) == n) {
      scenario_cols <- stats::setNames(color, labels)
    } else {
      scenario_cols <- stats::setNames(scales::hue_pal()(n), labels)
    }

    # Helper: compute posterior curves
    compute_curve <- function(analysis, label) {
      T.ret <- exp(seq(log(T.start), log(T.end), length.out = 300))
      res2  <- quantile.summary(T.ret, analysis)

      keep <- res2$Post.mean > 0.9 * min(analysis$ams) & res2$Lower > 0

      tibble::tibble(
        T = T.ret[keep],
        mean = res2$Post.mean[keep],
        lower = res2$Lower[keep],
        upper = res2$Upper[keep],
        scenario = label,
        is.specific = analysis$is.specific.discharge
      )
    }

    df.curves <- purrr::map2_dfr(analyses, labels, compute_curve)

    # Observations + PP uncertainty
    pp.constants <- c(
      Gringorten = 0.44, Blom = 0.375, Bernard = 0.30, Hazen = 0.50,
      Beard = 0.31, Larsen = 0.567, OneThird = 1/3, Cunane = 0.40,
      HerdJohnson = 0, Modal = 1
    )

    compute_obs <- function(analysis, label) {
      obs <- sort(analysis$ams, decreasing = TRUE)
      n_obs <- length(obs)

      i <- 1:n_obs
      p <- ((n_obs + 1 - i) - plotting.formula) / (n_obs + 1 - 2 * plotting.formula)
      T.obs <- 1 / (1 - p)

      df <- tibble::tibble(
        T = T.obs,
        Q = obs,
        scenario = label
      )

      if (!show.pp.uncertainty)
        return(list(obs = df, unc = NULL))

      df.unc <- purrr::map_dfr(seq_len(n_obs), function(k) {
        i_rank <- n_obs + 1 - k

        Tvals <- sapply(pp.constants, function(a) {
          p_val <- (i_rank - a) / (n_obs + 1 - 2 * a)

          if (p_val <= 0) p_val <- eps
          if (p_val >= 1) p_val <- 1 - eps

          1 / (1 - p_val)
        })

        Tvals <- Tvals[is.finite(Tvals)]

        if (length(Tvals) < 2)
          return(NULL)

        tibble::tibble(
          T.min = min(Tvals),
          T.max = max(Tvals),
          Q = obs[k],
          scenario = label
        )
      })

      if (nrow(df.unc) > 0) {
        df.unc$T.min <- pmax(df.unc$T.min, T.start)
        df.unc$T.max <- pmin(df.unc$T.max, T.end)
      }

      list(obs = df, unc = df.unc)
    }

    obs.list <- purrr::map2(analyses, labels, compute_obs)
    df.obs <- dplyr::bind_rows(purrr::map(obs.list, "obs"))
    df.unc <- dplyr::bind_rows(purrr::map(obs.list, "unc"))

    # Axis structure
    T.grid <- c(1, 2, 5, 10, 20, 50, 100, 200, 500, 1000)
    Y.grid <- pretty(c(df.curves$lower, df.curves$upper), 8)

    y.title <- if (any(df.curves$is.specific))
      "Specific discharge (l/km^2/s)"
    else
      "Discharge (m^3/s)"

    # Build ggplot
    p <- ggplot2::ggplot() +
      ggplot2::geom_line(
        data = df.curves,
        ggplot2::aes(x = .data$T, y = .data$mean, color = .data$scenario, linetype = "Scenario"),
        linewidth = 1.2
      ) +
      ggplot2::geom_line(
        data = df.curves,
        ggplot2::aes(x = .data$T, y = .data$lower, color = .data$scenario, linetype = "CI"),
        linewidth = 0.8
      ) +
      ggplot2::geom_line(
        data = df.curves,
        ggplot2::aes(x = .data$T, y = .data$upper, color = .data$scenario, linetype = "CI"),
        linewidth = 0.8
      ) +
      ggplot2::geom_point(
        data = df.obs,
        ggplot2::aes(x = .data$T, y = .data$Q, shape = "Observed"),
        size = 2,
        color = "black"
      ) +
      {
        if (show.pp.uncertainty && !is.null(df.unc) && nrow(df.unc) > 0)
          ggplot2::geom_segment(
            data = df.unc,
            ggplot2::aes(x = .data$T.min, xend = .data$T.max, y = .data$Q, yend = .data$Q),
            color = "grey50",
            linetype = "dotdash"
          )
      } +
      ggplot2::scale_x_log10(breaks = T.grid, labels = T.grid, minor_breaks = NULL) +
      ggplot2::scale_y_continuous(breaks = Y.grid, labels = Y.grid, minor_breaks = NULL) +
      ggplot2::scale_color_manual(values = scenario_cols) +
      ggplot2::scale_linetype_manual(
        values = c("Scenario" = "solid", "CI" = "dotted"),
        labels = c("Scenario" = "Scenario mean", "CI" = "95% CI")
      ) +
      ggplot2::scale_shape_manual(values = c("Observed" = 1)) +
      ggplot2::labs(
        x = "Return period (years)",
        y = y.title,
        color = "Scenario",
        linetype = NULL,
        shape = NULL
      ) +
      ggplot2::guides(
        color = ggplot2::guide_legend(order = 1),
        linetype = ggplot2::guide_legend(order = 2),
        shape = ggplot2::guide_legend(order = 3)
      ) +
      ggplot2::theme_bw(base_size = 13) +
      ggplot2::theme(
        legend.position = "inside",
        legend.position.inside = c(0.02, 0.98),
        legend.justification = c(0, 1),
        legend.background = ggplot2::element_rect(fill = ggplot2::alpha("white", 0.8), color = NA),
        legend.box = "vertical",
        legend.text = ggplot2::element_text(size = 14),
        legend.title = ggplot2::element_text(size = 16),
        axis.text.x = ggplot2::element_text(size = 12),
        axis.text.y = ggplot2::element_text(size = 12)
      )

    return(p)
  }

#Plot MCMC convergence and marginal distributions from GEV parameters----------------
  #' Plot MCMC convergence and marginal distributions from GEV parameters
  #'
  #' Expert mode function to inspect MCMC samples (original GEV parameters,
  #' except scale which is log-transformed).
  #' var1 = mu (location), var2 = log-sigma (log-scale), var3 = k (shape).
  #'
  #' @param res Result list from running \code{perform.analysis()}.
  #' @param main Character string for the main outer plot title (default = "").
  #'
  #' @return A base R plot is produced as a side effect.
  #' @export
  fx.plot.res.mcmc <- function(res, main = "") {
    if (!requireNamespace("coda", quietly = TRUE)) {
      stop("Pakken 'coda' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # 1. Extract the data (if it is a coda object)
    chain_data <- as.matrix(res$mcmc)

    # 2. Rename columns to your custom names
    colnames(chain_data) <- c("mu(location)", "log-sigma(log-scale)", "k(shape)")

    # 3. Convert back to mcmc object for standard plotting
    mcmc_custom <- coda::as.mcmc(chain_data)

    # 4. Plot
    graphics::par(oma = c(2, 2, 2, 2), mar = c(5, 4, 1, 1))
    plot(mcmc_custom)
    graphics::title(main, outer = TRUE)
    graphics::box("outer", lwd = 2, col = "blue")
  }

#Read quantile table from Hydra2/Flomanalyse output (daily values)------------
  #' Read quantile table from Hydra2/Flomanalyse output (daily values)
  #'
  #' This function reads the quantile table from a Hydra2/Flomanalyse
  #' output file for one station. It:
  #'
  #' * Skips the header lines
  #' * Reads the 10 quantile rows
  #' * Cleans Hydra's irregular spacing
  #' * Parses Name, Post.mean, Relative, Lower, Upper
  #' * Computes the "Mean" row (RP = 1)
  #' * Reorders columns to: Name, Post.mean, Lower, Upper, Relative
  #' * Formats numeric values consistently
  #'
  #' @param file Path to the Hydra2/Flomanalyse quantile file.
  #'
  #' @return A cleaned data.frame with columns:
  #'   Name, Post.mean, Lower, Upper, Relative.
  #'
  #'
  #' @export
  fx.read.hydra.quantiles <- function(file) {

    # reader::n.readLines is used because Hydra files are messy
    if (!requireNamespace("reader", quietly = TRUE)) {
      stop("Pakken 'reader' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # Read the 10 quantile rows (skip Hydra header)
    d <- reader::n.readLines(file, skip = 13, n = 10)

    # Clean Hydra spacing
    clean.hydra.line <- function(x) {
      x <- sub("^\\s+", "", x)        # remove leading spaces
      x <- gsub("\\s+", " ", x)       # collapse multiple spaces/tabs
      x
    }

    d <- clean.hydra.line(d)

    # Split into columns
    d <- as.data.frame(do.call(rbind, strsplit(d, "\\s+")))
    names(d) <- c("Name", "Post.mean", "Relative", "Lower", "Upper")

    # Reorder to: Name, Post.mean, Lower, Upper, Relative
    d <- d[, c("Name", "Post.mean", "Lower", "Upper", "Relative")]
    d$Name <- paste0("T", d$Name)

    # Compute Mean row (RP = 1)
    Post.mean <- round(mean(as.numeric(d$Post.mean) / as.numeric(d$Relative)), 1)

    d.mean <- data.frame(
      Name      = "Mean",
      Post.mean = Post.mean,
      Lower     = Post.mean,
      Upper     = Post.mean,
      Relative  = 1
    )

    # Bind Mean row on top
    d <- rbind(d.mean, d)

    # Format numeric columns
    d[, -1] <- apply(d[, -1], 2, function(x) sprintf("%.3f", as.numeric(x)))
    d[, 2:4] <- apply(d[, 2:4], 2, function(x) sprintf("%.1f", as.numeric(x)))

    # Optional: check relative consistency
    check.relative <- round(as.numeric(d$Post.mean) / as.numeric(d$Post.mean[1]), 3)
    print(check.relative)

    return(d)
  }

#Compare quantile tables from multiple results objects using a two_panel plot---------------
  #' Compare quantile tables from multiple results objects using a two_panel plot
  #'
  #' This function extracts quantile tables from a `results` list, converts
  #' return_period labels (Mean, T2, T5, ) into numeric values, and produces
  #' a two_panel ggplot:
  #'
  #' * **Panel 1:** Post.mean (m^3/s) with uncertainty ribbon (Lower-Upper)
  #' * **Panel 2:** Relative (ratio), no ribbon
  #'
  #' The x_axis is log_scaled (1-1000 years), and all datasets are shown with
  #' a shared legend. Numeric conversion warnings are suppressed to handle
  #' text_formatted tables gracefully.
  #'
  #' @param results A named list where each element contains a `$table`
  #'   with columns Name, Post.mean, Lower, Upper, Relative.
  #' @param colors color vector
  #'
  #' @return A ggplot object with two vertically stacked panels.
  #'
  #'
  #' @export
  fx.compare.all.quantile.tables.by.plot <- function(results, colors = NULL) {
    if (!requireNamespace("dplyr", quietly = TRUE)) {
      stop("Pakken 'dplyr' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("tidyr", quietly = TRUE)) {
      stop("Pakken 'tidyr' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop("Pakken 'ggplot2' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("RColorBrewer", quietly = TRUE)) {
      stop("Pakken 'RColorBrewer' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # 1. Extract and clean tables
    return.tbls <- lapply(names(results), function(x) results[[x]]$table[-1, ])

    return.tbls <- lapply(return.tbls, function(x) {
      x$Name <- suppressWarnings(as.numeric(gsub("T", "", x$Name)))

      rp        <- x$Name
      Post.mean <- suppressWarnings(as.numeric(x$Post.mean))
      Lower     <- suppressWarnings(as.numeric(x$Lower))
      Upper     <- suppressWarnings(as.numeric(x$Upper))
      Relative  <- suppressWarnings(as.numeric(x$Relative))

      data.frame(rp, Post.mean, Lower, Upper, Relative)
    })

    names(return.tbls) <- names(results)

    # 2. Bind all tables
    df <- dplyr::bind_rows(return.tbls, .id = "source")

    # 3. Long format for faceting
    df_long <- df |>
      tidyr::pivot_longer(
        cols = c(.data$Post.mean, .data$Relative),
        names_to = "Variable",
        values_to = "Value"
      )

    # 4. Handle manual colors
    sources <- unique(df_long$source)

    if (is.null(colors)) {
      colors <- stats::setNames(
        RColorBrewer::brewer.pal(max(3, length(sources)), "Dark2")[seq_along(sources)],
        sources
      )
    } else {
      colors <- colors[sources]
    }

    # 5. Plot
    p <- ggplot2::ggplot(df_long, ggplot2::aes(x = .data$rp, y = .data$Value, color = .data$source)) +
      ggplot2::geom_line(
        data = df_long |> dplyr::filter(.data$Variable == "Post.mean"),
        ggplot2::aes(y = .data$Lower),
        linetype = "dashed",
        alpha = 0.8,
        show.legend = FALSE
      ) +
      ggplot2::geom_line(
        data = df_long |> dplyr::filter(.data$Variable == "Post.mean"),
        ggplot2::aes(y = .data$Upper),
        linetype = "dashed",
        alpha = 0.8,
        show.legend = FALSE
      ) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::geom_point(size = 2) +
      ggplot2::scale_x_log10(
        limits = c(1, 1000),
        breaks = c(1, 2, 5, 10, 20, 50, 100, 200, 500, 1000)
      ) +
      ggplot2::scale_color_manual(values = colors) +
      ggplot2::facet_grid(
        rows = ggplot2::vars(.data$Variable),
        scales = "free_y",
        switch = "y",
        labeller = ggplot2::as_labeller(c(
          "Post.mean" = "m^3/s",
          "Relative"  = "Veksttall"
        ))
      ) +
      ggplot2::labs(
        x = "Return period (years, log scale)",
        y = NULL,
        color = "Dataset",
        fill  = "Dataset",
        title = "Return period curves with uncertainty (Post.mean only)"
      ) +
      ggplot2::theme_bw() +
      ggplot2::theme(
        legend.position = "inside",
        legend.position.inside = c(0.02, 0.98),
        legend.justification = c(0, 1),
        legend.background = ggplot2::element_rect(fill = ggplot2::alpha("white", 0.8), color = NA),
        legend.box = "vertical",
        strip.text = ggplot2::element_text(size = 12, face = "bold"),
        axis.text = ggplot2::element_text(size = 11),
        axis.title = ggplot2::element_text(size = 12),
        legend.text = ggplot2::element_text(size = 14),
        legend.title = ggplot2::element_text(size = 16, face = "bold"),
        legend.key.size = grid::unit(0.9, "lines"),
        legend.spacing.x = grid::unit(0.4, "cm"),
        axis.text.x = ggplot2::element_text(size = 12),
        axis.text.y = ggplot2::element_text(size = 12)
      )

    return(p)
  }

#Compare Two Quantile Tables Side by Side------------------
  #' Compare Two Quantile Tables Side by Side
  #'
  #' Creates a two_column, side_by_side HTML layout showing compact DT tables
  #' for two selected Hydra/FlomQ quantile scenarios. Each table is formatted
  #' with fixed digits, optional special_column precision, and wrapped in a
  #' coloured container for visual comparison.
  #'
  #' @param scenarioA Character. Name of the first scenario to display. Must
  #'   correspond to a name in \code{results}.
  #' @param scenarioB Character. Name of the second scenario to display.
  #' @param scenarios.df Optional data frame describing scenarios (not used
  #'   internally but kept for API symmetry).
  #' @param results A named list where each element contains a \code{$table}
  #'   data frame with quantile results.
  #' @param special_col Character. Column name that should receive
  #'   \code{special_digits} formatting. Default is \code{"Relative"}.
  #' @param fontsize Numeric. Base font size passed to \code{fx.compact_dt()}.
  #' @param bgA Character. Background colour for scenario A container.
  #' @param bgB Character. Background colour for scenario B container.
  #'
  #' @details
  #' The function:
  #' \itemize{
  #'   \item formats numeric columns using fixed digits
  #'   \item applies special precision to one column (e.g., "Relative")
  #'   \item builds compact DT widgets using \code{fx.compact_dt()}
  #'   \item arranges them in a responsive two_column grid
  #' }
  #'
  #' @return An HTML widget (via \code{htmltools::browsable}) showing the two
  #'   formatted tables side by side.
  #'
  #'
  #' @export
  fx.compare.two.quantile.tables.sidebyside <- function(
    scenarioA,
    scenarioB,
    scenarios.df,
    results,
    special_col = "Relative",
    fontsize = 12,
    bgA = "#eef6ff",   # default light blue
    bgB = "#ffeff5"    # default light pink
  ){
    if (!requireNamespace("DT", quietly = TRUE)) {
      stop("Pakken 'DT' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }
    if (!requireNamespace("htmltools", quietly = TRUE)) {
      stop("Pakken 'htmltools' kreves for denne funksjonen. Vennligst installer den.", call. = FALSE)
    }

    # ---- Extract and format tables ----
    format.fixed <- function(df, digits = 2, special_col = NULL, special_digits = 3) {
      df[] <- lapply(names(df), function(col) {
        x <- df[[col]]
        if (is.numeric(x)) {
          d <- if (!is.null(special_col) && col == special_col) special_digits else digits
          sprintf(paste0("%.", d, "f"), x)
        } else x
      })
      df
    }

    tblA <- format.fixed(results[[scenarioA]]$table, special_col = special_col)
    tblB <- format.fixed(results[[scenarioB]]$table, special_col = special_col)

    # ---- Build DT widgets using your compact function ----
    dtA <- fx.compact_dt(
      tblA,
      caption = scenarioA,
      fontsize = fontsize
    )

    dtB <- fx.compact_dt(
      tblB,
      caption = scenarioB,
      fontsize = fontsize
    )

    # ---- Side-by-side layout with customizable background colours ----
    htmltools::browsable(
      htmltools::div(
        style = "
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
      ",
        htmltools::div(
          style = paste0("background-color:", bgA, "; padding:10px; border-radius:6px;"),
          dtA
        ),
        htmltools::div(
          style = paste0("background-color:", bgB, "; padding:10px; border-radius:6px;"),
          dtB
        )
      )
    )
  }
