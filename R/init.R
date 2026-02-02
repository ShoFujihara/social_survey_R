#' Load all functions from R folder
#'
#' @examples
#' source("R/init.R")
#'

# Required packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr)

# Load all R files in R folder
r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
r_files <- r_files[!grepl("init\\.R$", r_files)]  # Exclude init.R itself

for (f in r_files) {
  source(f)
}

cat("Loaded:", length(r_files), "file(s)\n")
cat(paste(" -", basename(r_files), collapse = "\n"), "\n")
