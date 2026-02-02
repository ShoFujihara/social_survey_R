#' Weighted Percent Rank
#'
#' Calculate percent rank with survey weights.
#' Returns the weighted proportion of observations with values less than each value.
#'
#' @param x Numeric vector
#' @param weights Numeric vector of weights (same length as x). If NULL, equal weights are used.
#' @param na.rm Remove NA values (default TRUE)
#' @return Numeric vector with values between 0 and 1
#' @export
#'
#' @examples
#' x <- c(10, 20, 20, 30, 40)
#' w <- c(1, 2, 1, 3, 1)
#'
#' # Weighted percent rank
#' wtd_percent_rank(x, w)
#'
#' # Without weights (equal weights)
#' wtd_percent_rank(x)
#'
#' # With dplyr
#' # df |> mutate(income_prank = wtd_percent_rank(income, weight))
#'
wtd_percent_rank <- function(x, weights = NULL, na.rm = TRUE) {
  if (is.null(weights)) {
    weights <- rep(1, length(x))
  }

  if (length(x) != length(weights)) {
    stop("x and weights must have the same length")
  }

  n <- length(x)
  result <- rep(NA_real_, n)
  valid <- if (na.rm) !is.na(x) else rep(TRUE, n)
  total_weight <- sum(weights[valid], na.rm = TRUE)

  if (total_weight == 0) {
    warning("Total weight is zero. Returning NA values.")
    return(result)
  }

  for (i in which(valid)) {
    # Sum of weights for values smaller than current value
    smaller <- sum(weights[valid & x < x[i]], na.rm = TRUE)
    result[i] <- smaller / total_weight
  }

  return(result)
}
