# Export Labels to JSON Format

Export variable labels and value labels to a JSON file. JSON format
allows special characters (`;`, `=`, `"`) in labels.

## Usage

``` r
export_labels_json(data, file = NULL, pretty = TRUE)
```

## Arguments

- data:

  Data frame with labelled variables

- file:

  Optional file path to save JSON. If NULL, returns list only.

- pretty:

  If TRUE, format JSON with indentation (default TRUE)

## Value

List with label definitions (invisibly if file is specified)

## Examples

``` r
# Export to JSON
export_labels_json(df, "labels.json")
#> Labels exported to: labels.json

# Get as list
label_list <- export_labels_json(df)
```
