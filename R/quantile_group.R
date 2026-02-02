#' Divide Values into Quantile Groups
#'
#' Divide a numeric vector into n groups based on quantile values.
#' More precise than dplyr::ntile() which uses ranks.
#'
#' @param x Numeric vector
#' @param n Number of groups (default = 4 for quartiles)
#' @param na.rm Remove NA values when calculating quantiles (default = TRUE)
#' @return Integer vector with group assignments (1 to n)
#' @export
#'
#' @examples
#' x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
#'
#' # Quartiles (4 groups)
#' quantile_group(x)       # 1 1 1 2 2 3 3 4 4 4
#'
#' # Tertiles (3 groups)
#' quantile_group(x, 3)    # 1 1 1 1 2 2 2 3 3 3
#'
#' # Deciles (10 groups)
#' quantile_group(x, 10)
#'
#' # With NA values
#' x <- c(1, 2, NA, 4, 5)
#' quantile_group(x)       # 1 1 NA 3 4
#'
#' # With dplyr
#' # df |> mutate(income_q = quantile_group(income, 4))
#'
quantile_group <- function(x, n = 4, na.rm = TRUE) {
  if (!is.numeric(x)) {
    stop("x must be numeric")
  }

  if (n < 2) {
    stop("n must be at least 2")
  }

  # Calculate quantile breaks
  probs <- seq(0, 1, length.out = n + 1)
  breaks <- stats::quantile(x, probs = probs, na.rm = na.rm)

  # Handle case where all values are the same

  if (length(unique(breaks)) == 1) {
    warning("All values are identical. Returning 1 for all non-NA values.")
    result <- rep(1L, length(x))
    result[is.na(x)] <- NA_integer_
    return(result)
  }

  # Make breaks unique to avoid cut() errors with duplicate breaks
  # This can happen when there are many tied values
  if (anyDuplicated(breaks)) {
    breaks <- unique(breaks)
    n_actual <- length(breaks) - 1
    if (n_actual < n) {
      warning(sprintf("Only %d unique groups possible due to tied values.", n_actual))
    }
  }

  # Use cut() with include.lowest = TRUE to include minimum value
  result <- cut(x, breaks = breaks, labels = FALSE, include.lowest = TRUE)

  return(as.integer(result))
}
