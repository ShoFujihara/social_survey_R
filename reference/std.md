# Standardize a Variable

Standardize a numeric variable to have a specified mean and standard
deviation. By default, creates z-scores (mean = 0, sd = 1).

## Usage

``` r
std(x, mean = 0, sd = 1, na.rm = TRUE)
```

## Arguments

- x:

  Numeric vector to standardize

- mean:

  Target mean (default = 0)

- sd:

  Target standard deviation (default = 1)

- na.rm:

  Remove NA values when calculating mean and sd (default = TRUE)

## Value

Standardized numeric vector

## Examples

``` r
# Z-scores (mean = 0, sd = 1)
x <- c(10, 20, 30, 40, 50)
std(x)
#> [1] -1.2649111 -0.6324555  0.0000000  0.6324555  1.2649111

# Standardize to mean = 50, sd = 10 (T-scores)
std(x, mean = 50, sd = 10)
#> [1] 37.35089 43.67544 50.00000 56.32456 62.64911

# With NA values
x <- c(10, 20, NA, 40, 50)
std(x)  # NA is preserved in output
#> [1] -1.0954451 -0.5477226         NA  0.5477226  1.0954451

# Use with dplyr
# df |> mutate(income_z = std(income))
```
