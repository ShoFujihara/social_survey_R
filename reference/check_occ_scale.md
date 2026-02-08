# Check Unmatched Occupation Codes

Identify occupation codes in the data that do not have corresponding
SEI/SSI scale values.

## Usage

``` r
check_occ_scale(data, code, type = c("ssm", "jess"))
```

## Arguments

- data:

  Data frame

- code:

  Variable name containing occupation codes (unquoted)

- type:

  Scale type: "ssm" for SSM occupation codes (default), "jess" for JESS
  232 occupation codes

## Value

Tibble with columns `code` (unmatched code values) and `n` (number of
observations). Returns empty tibble if all codes match.

## Examples

``` r
df <- data.frame(occ = c(501, 502, 999, 999))
check_occ_scale(df, occ, type = "ssm")
#> # A tibble: 1 × 2
#>    code     n
#>   <dbl> <int>
#> 1   999     2
```
