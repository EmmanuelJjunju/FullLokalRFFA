#Dette oppretter en tests/ mappe med nødvendige oppsettsfiler.
#usethis::use_testthat()
#
#Dette vil opprette en fil (f.eks. tests/testthat/test-funksjoner.R) der du kan begynne å skrive testene dine.
#usethis::use_test("tests")#created this file without these comments ofcourse
#  add code to text under test_that("dscription",{code})


test_that("fx.load_packages works", {
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

})
