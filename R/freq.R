#' Frequency Table
#'
#' Create a frequency table for a single variable with both total and valid percentages.
#'
#' @param data Data frame
#' @param var Variable name (unquoted)
#' @param wt Weight variable (default = 1)
#' @param prob If TRUE, treat wt as probability weight and use 1/wt (default = FALSE)
#' @param lang Language for output: "en" (default) or "ja"
#' @param quiet If TRUE, suppress summary output (default = FALSE)
#' @return Frequency table (tibble)
#' @export
#' @importFrom dplyr mutate count if_else
#'
#' @examples
#' # Sample data
#' df <- data.frame(
#'   gender = c("Male", "Female", "Male", NA, "Female", "Male", NA),
#'   age_group = c("20s", "30s", "20s", "40s", NA, "30s", "20s"),
#'   weight = c(1.2, 0.8, 1.0, 1.1, 0.9, 1.3, 0.7)
#' )
#'
#' # Frequency table (no weight)
#' freq(df, gender)
#'
#' # Frequency table (with weight)
#' freq(df, gender, wt = weight)
#'
#' # Frequency table (with probability weight)
#' freq(df, gender, wt = weight, prob = TRUE)
#'
#' # Japanese output
#' freq(df, gender, lang = "ja")
#'
freq <- function(data, var, wt = 1, prob = FALSE, lang = "en", quiet = FALSE) {
  var_name <- deparse(substitute(var))

  # Language settings
  labels <- if (lang == "ja") {
    list(
      var = "\u5909\u6570",
      total = "\u7dcf\u6570",
      valid = "\u6709\u52b9",
      missing = "\u6b20\u640d"
    )
  } else {
    list(
      var = "Variable",
      total = "Total",
      valid = "Valid",
      missing = "Missing"
    )
  }

  # Apply weight (evaluate prob outside mutate to avoid data masking)
  if (prob) {
    data <- data |> mutate(.wt = 1 / {{ wt }})
  } else {
    data <- data |> mutate(.wt = {{ wt }})
  }

  # Total counts (including NA)
  n_total <- sum(data$.wt, na.rm = TRUE)
  n_valid <- sum(data$.wt[!is.na(data[[var_name]])], na.rm = TRUE)
  n_missing <- n_total - n_valid

  # Create frequency table
  result <- data |>
    count({{ var }}, wt = .wt) |>
    mutate(
      percent = n / n_total * 100,
      valid_n = if_else(is.na({{ var }}), NA_real_, n),
      valid_percent = if_else(is.na({{ var }}), NA_real_, n / n_valid * 100)
    )

  # Display summary
  if (!quiet) {
    cat(labels$var, ": ", var_name, "\n", sep = "")
    cat(labels$total, ": ", round(n_total, 1),
        "  ", labels$valid, ": ", round(n_valid, 1),
        "  ", labels$missing, ": ", round(n_missing, 1),
        " (", round(n_missing / n_total * 100, 1), "%)\n\n", sep = "")
  }

  return(result)
}
