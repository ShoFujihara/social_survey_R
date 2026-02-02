# socialsurvey

R functions for social survey data analysis.

## Design Philosophy

- **dplyr-friendly**: All functions work seamlessly with `|>` pipe and `mutate()`
- **Tibble output**: Results are returned as tibbles for easy reuse and further analysis

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
| `varlist()` | List variables with labels |
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
| `download_csrda()` | Download sample data from CSRDA |

## Usage

### Download Sample Data

Download unrestricted pseudo-data from CSRDA for practice and education.

```r
library(socialsurvey)

# Download and normalize labels (full-width to half-width)
ssm <- download_csrda("ssm") |> normalize_labels()
jlps <- download_csrda("jlps") |> normalize_labels()
```

Data source: [CSRDA](https://csrda.iss.u-tokyo.ac.jp/infrastructure/urd/)

### Variable List

```r
# List all variables with labels and value labels
varlist(ssm)

# Filter variables by label
varlist(ssm) |> dplyr::filter(grepl("満足", label))
```

### Frequency Table

```r
# Basic frequency
freq(ssm, sex)

# Japanese output
freq(ssm, sex, lang = "ja")

# With weight (if available)
# freq(ssm, sex, wt = weight)
```

### Metadata

```r
# Get variable info
metadata(ssm)

# Set labels
ssm <- set_var_label(ssm, sex, "Gender")
ssm <- set_val_labels(ssm, sex, `1` = "Male", `2` = "Female")

# Convert to factor using labels
ssm$sex_fc <- labelled::as_factor(ssm$sex)

# Or with dplyr
ssm <- ssm |> dplyr::mutate(sex_fc = labelled::as_factor(sex))
```

**Note:** Use `labelled::as_factor()` to convert labelled variables to factors with their value labels as factor levels.

### Apply Labels from CSV

```r
# Read label definition CSV
label_def <- read.csv("labels.csv")
ssm <- apply_labels(ssm, label_def)
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
sex,Gender,"1=Male; 2=Female"
age,Age in years,
educ,Education level,"4=Junior high; 5=High school; 10=University"
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
ssm <- apply_labels_json(ssm, "labels.json")

# Export labels to JSON
export_labels_json(ssm, "labels.json")
```

### Standardize Variables

```r
# Z-scores (mean = 0, sd = 1)
ssm$pinc_z <- std(ssm$pinc)

# T-scores (mean = 50, sd = 10)
ssm$pinc_t <- std(ssm$pinc, mean = 50, sd = 10)

# With dplyr
ssm <- ssm |> dplyr::mutate(pinc_z = std(pinc))
```

### Format Numbers

```r
# Preserve trailing zeros
fmt(1.5)       # "1.50"
fmt(1.5, 3)    # "1.500"
fmt(0, 2)      # "0.00"

# With dplyr
ssm |> dplyr::mutate(pinc_fmt = fmt(pinc, 0))
```

### Quantile Groups

```r
# Quartiles (4 groups, default)
ssm$pinc_q4 <- quantile_group(ssm$pinc)

# Tertiles (3 groups)
ssm$pinc_q3 <- quantile_group(ssm$pinc, 3)

# Deciles (10 groups)
ssm$pinc_q10 <- quantile_group(ssm$pinc, 10)

# With dplyr
ssm <- ssm |> dplyr::mutate(pinc_q = quantile_group(pinc, 4))
```

More precise than `dplyr::ntile()` which uses ranks. `quantile_group()` uses actual quantile values.

### Weighted Percent Rank

```r
# Percent rank (unweighted)
ssm$pinc_prank <- wtd_percent_rank(ssm$pinc)

# With dplyr
ssm <- ssm |> dplyr::mutate(pinc_prank = wtd_percent_rank(pinc))
```

Returns the weighted proportion of observations with values less than each value (0 to 1).

### Preprocessing Labels (Japanese Support)

```r
# Normalize full-width characters to half-width
ssm <- normalize_labels(ssm)

# Also convert full-width alphabet (ａ→a, Ａ→A)
ssm <- normalize_labels(ssm, convert_alpha = TRUE)

# Check for prohibited characters
issues <- validate_labels(ssm)

# Japanese output
issues <- validate_labels(ssm, lang = "ja")
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
