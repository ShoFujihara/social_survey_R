#' socialsurvey: R Functions for Social Survey Data Analysis
#'
#' A collection of R functions for social survey data analysis.
#' Includes tools for frequency tables, metadata management, variable labels,
#' value labels, and codebook generation.
#'
#' @section Main Functions:
#' \describe{
#'   \item{\code{\link{freq}}}{Frequency table with valid/missing percentages}
#'   \item{\code{\link{metadata}}}{Extract variable and value labels}
#'   \item{\code{\link{set_var_label}}}{Set variable label}
#'   \item{\code{\link{set_val_labels}}}{Set value labels}
#'   \item{\code{\link{apply_labels}}}{Batch apply labels from definition table}
#' }
#'
#' @section Supported File Formats:
#' \itemize{
#'   \item Stata (.dta)
#'   \item SPSS (.sav)
#'   \item SAS (.sas7bdat)
#' }
#'
#' @docType package
#' @name socialsurvey-package
#' @aliases socialsurvey
#'
#' @examples
#' library(socialsurvey)
#'
#' # Frequency table
#' freq(dplyr::starwars, gender)
#'
#' # With Japanese output
#' freq(dplyr::starwars, gender, lang = "ja")
#'
NULL
