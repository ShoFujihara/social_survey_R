# socialsurvey

R functions for social survey data analysis.

## Installation

```r
# Install from GitHub
devtools::install_github("ShoFujihara/social_survey_R")

# Load
library(socialsurvey)
```

## Functions

| Function | Description |
|----------|-------------|
| `freq()` | Frequency table with valid/missing percentages |
| `metadata()` | Extract variable and value labels |
| `set_var_label()` | Set variable label |
| `set_val_labels()` | Set value labels |
| `apply_labels()` | Batch apply labels from definition table |

## Usage

### Frequency Table

```r
library(socialsurvey)

# Basic frequency
freq(df, gender)

# With weight
freq(df, gender, wt = weight)

# With probability weight
freq(df, gender, wt = prob, prob = TRUE)

# Japanese output
freq(df, gender, lang = "ja")
```

### Metadata

```r
# Get variable info
metadata(df)

# Set labels
df <- set_var_label(df, gender, "Gender")
df <- set_val_labels(df, gender, Male = 1, Female = 2)
```

## License

GPL (>= 3)
