# make sure %>% is available from dplyr
#' @importFrom dplyr %>%
#' @importFrom methods show
#' @importFrom utils install.packages installed.packages
NULL

#' Global variable declarations
#'
#' Declares data-frame and spatial-object column names used through
#' non-standard evaluation in dplyr, ggplot2, plotly, leaflet, and
#' related functions.
#'
#' These declarations prevent false-positive NOTES from:
#' R CMD check
#'
#' @keywords internal
#' @noRd
NULL
utils::globalVariables(c(
  "value",
  "year",
  ".data"
))
#Note: You do not need to @export or document this file.
#It just tells the package compiler to expect these names.
