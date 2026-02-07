# socialsurvey 0.1.0

## New Features

* `freq()`: Frequency table with valid/missing percentages, supports Japanese output (`lang = "ja"`) and survey weights
* `varlist()`: List variables with labels, optional value labels display
* `metadata()`: Extract variable and value labels as tibble
* `set_var_label()` / `set_val_labels()`: Set variable and value labels
* `apply_labels()`: Batch apply labels from CSV definition table
* `apply_labels_json()`: Batch apply labels from JSON file
* `export_labels()` / `export_labels_json()`: Export labels to CSV or JSON
* `normalize_labels()`: Convert full-width characters to half-width (Japanese support)
* `validate_labels()`: Check labels for prohibited characters
* `parse_spss_labels()`: Parse SPSS VARIABLE LABELS / VALUE LABELS syntax
* `apply_spss_labels()`: Apply SPSS syntax labels directly to a data frame
* `std()`: Standardize variables (z-scores, T-scores, etc.)
* `fmt()`: Format numbers with fixed decimal places
* `quantile_group()`: Divide values into quantile groups
* `prank()`: Weighted percent rank for survey data
* `occ_scale()`: Assign SEI/SSI from occupation codes (SSM / JESS 232)
* `check_occ_scale()`: Check for occupation codes without scale values
* `download_csrda()`: Download sample data from CSRDA

## Design

* All functions are dplyr-friendly and work with `|>` pipe and `mutate()`
* Results returned as tibbles for easy reuse
