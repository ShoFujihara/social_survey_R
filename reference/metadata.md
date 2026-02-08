# Get Variable and Value Labels Metadata

Extract variable labels and value labels from a data frame.

## Usage

``` r
metadata(data, lang = "en", quiet = FALSE)
```

## Arguments

- data:

  Data frame (supports labelled data from haven)

- lang:

  Language for output: "en" (default) or "ja"

- quiet:

  If TRUE, suppress summary output (default = FALSE)

## Value

Data frame with variable metadata

## Examples

``` r
# Sample data with labels
library(labelled)
df <- data.frame(
  gender = c(1, 2, 1, 2),
  age = c(25, 30, 35, 40)
)
var_label(df$gender) <- "Gender"
val_labels(df$gender) <- c("Male" = 1, "Female" = 2)
var_label(df$age) <- "Age in years"

# Get metadata
metadata(df)
#> Metadata
#> Cases: 4  Variables: 2
#> 
#>   variable        label           type n missing missing_pct     value_labels
#> 1   gender       Gender haven_labelled 4       0           0 1=Male; 2=Female
#> 2      age Age in years        numeric 4       0           0             <NA>
```
