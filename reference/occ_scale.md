# Assign Occupational Scales (SEI/SSI)

Look up Socio-Economic Index (SEI) and Social Status Index (SSI) values
for occupation codes and add them as new columns to the data frame.

## Usage

``` r
occ_scale(data, code, type = c("ssm", "jess"), quiet = FALSE)
```

## Source

Data from OccupationalScales v1.0:
<https://github.com/ShoFujihara/OccupationalScales>

## Arguments

- data:

  Data frame

- code:

  Variable name containing occupation codes (unquoted)

- type:

  Scale type: "ssm" for SSM occupation codes (default), "jess" for JESS
  232 occupation codes

- quiet:

  If TRUE, suppress messages about unmatched codes (default = FALSE)

## Value

Data frame with `.sei` and `.ssi` columns added. Unmatched codes will
have `NA` for both columns.

## Examples

``` r
df <- data.frame(occ = c(501, 502, 999))
occ_scale(df, occ, type = "ssm")
#> 1 observations with unmatched codes (NA assigned): 999
#> # A tibble: 3 × 3
#>     occ  .sei  .ssi
#>   <dbl> <dbl> <dbl>
#> 1   501  68.0  70.4
#> 2   502  71.0  75.5
#> 3   999  NA    NA  

# With dplyr pipe
# data |> occ_scale(occupation, type = "ssm")
```
