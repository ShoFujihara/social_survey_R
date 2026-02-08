# Frequency Table

Create a frequency table for a single variable with both total and valid
percentages.

## Usage

``` r
freq(data, var, wt = 1, prob = FALSE, lang = "en", quiet = FALSE)
```

## Arguments

- data:

  Data frame

- var:

  Variable name (unquoted)

- wt:

  Weight variable (default = 1)

- prob:

  If TRUE, treat wt as probability weight and use 1/wt (default = FALSE)

- lang:

  Language for output: "en" (default) or "ja"

- quiet:

  If TRUE, suppress summary output (default = FALSE)

## Value

Frequency table (tibble)

## Examples

``` r
# Sample data
df <- data.frame(
  gender = c("Male", "Female", "Male", NA, "Female", "Male", NA),
  age_group = c("20s", "30s", "20s", "40s", NA, "30s", "20s"),
  weight = c(1.2, 0.8, 1.0, 1.1, 0.9, 1.3, 0.7)
)

# Frequency table (no weight)
freq(df, gender)
#> Variable: gender
#> Total: 7  Valid: 5  Missing: 2 (28.6%)
#> 
#>   gender n  percent valid_n valid_percent
#> 1 Female 2 28.57143       2            40
#> 2   Male 3 42.85714       3            60
#> 3   <NA> 2 28.57143      NA            NA

# Frequency table (with weight)
freq(df, gender, wt = weight)
#> Variable: gender
#> Total: 7  Valid: 5.2  Missing: 1.8 (25.7%)
#> 
#>   gender   n  percent valid_n valid_percent
#> 1 Female 1.7 24.28571     1.7      32.69231
#> 2   Male 3.5 50.00000     3.5      67.30769
#> 3   <NA> 1.8 25.71429      NA            NA

# Frequency table (with probability weight)
freq(df, gender, wt = weight, prob = TRUE)
#> Variable: gender
#> Total: 7.3  Valid: 5  Missing: 2.3 (32%)
#> 
#>   gender        n  percent  valid_n valid_percent
#> 1 Female 2.361111 32.33806 2.361111       47.5678
#> 2   Male 2.602564 35.64503 2.602564       52.4322
#> 3   <NA> 2.337662 32.01691       NA            NA

# Japanese output
freq(df, gender, lang = "ja")
#> 変数: gender
#> 総数: 7  有効: 5  欠損: 2 (28.6%)
#> 
#>   gender n  percent valid_n valid_percent
#> 1 Female 2 28.57143       2            40
#> 2   Male 3 42.85714       3            60
#> 3   <NA> 2 28.57143      NA            NA
```
