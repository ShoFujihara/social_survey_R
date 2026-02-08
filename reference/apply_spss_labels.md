# Apply SPSS Label Syntax to Data Frame

Parse SPSS VARIABLE LABELS and VALUE LABELS syntax and apply them to a
data frame. Combines
[`parse_spss_labels`](https://shofujihara.github.io/social_survey_R/reference/parse_spss_labels.md)
and
[`apply_labels`](https://shofujihara.github.io/social_survey_R/reference/apply_labels.md).

## Usage

``` r
apply_spss_labels(data, syntax = NULL, file = NULL)
```

## Arguments

- data:

  Data frame to apply labels

- syntax:

  Character string containing SPSS syntax. If NULL, `file` must be
  specified.

- file:

  Path to an SPSS syntax file (.sps). If NULL, `syntax` must be
  specified.

## Value

Data frame with labels applied

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
df <- apply_spss_labels(df, spss_syntax)

# From .sps file
# df <- apply_spss_labels(df, file = "labels.sps")
```
