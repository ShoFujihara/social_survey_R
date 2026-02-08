# Validate Labels for Prohibited Characters

Check variable and value labels for prohibited or problematic
characters. Returns a report of any issues found.

## Usage

``` r
validate_labels(
  data,
  check_newlines = TRUE,
  check_tabs = TRUE,
  check_control = TRUE,
  check_csv_special = TRUE,
  lang = "en"
)
```

## Arguments

- data:

  Data frame with labelled variables

- check_newlines:

  Check for newline characters (\n, \r). Default TRUE.

- check_tabs:

  Check for tab characters (\t). Default TRUE.

- check_control:

  Check for other control characters. Default TRUE.

- check_csv_special:

  Check for CSV special characters (`;` in value labels). Default TRUE.

- lang:

  Language for output: "en" (default) or "ja"

## Value

Data frame with validation issues (invisible if no issues)

## Examples

``` r
# Check for problematic characters
issues <- validate_labels(df)
#> No issues found

# Japanese output
issues <- validate_labels(df, lang = "ja")
#> 問題は見つかりませんでした
```
