# Changelog

## socialsurvey 0.1.0

### New Features

- [`freq()`](https://shofujihara.github.io/social_survey_R/reference/freq.md):
  Frequency table with valid/missing percentages, supports Japanese
  output (`lang = "ja"`) and survey weights
- [`varlist()`](https://shofujihara.github.io/social_survey_R/reference/varlist.md):
  List variables with labels, optional value labels display
- [`metadata()`](https://shofujihara.github.io/social_survey_R/reference/metadata.md):
  Extract variable and value labels as tibble
- [`set_var_label()`](https://shofujihara.github.io/social_survey_R/reference/set_var_label.md)
  /
  [`set_val_labels()`](https://shofujihara.github.io/social_survey_R/reference/set_val_labels.md):
  Set variable and value labels
- [`apply_labels()`](https://shofujihara.github.io/social_survey_R/reference/apply_labels.md):
  Batch apply labels from CSV definition table
- [`apply_labels_json()`](https://shofujihara.github.io/social_survey_R/reference/apply_labels_json.md):
  Batch apply labels from JSON file
- [`export_labels()`](https://shofujihara.github.io/social_survey_R/reference/export_labels.md)
  /
  [`export_labels_json()`](https://shofujihara.github.io/social_survey_R/reference/export_labels_json.md):
  Export labels to CSV or JSON
- [`normalize_labels()`](https://shofujihara.github.io/social_survey_R/reference/normalize_labels.md):
  Convert full-width characters to half-width (Japanese support)
- [`validate_labels()`](https://shofujihara.github.io/social_survey_R/reference/validate_labels.md):
  Check labels for prohibited characters
- [`parse_spss_labels()`](https://shofujihara.github.io/social_survey_R/reference/parse_spss_labels.md):
  Parse SPSS VARIABLE LABELS / VALUE LABELS syntax
- [`apply_spss_labels()`](https://shofujihara.github.io/social_survey_R/reference/apply_spss_labels.md):
  Apply SPSS syntax labels directly to a data frame
- [`std()`](https://shofujihara.github.io/social_survey_R/reference/std.md):
  Standardize variables (z-scores, T-scores, etc.)
- [`fmt()`](https://shofujihara.github.io/social_survey_R/reference/fmt.md):
  Format numbers with fixed decimal places
- [`quantile_group()`](https://shofujihara.github.io/social_survey_R/reference/quantile_group.md):
  Divide values into quantile groups
- [`prank()`](https://shofujihara.github.io/social_survey_R/reference/prank.md):
  Weighted percent rank for survey data
- [`occ_scale()`](https://shofujihara.github.io/social_survey_R/reference/occ_scale.md):
  Assign SEI/SSI from occupation codes (SSM / JESS 232)
- [`check_occ_scale()`](https://shofujihara.github.io/social_survey_R/reference/check_occ_scale.md):
  Check for occupation codes without scale values
- [`download_csrda()`](https://shofujihara.github.io/social_survey_R/reference/download_csrda.md):
  Download sample data from CSRDA

### Design

- All functions are dplyr-friendly and work with `|>` pipe and
  `mutate()`
- Results returned as tibbles for easy reuse
