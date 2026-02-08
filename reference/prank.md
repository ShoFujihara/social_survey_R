# Weighted Percent Rank

Calculate percent rank with survey weights. Returns the weighted
proportion of observations with values less than each value.

## Usage

``` r
prank(x, weights = NULL, na.rm = TRUE)
```

## Arguments

- x:

  Numeric vector

- weights:

  Numeric vector of weights (same length as x). If NULL, equal weights
  are used.

- na.rm:

  Remove NA values (default TRUE)

## Value

Numeric vector with values between 0 and 1

## Examples

``` r
x <- c(10, 20, 20, 30, 40)
w <- c(1, 2, 1, 3, 1)

# Weighted percent rank
prank(x, w)
#> [1] 0.000 0.125 0.125 0.500 0.875

# Without weights (equal weights)
prank(x)
#> [1] 0.0 0.2 0.2 0.6 0.8

# With dplyr
# ssm |> mutate(pinc_prank = prank(pinc, weight))
```
