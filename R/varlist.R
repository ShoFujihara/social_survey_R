#' List Variables with Labels
#'
#' Extract variable names and labels from a data frame as a tibble.
#' Useful for quick reference of variable names and their descriptions.
#' By default, prints all rows (unlike standard tibble which shows 10 rows).
#'
#' @param data A data frame (typically with labelled variables)
#' @param n Number of rows to print. Default is Inf (all rows).
#' @return A tibble with columns: variable, label (class "varlist")
#' @export
#'
#' @examples
#' \dontrun{
#' ssm <- download_csrda("ssm")
#' varlist(ssm)
#'
#' # Filter variables
#' varlist(ssm) |> dplyr::filter(grepl("問6", label))
#' }
#'
varlist <- function(data, n = Inf) {
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
