# Normalize Labels (Full-width to Half-width Conversion)

Convert full-width characters to half-width in variable and value
labels. Useful for Japanese data where numbers and symbols may be in
full-width format.

## Usage

``` r
normalize_labels(
  data,
  convert_numbers = TRUE,
  convert_symbols = TRUE,
  convert_alpha = TRUE,
  convert_space = TRUE,
  space_before_paren = TRUE,
  space_after_paren = TRUE,
  space_after_colon = TRUE,
  space_after_period = TRUE
)
```

## Arguments

- data:

  Data frame with labelled variables

- convert_numbers:

  Convert full-width numbers to half-width (0-9). Default TRUE.

- convert_symbols:

  Convert full-width symbols (=, ;, etc.) to half-width. Default TRUE.

- convert_alpha:

  Convert full-width alphabet (A-Z, a-z) to half-width. Default TRUE.

- convert_space:

  Convert full-width space to half-width. Default TRUE.

- space_before_paren:

  Add space before half-width opening parenthesis when converting from
  full-width. Default TRUE.

- space_after_paren:

  Add space after half-width closing parenthesis when converting from
  full-width. Default TRUE.

- space_after_colon:

  Add space after half-width colon when converting from full-width.
  Default TRUE.

- space_after_period:

  Add space after half-width period when converting from full-width.
  Default TRUE.

## Value

Data frame with normalized labels

## Examples

``` r
# Normalize full-width numbers, symbols, and alphabet in labels
df <- normalize_labels(df)

# Skip alphabet conversion
df <- normalize_labels(df, convert_alpha = FALSE)

# No space adjustments
df <- normalize_labels(df, space_before_paren = FALSE, space_after_paren = FALSE,
                       space_after_colon = FALSE, space_after_period = FALSE)
```
