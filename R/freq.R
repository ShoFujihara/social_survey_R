#' Frequency Table
#'
#' Create a frequency table for a single variable with both total and valid percentages.
#'
#' @param data Data frame
#' @param var Variable name (unquoted)
#' @param wt Weight variable (default = 1)
#' @param lang Language for output: "en" (default) or "ja"
#' @return Frequency table (tibble)
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
#' # Japanese output
#' freq(df, gender, lang = "ja")
#'
freq <- function(data, var, wt = 1, lang = "en") {
  var_name <- deparse(substitute(var))

  # Language settings
  labels <- if (lang == "ja") {
    list(
      var = "変数",
      total = "総数",
      valid = "有効",
      missing = "欠損"
    )
  } else {
    list(
      var = "Variable",
      total = "Total",
      valid = "Valid",
      missing = "Missing"
    )
  }

  # Apply weight

data <- data |>
    mutate(.wt = {{ wt }})

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
  cat(labels$var, ": ", var_name, "\n", sep = "")
  cat(labels$total, ": ", round(n_total, 1),
      "  ", labels$valid, ": ", round(n_valid, 1),
      "  ", labels$missing, ": ", round(n_missing, 1),
      " (", round(n_missing / n_total * 100, 1), "%)\n\n", sep = "")

  return(result)
}
