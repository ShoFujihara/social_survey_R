# Export Labels to CSV Format

Export variable labels and value labels from a data frame to a
CSV-compatible data frame that can be used with apply_labels().

## Usage

``` r
export_labels(data, file = NULL)
```

## Arguments

- data:

  Data frame with labelled variables

- file:

  Optional file path to save CSV. If NULL, returns data frame only.

## Value

Data frame with columns: variable, label, value_labels

## Examples

``` r
library(labelled)
df <- data.frame(
  gender = c(1, 2, 1, 2),
  age = c(25, 30, 35, 40)
)
var_label(df$gender) <- "Gender"
val_labels(df$gender) <- c("Male" = 1, "Female" = 2)
var_label(df$age) <- "Age in years"

# Get as data frame
label_def <- export_labels(df)

# Save to CSV
export_labels(df, "labels.csv")
#> Labels exported to: labels.csv
#>   variable        label     value_labels
#> 1   gender       Gender 1=Male; 2=Female
#> 2      age Age in years             <NA>
```
