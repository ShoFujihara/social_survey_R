#' Download CSRDA Sample Data
#'
#' Download unrestricted pseudo-data from CSRDA (Center for Social Research and Data Archives).
#' Data is downloaded directly from CSRDA servers.
#'
#' @param dataset Dataset to download: "ssm" (2015 SSM Survey) or "jlps" (JLPS-Y wave1 2007)
#' @param dir Directory to save data. Default is current working directory.
#' @param load If TRUE, load the data into R after downloading. Default is TRUE.
#' @param format File format to load: "sav" (SPSS), "dta" (Stata), or "csv". Default is "sav".
#' @param quiet If TRUE, suppress messages. Default is FALSE.
#' @return If load = TRUE, returns a tibble. Otherwise returns the path to the extracted directory invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Download and load SSM data
#' ssm <- download_csrda("ssm")
#'
#' # Download JLPS data to specific directory
#' jlps <- download_csrda("jlps", dir = "data")
#'
#' # Download without loading
#' download_csrda("ssm", load = FALSE)
#' }
#'
#' @details
#' Available datasets:
#' \itemize{
#'   \item \code{ssm}: 2015 SSM Japan Survey (u002) - 2,000 cases, 35 variables
#'   \item \code{jlps}: JLPS-Y wave1 2007 (u001) - 1,000 cases, 72 variables
#' }
#'
#' These are pseudo-data created from actual survey data with noise added.
#' They are intended for education and practice only, not for academic research.
#' For academic research, please apply for actual data through SSJDA Direct.
#'
#' Data source: \url{https://csrda.iss.u-tokyo.ac.jp/infrastructure/urd/}
#'
download_csrda <- function(dataset = c("ssm", "jlps"),
                           dir = ".",
                           load = TRUE,
                           format = c("sav", "dta", "csv"),
                           quiet = FALSE) {

  dataset <- match.arg(dataset)
  format <- match.arg(format)

  # Dataset info
  info <- list(
    ssm = list(
      id = "u002",
      name = "2015 SSM Japan Survey",
      url = "https://csrda.iss.u-tokyo.ac.jp/infrastructure/urd/download_data/u002.zip"
    ),
    jlps = list(
      id = "u001",
      name = "JLPS-Y wave1 2007",
      url = "https://csrda.iss.u-tokyo.ac.jp/infrastructure/urd/download_data/u001.zip"
    )
  )

  data_info <- info[[dataset]]

  # Create directory if needed
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }

  # File paths

  zip_path <- file.path(dir, paste0(data_info$id, ".zip"))
  extract_dir <- file.path(dir, data_info$id)

  # Check if already downloaded
  if (dir.exists(extract_dir)) {
    if (!quiet) {
      message("Data already exists: ", extract_dir)
    }
  } else {
    # Download
    if (!quiet) {
      message("Downloading ", data_info$name, " from CSRDA...")
      message("URL: ", data_info$url)
    }

    tryCatch({
      utils::download.file(
        url = data_info$url,
        destfile = zip_path,
        mode = "wb",
        quiet = quiet
      )
    }, error = function(e) {
      stop("Download failed. Please check your internet connection.\n",
           "You can also download manually from:\n",
           data_info$url,
           call. = FALSE)
    })

    # Extract
    if (!quiet) {
      message("Extracting...")
    }
    utils::unzip(zip_path, exdir = dir)

    # Remove zip file
    unlink(zip_path)

    if (!quiet) {
      message("Done! Data saved to: ", extract_dir)
    }
  }

  # Load data if requested
  if (load) {
    data_file <- file.path(extract_dir, paste0(data_info$id, ".", format))

    if (!file.exists(data_file)) {
      stop("File not found: ", data_file, call. = FALSE)
    }

    if (!quiet) {
      message("Loading ", basename(data_file), "...")
    }

    if (format == "sav") {
      if (!requireNamespace("haven", quietly = TRUE)) {
        stop("Package 'haven' is required to read SPSS files. Install with: install.packages('haven')",
             call. = FALSE)
      }
      data <- haven::read_sav(data_file)
    } else if (format == "dta") {
      if (!requireNamespace("haven", quietly = TRUE)) {
        stop("Package 'haven' is required to read Stata files. Install with: install.packages('haven')",
             call. = FALSE)
      }
      data <- haven::read_dta(data_file)
    } else {
      data <- utils::read.csv(data_file, stringsAsFactors = FALSE)
      data <- tibble::as_tibble(data)
    }

    if (!quiet) {
      message("Loaded: ", nrow(data), " cases, ", ncol(data), " variables")
      message("\nNote: This is pseudo-data for education/practice only.")
      message("For academic research, apply for actual data at: https://ssjda.iss.u-tokyo.ac.jp/Direct/")
    }

    return(data)
  }

  invisible(extract_dir)
}
