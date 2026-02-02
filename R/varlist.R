#' List Variables with Labels
#'
#' Extract variable names and labels from a data frame as a tibble.
#' Useful for quick reference of variable names and their descriptions.
#' By default, prints all rows (unlike standard tibble which shows 10 rows).
#'
#' @param data A data frame (typically with labelled variables)
#' @param value_labels If TRUE, include value labels column. Default is FALSE.
#' @param n Number of rows to print. Default is Inf (all rows).
#' @return A tibble with columns: variable, label (and optionally value_labels)
#' @export
#'
#' @examples
#' \dontrun{
#' ssm <- download_csrda("ssm")
#' varlist(ssm)
#'
#' # Include value labels
#' varlist(ssm, value_labels = TRUE)
#'
#' # Filter variables
#' varlist(ssm) |> dplyr::filter(grepl("問6", label))
#' }
#'
varlist <- function(data, value_labels = FALSE, n = Inf) {
  if (!is.data.frame(data)) {
    stop("data must be a data frame")
  }

  var_names <- names(data)

  labels <- vapply(data, function(x) {
    lbl <- attr(x, "label")
    if (is.null(lbl)) NA_character_ else as.character(lbl)
  }, character(1))

  result <- tibble::tibble(
    variable = var_names,
    label = labels
  )

  if (value_labels) {
    val_labels <- vapply(data, function(x) {
      val_lbl <- attr(x, "labels")
      if (is.null(val_lbl) || length(val_lbl) == 0) {
        return(NA_character_)
      }
      paste(val_lbl, names(val_lbl), sep = "=", collapse = "; ")
    }, character(1))
    result$value_labels <- val_labels
  }

  class(result) <- c("varlist", class(result))
  attr(result, "print_n") <- n
  result
}

#' @export
print.varlist <- function(x, ...) {
  n <- attr(x, "print_n")
  if (is.null(n)) n <- Inf
  print(tibble::as_tibble(x), n = n, ...)
  invisible(x)
}
