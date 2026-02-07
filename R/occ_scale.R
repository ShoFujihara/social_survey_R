#' Assign Occupational Scales (SEI/SSI)
#'
#' Look up Socio-Economic Index (SEI) and Social Status Index (SSI) values
#' for occupation codes and add them as new columns to the data frame.
#'
#' @param data Data frame
#' @param code Variable name containing occupation codes (unquoted)
#' @param type Scale type: "ssm" for SSM occupation codes (default),
#'   "jess" for JESS 232 occupation codes
#' @param quiet If TRUE, suppress messages about unmatched codes (default = FALSE)
#' @return Data frame with `.sei` and `.ssi` columns added.
#'   Unmatched codes will have `NA` for both columns.
#' @export
#'
#' @source
#' Data from OccupationalScales v1.0:
#' \url{https://github.com/ShoFujihara/OccupationalScales}
#'
#' @examples
#' df <- data.frame(occ = c(501, 502, 999))
#' occ_scale(df, occ, type = "ssm")
#'
#' # With dplyr pipe
#' # data |> occ_scale(occupation, type = "ssm")
#'
occ_scale <- function(data, code, type = c("ssm", "jess"), quiet = FALSE) {
  type <- match.arg(type)
  code_name <- deparse(substitute(code))

  if (!code_name %in% names(data)) {
    stop("Column '", code_name, "' not found in data")
  }

  scale_data <- .load_occ_scale(type)
  code_col <- if (type == "ssm") "ssm" else "occ"

  code_values <- data[[code_name]]
  idx <- match(code_values, scale_data[[code_col]])

  data$.sei <- scale_data$sei[idx]
  data$.ssi <- scale_data$ssi[idx]

  if (!quiet) {
    n_unmatched <- sum(!is.na(code_values) & is.na(idx))
    if (n_unmatched > 0) {
      unmatched_codes <- sort(unique(code_values[!is.na(code_values) & is.na(idx)]))
      message(
        n_unmatched, " observations with unmatched codes (NA assigned): ",
        paste(utils::head(unmatched_codes, 10), collapse = ", "),
        if (length(unmatched_codes) > 10) paste0(", ... (", length(unmatched_codes), " unique codes)") else ""
      )
    }
  }

  tibble::as_tibble(data)
}

#' Check Unmatched Occupation Codes
#'
#' Identify occupation codes in the data that do not have corresponding
#' SEI/SSI scale values.
#'
#' @param data Data frame
#' @param code Variable name containing occupation codes (unquoted)
#' @param type Scale type: "ssm" for SSM occupation codes (default),
#'   "jess" for JESS 232 occupation codes
#' @return Tibble with columns `code` (unmatched code values) and `n`
#'   (number of observations). Returns empty tibble if all codes match.
#' @export
#'
#' @examples
#' df <- data.frame(occ = c(501, 502, 999, 999))
#' check_occ_scale(df, occ, type = "ssm")
#'
check_occ_scale <- function(data, code, type = c("ssm", "jess")) {
  type <- match.arg(type)
  code_name <- deparse(substitute(code))

  if (!code_name %in% names(data)) {
    stop("Column '", code_name, "' not found in data")
  }

  scale_data <- .load_occ_scale(type)
  code_col <- if (type == "ssm") "ssm" else "occ"

  code_values <- data[[code_name]]
  valid_codes <- scale_data[[code_col]]

  unmatched <- code_values[!is.na(code_values) & !code_values %in% valid_codes]

  if (length(unmatched) == 0) {
    message("All codes matched successfully")
    return(tibble::tibble(code = numeric(0), n = integer(0)))
  }

  result <- as.data.frame(table(unmatched), stringsAsFactors = FALSE)
  names(result) <- c("code", "n")
  result$code <- as.numeric(result$code)
  result <- result[order(-result$n), ]
  tibble::as_tibble(result)
}

# Cache environment for loaded scale data
.occ_scale_cache <- new.env(parent = emptyenv())

#' Load occupational scale data (internal)
#' @noRd
.load_occ_scale <- function(type) {
  cache_key <- paste0("scale_", type)

  if (exists(cache_key, envir = .occ_scale_cache)) {
    return(get(cache_key, envir = .occ_scale_cache))
  }

  filename <- if (type == "ssm") {
    "SSM_sei_ssi_v1.0.csv"
  } else {
    "JESS_232_sei_ssi_v1.0.csv"
  }

  filepath <- system.file("extdata", filename, package = "socialsurvey")
  if (filepath == "") {
    stop("Scale data file not found: ", filename)
  }

  data <- utils::read.csv(filepath, stringsAsFactors = FALSE)
  assign(cache_key, data, envir = .occ_scale_cache)
  data
}
