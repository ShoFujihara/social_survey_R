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
- Enclose value_labels in quotes if it contains commas or semicolons
- Leave cell empty if no label needed

## License

GPL (>= 3)
