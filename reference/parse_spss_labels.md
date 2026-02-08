# Parse SPSS Label Syntax

Parse SPSS VARIABLE LABELS and VALUE LABELS syntax into a data frame
compatible with
[`apply_labels`](https://shofujihara.github.io/social_survey_R/reference/apply_labels.md).

## Usage

``` r
parse_spss_labels(syntax = NULL, file = NULL)
```

## Arguments

- syntax:

  Character string containing SPSS syntax. If NULL, `file` must be
  specified.

- file:

  Path to an SPSS syntax file (.sps). If NULL, `syntax` must be
  specified.

## Value

Data frame with columns: variable, label, value_labels

## Examples

``` r
spss_syntax <- '
VARIABLE LABELS
  gender "Gender"
  age "Age in years".
VALUE LABELS
  gender
    1 "Male"
    2 "Female".
'
label_def <- parse_spss_labels(spss_syntax)
```
