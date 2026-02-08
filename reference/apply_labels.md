# Apply Labels from a Definition Data Frame

Apply Labels from a Definition Data Frame

## Usage

``` r
apply_labels(data, label_def)
```

## Arguments

- data:

  Data frame to apply labels

- label_def:

  Data frame with columns: variable, label, value_labels

## Value

Data frame with labels applied

## Examples

``` r
# Define labels in R
label_def <- data.frame(
  variable = c("gender", "age"),
  label = c("Gender", "Age in years"),
  value_labels = c("1=Male; 2=Female", NA)
)
df <- apply_labels(df, label_def)

# From CSV (machine readable)
# labels.csv:
# variable,label,value_labels
# gender,Gender,"1=Male; 2=Female"
# age,Age in years,
#
# label_def <- read.csv("labels.csv")
# df <- apply_labels(df, label_def)
```
