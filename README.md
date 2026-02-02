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
| `apply_labels()` | Batch apply labels from CSV |
| `apply_labels_json()` | Batch apply labels from JSON |
| `export_labels()` | Export labels to CSV |
| `export_labels_json()` | Export labels to JSON |
| `normalize_labels()` | Convert full-width to half-width characters |
| `validate_labels()` | Check labels for prohibited characters |
| `std()` | Standardize variables (z-scores, T-scores, etc.) |
| `fmt()` | Format numbers with fixed decimal places |
| `quantile_group()` | Divide values into quantile groups |
| `wtd_percent_rank()` | Weighted percent rank for survey data |

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
df <- set_val_labels(df, gender, `1` = "Male", `2` = "Female")

# Convert to factor using labels
df$gender_fc <- labelled::as_factor(df$gender)

# Or with dplyr
df <- df |> mutate(gender_fc = labelled::as_factor(gender))
```

**Note:** Use `labelled::as_factor()` to convert labelled variables to factors with their value labels as factor levels.

### Apply Labels from CSV

```r
# Read label definition CSV
label_def <- read.csv("labels.csv")
df <- apply_labels(df, label_def)
```

#### CSV Format

| Column | Required | Description |
|--------|----------|-------------|
| `variable` | Yes | Variable name (must match column name in data) |
| `label` | No | Variable label |
| `value_labels` | No | Value labels in format: `1=Label1; 2=Label2` |

Example CSV:

```csv
variable,label,value_labels
gender,Gender,"1=Male; 2=Female"
age,Age in years,
education,Education level,"1=High school; 2=College; 3=Graduate"
income,Annual income (10k JPY),
satisfaction,Job satisfaction,"1=Very dissatisfied; 2=Dissatisfied; 3=Neutral; 4=Satisfied; 5=Very satisfied"
```

**Rules:**
- Use semicolon (`;`) to separate multiple value labels
- Use equals sign (`=`) to separate value and label (format: `value=label`)
- Enclose value_labels in quotes if it contains commas
- Leave cell empty if no label needed
- Labels can contain `=` (e.g., `1=A=B` works)
- Labels **cannot** contain `;` (used as separator)

### Apply Labels from JSON

JSON format allows any characters in labels (including `;` and `=`).

```r
# Apply labels from JSON
df <- apply_labels_json(df, "labels.json")

# Export labels to JSON
export_labels_json(df, "labels.json")
```

Example JSON:

```json
[
  {
    "variable": "gender",
    "label": "Gender",
    "value_labels": {"1": "Male", "2": "Female"}
  },
  {
    "variable": "satisfaction",
    "label": "Job satisfaction; overall",
    "value_labels": {"1": "A=B", "2": "Yes; No", "3": "Maybe"}
  }
]
```

### Standardize Variables

```r
# Z-scores (mean = 0, sd = 1)
df$income_z <- std(df$income)

# T-scores (mean = 50, sd = 10)
df$income_t <- std(df$income, mean = 50, sd = 10)

# With dplyr
df <- df |> mutate(income_z = std(income))
```

### Format Numbers

```r
# Preserve trailing zeros
fmt(1.5)       # "1.50"
fmt(1.5, 3)    # "1.500"
fmt(0, 2)      # "0.00"

# With dplyr
df |> mutate(mean_fmt = fmt(mean_val, 2))
```

### Quantile Groups

```r
# Quartiles (4 groups, default)
df$income_q4 <- quantile_group(df$income)

# Tertiles (3 groups)
df$income_q3 <- quantile_group(df$income, 3)

# Deciles (10 groups)
df$income_q10 <- quantile_group(df$income, 10)

# With dplyr
df <- df |> mutate(income_q = quantile_group(income, 4))
```

More precise than `dplyr::ntile()` which uses ranks. `quantile_group()` uses actual quantile values.

### Weighted Percent Rank

```r
# Percent rank with survey weights
df$income_prank <- wtd_percent_rank(df$income, df$weight)

# With dplyr
df <- df |> mutate(income_prank = wtd_percent_rank(income, weight))
```

Returns the weighted proportion of observations with values less than each value (0 to 1).

### Preprocessing Labels (Japanese Support)

```r
# Normalize full-width characters to half-width
df <- normalize_labels(df)

# Also convert full-width alphabet
df <- normalize_labels(df, convert_alpha = TRUE)

# Check for prohibited characters
issues <- validate_labels(df)

# Japanese output
issues <- validate_labels(df, lang = "ja")
```

**normalize_labels() options:**
- `convert_numbers`: Full-width numbers ０-９ → 0-9 (default: TRUE)
- `convert_symbols`: Full-width symbols ＝；，etc. → =;, (default: TRUE)
- `convert_alpha`: Full-width alphabet Ａ-Ｚ → A-Z (default: FALSE)
- `convert_space`: Full-width space → half-width (default: TRUE)

**validate_labels() checks:**
- Newline characters (`\n`, `\r`)
- Tab characters (`\t`)
- Control characters
- Semicolons in value labels (CSV incompatible)

## License

GPL (>= 3)
