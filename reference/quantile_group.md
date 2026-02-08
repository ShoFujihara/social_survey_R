# Divide Values into Quantile Groups

Divide a numeric vector into n groups based on quantile values. More
precise than dplyr::ntile() which uses ranks.

## Usage

``` r
quantile_group(x, n = 4, na.rm = TRUE)
```

## Arguments

- x:

  Numeric vector

- n:

  Number of groups (default = 4 for quartiles)

- na.rm:

  Remove NA values when calculating quantiles (default = TRUE)

## Value

Integer vector with group assignments (1 to n)

## Examples

``` r
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

# Quartiles (4 groups)
quantile_group(x)       # 1 1 1 2 2 3 3 4 4 4
#>  [1] 1 1 1 2 2 3 3 4 4 4

# Tertiles (3 groups)
quantile_group(x, 3)    # 1 1 1 1 2 2 2 3 3 3
#>  [1] 1 1 1 1 2 2 2 3 3 3

# Deciles (10 groups)
quantile_group(x, 10)
#>  [1]  1  2  3  4  5  6  7  8  9 10

# With NA values
x <- c(1, 2, NA, 4, 5)
quantile_group(x)       # 1 1 NA 3 4
#> [1]  1  2 NA  3  4

# With dplyr
# df |> mutate(income_q = quantile_group(income, 4))
```
