# Apply Labels from JSON File

Apply variable labels and value labels from a JSON file. JSON format
allows special characters (`;`, `=`, `"`) in labels.

## Usage

``` r
apply_labels_json(data, file)
```

## Arguments

- data:

  Data frame to apply labels

- file:

  Path to JSON file

## Value

Data frame with labels applied

## Examples

``` r
# JSON format:
# [
#   {"variable": "gender", "label": "Gender",
#    "value_labels": {"1": "Male", "2": "Female"}},
#   {"variable": "age", "label": "Age in years"}
# ]
#
# df <- apply_labels_json(df, "labels.json")
```
