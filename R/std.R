#' Standardize a Variable
#'
#' Standardize a numeric variable to have a specified mean and standard deviation.
#' By default, creates z-scores (mean = 0, sd = 1).
#'
#' @param x Numeric vector to standardize
#' @param mean Target mean (default = 0)
#' @param sd Target standard deviation (default = 1)
#' @param na.rm Remove NA values when calculating mean and sd (default = TRUE)
#' @return Standardized numeric vector
#' @export
#'
#' @examples
#' # Z-scores (mean = 0, sd = 1)
#' x <- c(10, 20, 30, 40, 50)
#' std(x)
#'
#' # Standardize to mean = 50, sd = 10 (T-scores)
#' std(x, mean = 50, sd = 10)
#'
#' # With NA values
#' x <- c(10, 20, NA, 40, 50)
#' std(x)  # NA is preserved in output
#'
#' # Use with dplyr
#' # df |> mutate(income_z = std(income))
#'
std <- function(x, mean = 0, sd = 1, na.rm = TRUE) {
  if (!is.numeric(x)) {
    stop("x must be numeric")
  }

  # Calculate original mean and sd
  x_mean <- base::mean(x, na.rm = na.rm)
  x_sd <- stats::sd(x, na.rm = na.rm)

  # Handle zero variance

  if (is.na(x_sd) || x_sd == 0) {
    warning("Standard deviation is zero or NA. Returning NA values.")
    return(rep(NA_real_, length(x)))
  }

  # Standardize: z-score then rescale
  z <- (x - x_mean) / x_sd
  result <- z * sd + mean

  return(result)
}
