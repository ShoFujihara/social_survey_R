#' Get Variable and Value Labels Metadata
#'
#' Extract variable labels and value labels from a data frame.
#'
#' @param data Data frame (supports labelled data from haven)
#' @param lang Language for output: "en" (default) or "ja"
#' @return Data frame with variable metadata
#' @export
#'
#' @examples
#' # Sample data with labels
#' library(labelled)
#' df <- data.frame(
#'   gender = c(1, 2, 1, 2),
#'   age = c(25, 30, 35, 40)
#' )
#' var_label(df$gender) <- "Gender"
#' val_labels(df$gender) <- c("Male" = 1, "Female" = 2)
#' var_label(df$age) <- "Age in years"
#'
#' # Get metadata
#' metadata(df)
#'
metadata <- function(data, lang = "en") {

  # Check if labelled package is available
  if (!requireNamespace("labelled", quietly = TRUE)) {
    stop("Package 'labelled' is required. Install with: install.packages('labelled')")
  }

  # Get variable names
  vars <- names(data)

  # Get variable labels
  var_labels <- sapply(vars, function(v) {
    lbl <- labelled::var_label(data[[v]])
    if (is.null(lbl)) NA_character_ else lbl
  })

  # Get value labels as string
  val_labels <- sapply(vars, function(v) {
    lbl <- labelled::val_labels(data[[v]])
    if (is.null(lbl) || length(lbl) == 0) {
      NA_character_
    } else {
      paste(paste0(lbl, "=", names(lbl)), collapse = "; ")
    }
  })

  # Get variable type
  var_types <- sapply(vars, function(v) {
    class(data[[v]])[1]
  })

  # Count missing values
  n_total <- nrow(data)
  n_missing <- sapply(vars, function(v) sum(is.na(data[[v]])))
  missing_pct <- round(n_missing / n_total * 100, 1)

  # Create result data frame
  result <- data.frame(
    variable = vars,
    label = var_labels,
    type = var_types,
    n = n_total - n_missing,
    missing = n_missing,
    missing_pct = missing_pct,
    value_labels = val_labels,
    stringsAsFactors = FALSE,
    row.names = NULL
  )

  # Display summary
  labels <- if (lang == "ja") {
    list(title = "メタデータ", vars = "変数数", cases = "ケース数")
  } else {
    list(title = "Metadata", vars = "Variables", cases = "Cases")
  }

  cat(labels$title, "\n", sep = "")
  cat(labels$cases, ": ", n_total, "  ", labels$vars, ": ", length(vars), "\n\n", sep = "")

  return(result)
}


#' Set Variable Label
#'
#' @param data Data frame
#' @param var Variable name (unquoted)
#' @param label Label string
#' @return Data frame with label applied
#' @export
#'
#' @examples
#' df <- set_var_label(df, gender, "Gender")
#'
set_var_label <- function(data, var, label) {
  var_name <- deparse(substitute(var))
  labelled::var_label(data[[var_name]]) <- label
  return(data)
}


#' Set Value Labels
#'
#' @param data Data frame
#' @param var Variable name (unquoted)
#' @param ... Named values (e.g., Male = 1, Female = 2)
#' @return Data frame with value labels applied
#' @export
#'
#' @examples
#' df <- set_val_labels(df, gender, Male = 1, Female = 2)
#'
set_val_labels <- function(data, var, ...) {
  var_name <- deparse(substitute(var))
  labels <- c(...)
  labelled::val_labels(data[[var_name]]) <- labels
  return(data)
}


#' Apply Labels from a Definition Data Frame
#'
#' @param data Data frame to apply labels
#' @param label_def Data frame with columns: variable, label, value_labels
#' @return Data frame with labels applied
#' @export
#'
#' @examples
#' # Define labels in R
#' label_def <- data.frame(
#'   variable = c("gender", "age"),
#'   label = c("Gender", "Age in years"),
#'   value_labels = c("1=Male; 2=Female", NA)
#' )
#' df <- apply_labels(df, label_def)
#'
#' # From CSV (machine readable)
#' # labels.csv:
#' # variable,label,value_labels
#' # gender,Gender,"1=Male; 2=Female"
#' # age,Age in years,
#' #
#' # label_def <- read.csv("labels.csv")
#' # df <- apply_labels(df, label_def)
#'
apply_labels <- function(data, label_def) {

  for (i in seq_len(nrow(label_def))) {
    var_name <- label_def$variable[i]

    if (!(var_name %in% names(data))) next

    # Set variable label
    if (!is.na(label_def$label[i])) {
      labelled::var_label(data[[var_name]]) <- label_def$label[i]
    }

    # Set value labels
    if (!is.na(label_def$value_labels[i])) {
      # Parse "1=Male; 2=Female" format
      pairs <- strsplit(label_def$value_labels[i], ";\\s*")[[1]]
      labels <- numeric(length(pairs))
      names(labels) <- character(length(pairs))
      for (j in seq_along(pairs)) {
        parts <- strsplit(trimws(pairs[j]), "=", fixed = TRUE)[[1]]
        labels[j] <- as.numeric(parts[1])
        names(labels)[j] <- parts[2]
      }
      labelled::val_labels(data[[var_name]]) <- labels
    }
  }

  return(data)
}
