# List Variables with Labels

Extract variable names and labels from a data frame as a tibble. Useful
for quick reference of variable names and their descriptions. By
default, prints all rows (unlike standard tibble which shows 10 rows).

## Usage

``` r
varlist(data, value_labels = FALSE, n = Inf)
```

## Arguments

- data:

  A data frame (typically with labelled variables)

- value_labels:

  If TRUE, include value labels column. Default is FALSE.

- n:

  Number of rows to print. Default is Inf (all rows).

## Value

A tibble with columns: variable, label (and optionally value_labels)

## Examples

``` r
if (FALSE) { # \dontrun{
ssm <- download_csrda("ssm")
varlist(ssm)

# Include value labels
varlist(ssm, value_labels = TRUE)

# Filter variables
varlist(ssm) |> dplyr::filter(grepl("問6", label))
} # }
```
