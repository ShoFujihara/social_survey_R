# Set Variable Label

Set Variable Label

## Usage

``` r
set_var_label(data, var, label)
```

## Arguments

- data:

  Data frame

- var:

  Variable name (unquoted)

- label:

  Label string

## Value

Data frame with label applied

## Examples

``` r
df <- data.frame(gender = c(1, 2, 1), age = c(25, 30, 35))
df <- set_var_label(df, gender, "Gender")
```
