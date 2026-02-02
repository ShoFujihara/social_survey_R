#' Format Numbers with Fixed Decimal Places
#'
#' Format numeric values with a fixed number of decimal places,
#' preserving trailing zeros for consistent display in tables and figures.
#'
#' @param x Numeric vector to format
#' @param digits Number of decimal places (default = 2)
#' @param trim Remove leading whitespace (default = TRUE)
#' @return Character vector of formatted numbers
#' @export
#'
#' @examples
#' # Basic usage
#' fmt(1.5)       # "1.50"
#' fmt(1.5, 3)    # "1.500"
#' fmt(0.1, 2)    # "0.10"
#'
#' # Vector input
#' fmt(c(1, 1.5, 1.55, 1.555))  # "1.00" "1.50" "1.55" "1.56"
#'
#' # With dplyr
#' # df |> mutate(mean_fmt = fmt(mean_val))
#'
fmt <- function(x, digits = 2, trim = TRUE) {
  result <- format(round(x, digits), nsmall = digits)
  if (trim) {
    result <- trimws(result)
  }
  return(result)
}
