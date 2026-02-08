# Set Value Labels

Set Value Labels

## Usage

``` r
set_val_labels(data, var, ...)
```

## Arguments

- data:

  Data frame

- var:

  Variable name (unquoted)

- ...:

  Value-label pairs (e.g., `1` = "Male", `2` = "Female")

## Value

Data frame with value labels applied

## Examples

``` r
df <- data.frame(gender = c(1, 2, 1), age = c(25, 30, 35))
df <- set_val_labels(df, gender, `1` = "Male", `2` = "Female")
```
