#' Get Variable and Value Labels Metadata
#'
#' Extract variable labels and value labels from a data frame.
#'
#' @param data Data frame (supports labelled data from haven)
#' @param lang Language for output: "en" (default) or "ja"
#' @param quiet If TRUE, suppress summary output (default = FALSE)
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
metadata <- function(data, lang = "en", quiet = FALSE) {

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
  if (!quiet) {
    labels <- if (lang == "ja") {
      list(title = "\u30e1\u30bf\u30c7\u30fc\u30bf", vars = "\u5909\u6570\u6570", cases = "\u30b1\u30fc\u30b9\u6570")
    } else {
      list(title = "Metadata", vars = "Variables", cases = "Cases")
    }

    cat(labels$title, "\n", sep = "")
    cat(labels$cases, ": ", n_total, "  ", labels$vars, ": ", length(vars), "\n\n", sep = "")
  }

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
#' df <- data.frame(gender = c(1, 2, 1), age = c(25, 30, 35))
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
#' @param ... Value-label pairs (e.g., `1` = "Male", `2` = "Female")
#' @return Data frame with value labels applied
#' @export
#'
#' @examples
#' df <- data.frame(gender = c(1, 2, 1), age = c(25, 30, 35))
#' df <- set_val_labels(df, gender, `1` = "Male", `2` = "Female")
#'
set_val_labels <- function(data, var, ...) {
  var_name <- deparse(substitute(var))
  args <- list(...)
  # Convert: `1` = "Male" -> c(Male = 1)
  labels <- as.numeric(names(args))
  names(labels) <- as.character(args)
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
        pair <- trimws(pairs[j])
        # Split only on first "=" to allow "=" in labels
        eq_pos <- regexpr("=", pair, fixed = TRUE)
        if (eq_pos > 0) {
          labels[j] <- as.numeric(substr(pair, 1, eq_pos - 1))
          names(labels)[j] <- substr(pair, eq_pos + 1, nchar(pair))
        }
      }
      labelled::val_labels(data[[var_name]]) <- labels
    }
  }

  return(data)
}


#' Export Labels to CSV Format
#'
#' Export variable labels and value labels from a data frame to a CSV-compatible
#' data frame that can be used with apply_labels().
#'
#' @param data Data frame with labelled variables
#' @param file Optional file path to save CSV. If NULL, returns data frame only.
#' @return Data frame with columns: variable, label, value_labels
#' @export
#'
#' @examples
#' library(labelled)
#' df <- data.frame(
#'   gender = c(1, 2, 1, 2),
#'   age = c(25, 30, 35, 40)
#' )
#' var_label(df$gender) <- "Gender"
#' val_labels(df$gender) <- c("Male" = 1, "Female" = 2)
#' var_label(df$age) <- "Age in years"
#'
#' # Get as data frame
#' label_def <- export_labels(df)
#'
#' # Save to CSV
#' export_labels(df, "labels.csv")
#'
export_labels <- function(data, file = NULL) {

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

  # Get value labels as string (format: "1=Male; 2=Female")
  val_labels <- sapply(vars, function(v) {
    lbl <- labelled::val_labels(data[[v]])
    if (is.null(lbl) || length(lbl) == 0) {
      NA_character_
    } else {
      paste(paste0(lbl, "=", names(lbl)), collapse = "; ")
    }
  })

  # Create result data frame
  result <- data.frame(
    variable = vars,
    label = var_labels,
    value_labels = val_labels,
    stringsAsFactors = FALSE,
    row.names = NULL
  )

  # Save to file if specified (with UTF-8 BOM for Excel compatibility)
  if (!is.null(file)) {
    con <- file(file, open = "w", encoding = "UTF-8")
    on.exit(close(con))
    writeLines("\ufeff", con, sep = "")
    utils::write.csv(result, con, row.names = FALSE, na = "")
    message("Labels exported to: ", file)
  }

  return(result)
}


#' Apply Labels from JSON File
#'
#' Apply variable labels and value labels from a JSON file.
#' JSON format allows special characters (`;`, `=`, `"`) in labels.
#'
#' @param data Data frame to apply labels
#' @param file Path to JSON file
#' @return Data frame with labels applied
#' @export
#'
#' @examples
#' # JSON format:
#' # [
#' #   {"variable": "gender", "label": "Gender",
#' #    "value_labels": {"1": "Male", "2": "Female"}},
#' #   {"variable": "age", "label": "Age in years"}
#' # ]
#' #
#' # df <- apply_labels_json(df, "labels.json")
#'
apply_labels_json <- function(data, file) {

  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("Package 'jsonlite' is required. Install with: install.packages('jsonlite')")
  }

  label_list <- jsonlite::fromJSON(file, simplifyDataFrame = FALSE)

  for (item in label_list) {
    var_name <- item$variable

    if (!(var_name %in% names(data))) next

    # Set variable label
    if (!is.null(item$label)) {
      labelled::var_label(data[[var_name]]) <- item$label
    }

    # Set value labels
    val_lbl <- item$value_labels
    if (!is.null(val_lbl) && length(val_lbl) > 0) {
      labels <- as.numeric(names(val_lbl))
      names(labels) <- as.character(val_lbl)
      labelled::val_labels(data[[var_name]]) <- labels
    }
  }

  return(data)
}


#' Parse SPSS Label Syntax
#'
#' Parse SPSS VARIABLE LABELS and VALUE LABELS syntax into a data frame
#' compatible with \code{\link{apply_labels}}.
#'
#' @param syntax Character string containing SPSS syntax. If NULL, \code{file} must be specified.
#' @param file Path to an SPSS syntax file (.sps). If NULL, \code{syntax} must be specified.
#' @return Data frame with columns: variable, label, value_labels
#' @export
#'
#' @examples
#' spss_syntax <- '
#' VARIABLE LABELS
#'   gender "Gender"
#'   age "Age in years".
#' VALUE LABELS
#'   gender
#'     1 "Male"
#'     2 "Female".
#' '
#' label_def <- parse_spss_labels(spss_syntax)
#'
parse_spss_labels <- function(syntax = NULL, file = NULL) {

  if (!is.null(file)) {
    syntax <- paste(readLines(file, encoding = "UTF-8", warn = FALSE), collapse = "\n")
  }

  if (is.null(syntax) || !nzchar(trimws(syntax))) {
    stop("Either 'syntax' or 'file' must be provided")
  }

  # Remove SPSS comment lines (lines starting with *)
  lines <- strsplit(syntax, "\n")[[1]]
  lines <- lines[!grepl("^\\s*\\*", lines)]
  syntax <- paste(lines, collapse = "\n")

  var_labels_list <- list()
  val_labels_list <- list()

  # --- Parse VARIABLE LABELS blocks ---
  var_pattern <- "(?si)VARIABLE\\s+LABELS\\b\\s*(.*?)\\."
  var_matches <- gregexpr(var_pattern, syntax, perl = TRUE)
  var_blocks <- regmatches(syntax, var_matches)[[1]]

  for (block in var_blocks) {
    # Remove command name
    body <- sub("(?i)VARIABLE\\s+LABELS\\s*", "", block, perl = TRUE)
    body <- sub("\\.$", "", body)

    # Match: varname "label" or varname 'label'
    pair_pattern <- '(\\w+)\\s+["\']([^"\']*)["\']'
    m <- gregexpr(pair_pattern, body, perl = TRUE)
    pairs <- regmatches(body, m)[[1]]

    for (p in pairs) {
      parts <- regmatches(p, regexec(pair_pattern, p, perl = TRUE))[[1]]
      if (length(parts) >= 3) {
        var_labels_list[[parts[2]]] <- parts[3]
      }
    }
  }

  # --- Parse VALUE LABELS blocks ---
  val_pattern <- "(?si)VALUE\\s+LABELS\\b\\s*(.*?)\\."
  val_matches <- gregexpr(val_pattern, syntax, perl = TRUE)
  val_blocks <- regmatches(syntax, val_matches)[[1]]

  for (block in val_blocks) {
    body <- sub("(?i)VALUE\\s+LABELS\\s*", "", block, perl = TRUE)
    body <- sub("\\.$", "", body)

    # Split by / to get per-variable sections
    # Prepend / for uniform splitting
    sections <- strsplit(paste0("/", trimws(body)), "\\s*/\\s*")[[1]]
    sections <- sections[nzchar(trimws(sections))]

    for (section in sections) {
      section <- trimws(section)

      # First token is the variable name
      var_match <- regmatches(section, regexec("^(\\w+)\\s*", section, perl = TRUE))[[1]]
      if (length(var_match) < 2) next
      varname <- var_match[2]
      rest <- sub("^\\w+\\s*", "", section, perl = TRUE)

      # Match value "label" pairs (numeric values, possibly negative/decimal)
      vl_pattern <- '(-?\\d+\\.?\\d*)\\s+["\']([^"\']*)["\']'
      vl_matches <- gregexpr(vl_pattern, rest, perl = TRUE)
      vl_pairs <- regmatches(rest, vl_matches)[[1]]

      if (length(vl_pairs) > 0) {
        label_parts <- character(length(vl_pairs))
        for (k in seq_along(vl_pairs)) {
          pp <- regmatches(vl_pairs[k], regexec(vl_pattern, vl_pairs[k], perl = TRUE))[[1]]
          if (length(pp) >= 3) {
            label_parts[k] <- paste0(pp[2], "=", pp[3])
          }
        }
        val_labels_list[[varname]] <- paste(label_parts, collapse = "; ")
      }
    }
  }

  # Combine into apply_labels-compatible data frame
  all_vars <- unique(c(names(var_labels_list), names(val_labels_list)))

  if (length(all_vars) == 0) {
    message("No labels found in syntax")
    return(data.frame(variable = character(0), label = character(0),
                      value_labels = character(0), stringsAsFactors = FALSE))
  }

  result <- data.frame(
    variable = all_vars,
    label = sapply(all_vars, function(v) {
      if (v %in% names(var_labels_list)) var_labels_list[[v]] else NA_character_
    }),
    value_labels = sapply(all_vars, function(v) {
      if (v %in% names(val_labels_list)) val_labels_list[[v]] else NA_character_
    }),
    stringsAsFactors = FALSE,
    row.names = NULL
  )

  return(result)
}


#' Apply SPSS Label Syntax to Data Frame
#'
#' Parse SPSS VARIABLE LABELS and VALUE LABELS syntax and apply them to a data frame.
#' Combines \code{\link{parse_spss_labels}} and \code{\link{apply_labels}}.
#'
#' @param data Data frame to apply labels
#' @param syntax Character string containing SPSS syntax. If NULL, \code{file} must be specified.
#' @param file Path to an SPSS syntax file (.sps). If NULL, \code{syntax} must be specified.
#' @return Data frame with labels applied
#' @export
#'
#' @examples
#' spss_syntax <- '
#' VARIABLE LABELS
#'   gender "Gender"
#'   age "Age in years".
#' VALUE LABELS
#'   gender
#'     1 "Male"
#'     2 "Female".
#' '
#' df <- apply_spss_labels(df, spss_syntax)
#'
#' # From .sps file
#' # df <- apply_spss_labels(df, file = "labels.sps")
#'
apply_spss_labels <- function(data, syntax = NULL, file = NULL) {
  label_def <- parse_spss_labels(syntax = syntax, file = file)
  apply_labels(data, label_def)
}


#' Normalize Labels (Full-width to Half-width Conversion)
#'
#' Convert full-width characters to half-width in variable and value labels.
#' Useful for Japanese data where numbers and symbols may be in full-width format.
#'
#' @param data Data frame with labelled variables
#' @param convert_numbers Convert full-width numbers to half-width (0-9). Default TRUE.
#' @param convert_symbols Convert full-width symbols (=, ;, etc.) to half-width. Default TRUE.
#' @param convert_alpha Convert full-width alphabet (A-Z, a-z) to half-width. Default TRUE.
#' @param convert_space Convert full-width space to half-width. Default TRUE.
#' @param space_before_paren Add space before half-width opening parenthesis when converting
#'   from full-width. Default TRUE.
#' @param space_after_paren Add space after half-width closing parenthesis when converting
#'   from full-width. Default TRUE.
#' @param space_after_colon Add space after half-width colon when converting
#'   from full-width. Default TRUE.
#' @param space_after_period Add space after half-width period when converting
#'   from full-width. Default TRUE.
#' @return Data frame with normalized labels
#' @export
#'
#' @examples
#' # Normalize full-width numbers, symbols, and alphabet in labels
#' df <- normalize_labels(df)
#'
#' # Skip alphabet conversion
#' df <- normalize_labels(df, convert_alpha = FALSE)
#'
#' # No space adjustments
#' df <- normalize_labels(df, space_before_paren = FALSE, space_after_paren = FALSE,
#'                        space_after_colon = FALSE, space_after_period = FALSE)
#'
normalize_labels <- function(data, convert_numbers = TRUE, convert_symbols = TRUE,
                             convert_alpha = TRUE, convert_space = TRUE,
                             space_before_paren = TRUE, space_after_paren = TRUE,
                             space_after_colon = TRUE, space_after_period = TRUE) {

  if (!requireNamespace("labelled", quietly = TRUE)) {
    stop("Package 'labelled' is required. Install with: install.packages('labelled')")
  }

  # Define conversion mappings
  fw_numbers <- c("\uFF10", "\uFF11", "\uFF12", "\uFF13", "\uFF14",
                  "\uFF15", "\uFF16", "\uFF17", "\uFF18", "\uFF19")
  hw_numbers <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")

  fw_symbols <- c("\uFF1D", "\uFF1B", "\uFF0C", "\uFF0E", "\uFF1A",
                  "\uFF08", "\uFF09", "\uFF3B", "\uFF3D", "\uFF5B", "\uFF5D",
                  "\uFF0F", "\uFF3C", "\uFF0B", "\uFF0D", "\uFF0A", "\uFF05",
                  "\uFF06", "\uFF01", "\uFF1F", "\uFF20", "\uFF03", "\uFF04",
                  "\uFF3E", "\uFF5C", "\uFF1C", "\uFF1E", "\uFF5E", "\uFF3F",
                  "\u2018", "\u2019", "\u201C", "\u201D")
  hw_symbols <- c("=", ";", ",", ".", ":",
                  "(", ")", "[", "]", "{", "}",
                  "/", "\\", "+", "-", "*", "%",
                  "&", "!", "?", "@", "#", "$",
                  "^", "|", "<", ">", "~", "_",
                  "'", "'", "\"", "\"")

  fw_alpha_upper <- c("\uFF21", "\uFF22", "\uFF23", "\uFF24", "\uFF25",
                      "\uFF26", "\uFF27", "\uFF28", "\uFF29", "\uFF2A",
                      "\uFF2B", "\uFF2C", "\uFF2D", "\uFF2E", "\uFF2F",
                      "\uFF30", "\uFF31", "\uFF32", "\uFF33", "\uFF34",
                      "\uFF35", "\uFF36", "\uFF37", "\uFF38", "\uFF39", "\uFF3A")
  hw_alpha_upper <- LETTERS

  fw_alpha_lower <- c("\uFF41", "\uFF42", "\uFF43", "\uFF44", "\uFF45",
                      "\uFF46", "\uFF47", "\uFF48", "\uFF49", "\uFF4A",
                      "\uFF4B", "\uFF4C", "\uFF4D", "\uFF4E", "\uFF4F",
                      "\uFF50", "\uFF51", "\uFF52", "\uFF53", "\uFF54",
                      "\uFF55", "\uFF56", "\uFF57", "\uFF58", "\uFF59", "\uFF5A")
  hw_alpha_lower <- letters

  # Helper function to replace characters
  normalize_string <- function(s) {
    if (is.null(s) || is.na(s)) return(s)

    if (convert_numbers) {
      for (i in seq_along(fw_numbers)) {
        s <- gsub(fw_numbers[i], hw_numbers[i], s, fixed = TRUE)
      }
    }

    if (convert_symbols) {
      for (i in seq_along(fw_symbols)) {
        # Special handling for opening parenthesis with space before
        if (space_before_paren && fw_symbols[i] == "\uFF08") {
          # Add space before ( but avoid double spaces
          s <- gsub("([^ ])\uFF08", "\\1 (", s, perl = TRUE)
          s <- gsub("^\uFF08", "(", s, perl = TRUE)  # Start of string
          s <- gsub(" \uFF08", " (", s, fixed = TRUE)  # Already has space
        # Special handling for closing parenthesis with space after
        } else if (space_after_paren && fw_symbols[i] == "\uFF09") {
          # Add space after ) but avoid double spaces
          s <- gsub("\uFF09([^ ])", ") \\1", s, perl = TRUE)
          s <- gsub("\uFF09$", ")", s, perl = TRUE)  # End of string
          s <- gsub("\uFF09 ", ") ", s, fixed = TRUE)  # Already has space
        # Special handling for colon with space after
        } else if (space_after_colon && fw_symbols[i] == "\uFF1A") {
          # Add space after : but avoid double spaces
          s <- gsub("\uFF1A([^ ])", ": \\1", s, perl = TRUE)
          s <- gsub("\uFF1A$", ":", s, perl = TRUE)  # End of string
          s <- gsub("\uFF1A ", ": ", s, fixed = TRUE)  # Already has space
        # Special handling for period with space after
        } else if (space_after_period && fw_symbols[i] == "\uFF0E") {
          # Add space after . but avoid double spaces
          s <- gsub("\uFF0E([^ ])", ". \\1", s, perl = TRUE)
          s <- gsub("\uFF0E$", ".", s, perl = TRUE)  # End of string
          s <- gsub("\uFF0E ", ". ", s, fixed = TRUE)  # Already has space
        } else {
          s <- gsub(fw_symbols[i], hw_symbols[i], s, fixed = TRUE)
        }
      }
    }

    if (convert_alpha) {
      for (i in seq_along(fw_alpha_upper)) {
        s <- gsub(fw_alpha_upper[i], hw_alpha_upper[i], s, fixed = TRUE)
      }
      for (i in seq_along(fw_alpha_lower)) {
        s <- gsub(fw_alpha_lower[i], hw_alpha_lower[i], s, fixed = TRUE)
      }
    }

    if (convert_space) {
      s <- gsub("\u3000", " ", s, fixed = TRUE)  # Full-width space
    }

    return(s)
  }

  # Process each variable
  for (v in names(data)) {
    # Normalize variable label
    var_lbl <- labelled::var_label(data[[v]])
    if (!is.null(var_lbl)) {
      labelled::var_label(data[[v]]) <- normalize_string(var_lbl)
    }

    # Normalize value labels
    val_lbls <- labelled::val_labels(data[[v]])
    if (!is.null(val_lbls) && length(val_lbls) > 0) {
      new_names <- sapply(names(val_lbls), normalize_string)
      names(val_lbls) <- new_names
      labelled::val_labels(data[[v]]) <- val_lbls
    }
  }

  return(data)
}


#' Validate Labels for Prohibited Characters
#'
#' Check variable and value labels for prohibited or problematic characters.
#' Returns a report of any issues found.
#'
#' @param data Data frame with labelled variables
#' @param check_newlines Check for newline characters (\\n, \\r). Default TRUE.
#' @param check_tabs Check for tab characters (\\t). Default TRUE.
#' @param check_control Check for other control characters. Default TRUE.
#' @param check_csv_special Check for CSV special characters (`;` in value labels). Default TRUE.
#' @param lang Language for output: "en" (default) or "ja"
#' @return Data frame with validation issues (invisible if no issues)
#' @export
#'
#' @examples
#' # Check for problematic characters
#' issues <- validate_labels(df)
#'
#' # Japanese output
#' issues <- validate_labels(df, lang = "ja")
#'
validate_labels <- function(data, check_newlines = TRUE, check_tabs = TRUE,
                            check_control = TRUE, check_csv_special = TRUE,
                            lang = "en") {

  if (!requireNamespace("labelled", quietly = TRUE)) {
    stop("Package 'labelled' is required. Install with: install.packages('labelled')")
  }

  issues <- data.frame(
    variable = character(),
    label_type = character(),
    value = character(),
    issue = character(),
    stringsAsFactors = FALSE
  )

  # Helper to check a string for issues
  # internal_type is always "variable_label" or "value_label" for logic
  # display_type is the localized version for output
  check_string <- function(s, var_name, internal_type, display_type, value = NA) {
    if (is.null(s) || is.na(s)) return(NULL)

    found <- character()

    if (check_newlines && grepl("[\n\r]", s)) {
      found <- c(found, if (lang == "ja") "\u6539\u884c\u6587\u5b57" else "newline character")
    }

    if (check_tabs && grepl("\t", s)) {
      found <- c(found, if (lang == "ja") "\u30bf\u30d6\u6587\u5b57" else "tab character")
    }

    if (check_control) {
      # Check for control characters (excluding \n, \r, \t which are checked separately)
      ctrl_pattern <- "[\\x01-\\x08\\x0B\\x0C\\x0E-\\x1F]"
      if (grepl(ctrl_pattern, s, perl = TRUE)) {
        found <- c(found, if (lang == "ja") "\u5236\u5fa1\u6587\u5b57" else "control character")
      }
    }

    if (check_csv_special && internal_type == "value_label" && grepl(";", s, fixed = TRUE)) {
      found <- c(found, if (lang == "ja") "\u30bb\u30df\u30b3\u30ed\u30f3(CSV\u975e\u4e92\u63db)" else "semicolon (CSV incompatible)")
    }

    if (length(found) > 0) {
      return(data.frame(
        variable = var_name,
        label_type = display_type,
        value = if (is.na(value)) "" else as.character(value),
        issue = paste(found, collapse = ", "),
        stringsAsFactors = FALSE
      ))
    }
    return(NULL)
  }

  # Check each variable
  for (v in names(data)) {
    # Check variable label
    var_lbl <- labelled::var_label(data[[v]])
    if (!is.null(var_lbl)) {
      display_type <- if (lang == "ja") "\u5909\u6570\u30e9\u30d9\u30eb" else "variable_label"
      result <- check_string(var_lbl, v, "variable_label", display_type)
      if (!is.null(result)) {
        issues <- rbind(issues, result)
      }
    }

    # Check value labels
    val_lbls <- labelled::val_labels(data[[v]])
    if (!is.null(val_lbls) && length(val_lbls) > 0) {
      display_type <- if (lang == "ja") "\u5024\u30e9\u30d9\u30eb" else "value_label"
      for (i in seq_along(val_lbls)) {
        lbl_name <- names(val_lbls)[i]
        lbl_value <- val_lbls[i]
        result <- check_string(lbl_name, v, "value_label", display_type, lbl_value)
        if (!is.null(result)) {
          issues <- rbind(issues, result)
        }
      }
    }
  }

  # Report results
  if (nrow(issues) == 0) {
    msg <- if (lang == "ja") "\u554f\u984c\u306f\u898b\u3064\u304b\u308a\u307e\u305b\u3093\u3067\u3057\u305f" else "No issues found"
    message(msg)
    return(invisible(issues))
  } else {
    msg <- if (lang == "ja") {
      paste0(nrow(issues), " \u4ef6\u306e\u554f\u984c\u304c\u898b\u3064\u304b\u308a\u307e\u3057\u305f")
    } else {
      paste0(nrow(issues), " issue(s) found")
    }
    message(msg)
    return(issues)
  }
}


#' Export Labels to JSON Format
#'
#' Export variable labels and value labels to a JSON file.
#' JSON format allows special characters (`;`, `=`, `"`) in labels.
#'
#' @param data Data frame with labelled variables
#' @param file Optional file path to save JSON. If NULL, returns list only.
#' @param pretty If TRUE, format JSON with indentation (default TRUE)
#' @return List with label definitions (invisibly if file is specified)
#' @export
#'
#' @examples
#' # Export to JSON
#' export_labels_json(df, "labels.json")
#'
#' # Get as list
#' label_list <- export_labels_json(df)
#'
export_labels_json <- function(data, file = NULL, pretty = TRUE) {

  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("Package 'jsonlite' is required. Install with: install.packages('jsonlite')")
  }

  vars <- names(data)

  result <- lapply(vars, function(v) {
    var_label <- labelled::var_label(data[[v]])
    val_labels <- labelled::val_labels(data[[v]])

    item <- list(variable = v)

    if (!is.null(var_label)) {
      item$label <- var_label
    }

    if (!is.null(val_labels) && length(val_labels) > 0) {
      # Convert c(Male = 1, Female = 2) to list("1" = "Male", "2" = "Female")
      vl <- as.list(names(val_labels))
      names(vl) <- as.character(val_labels)
      item$value_labels <- vl
    }

    item
  })

  if (!is.null(file)) {
    jsonlite::write_json(result, file, pretty = pretty, auto_unbox = TRUE)
    message("Labels exported to: ", file)
    return(invisible(result))
  }

  return(result)
}
