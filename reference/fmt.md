# Format Numbers with Fixed Decimal Places

Format numeric values with a fixed number of decimal places, preserving
trailing zeros for consistent display in tables and figures.

## Usage

``` r
fmt(x, digits = 2, trim = TRUE)
```

## Arguments

- x:

  Numeric vector to format

- digits:

  Number of decimal places (default = 2)

- trim:

  Remove leading whitespace (default = TRUE)

## Value

Character vector of formatted numbers

## Examples

``` r
# Basic usage
fmt(1.5)       # "1.50"
#> [1] "1.50"
fmt(1.5, 3)    # "1.500"
#> [1] "1.500"
fmt(0.1, 2)    # "0.10"
#> [1] "0.10"

# Vector input
fmt(c(1, 1.5, 1.55, 1.555))  # "1.00" "1.50" "1.55" "1.56"
#> [1] "1.00" "1.50" "1.55" "1.55"

# With dplyr
# df |> mutate(mean_fmt = fmt(mean_val))
```
