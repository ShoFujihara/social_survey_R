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
#' prank(x, w)
#'
#' # Without weights (equal weights)
#' prank(x)
#'
#' # With dplyr
#' # ssm |> mutate(pinc_prank = prank(pinc, weight))
#'
prank <- function(x, weights = NULL, na.rm = TRUE) {
  if (is.null(weights)) {
    weights <- rep(1, length(x))
  }

  if (length(x) != length(weights)) {
    stop("x and weights must have the same length")
  }

  n <- length(x)
  result <- rep(NA_real_, n)
  valid <- if (na.rm) !is.na(x) & !is.na(weights) else rep(TRUE, n)
  total_weight <- sum(weights[valid], na.rm = TRUE)

  if (total_weight == 0) {
    warning("Total weight is zero. Returning NA values.")
    return(result)
  }

  # Vectorized computation using sorted order
  x_valid <- x[valid]
  w_valid <- weights[valid]

  # Sort by x values

  ord <- order(x_valid)
  x_sorted <- x_valid[ord]
  w_sorted <- w_valid[ord]

  # Cumulative sum of weights (excluding current value)
  cumw <- cumsum(w_sorted)
  cumw_before <- c(0, cumw[-length(cumw)])

  # Handle ties: all tied values get the same rank (weight sum before first occurrence)
  # Use match to find first occurrence of each value
  unique_x <- unique(x_sorted)
  first_idx <- match(x_sorted, unique_x)
  cumw_first <- cumw_before[match(unique_x, x_sorted)]
  cumw_adjusted <- cumw_first[first_idx]

  # Compute percent rank
  prank_sorted <- cumw_adjusted / total_weight

  # Map back to original order
  prank_valid <- numeric(length(x_valid))
  prank_valid[ord] <- prank_sorted

  result[valid] <- prank_valid
  return(result)
}
