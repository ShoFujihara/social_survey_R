# Download CSRDA Sample Data

Download unrestricted pseudo-data from CSRDA (Center for Social Research
and Data Archives) at the Institute of Social Science, The University of
Tokyo. Data is downloaded directly from CSRDA servers.

## Usage

``` r
download_csrda(
  dataset = c("ssm", "jlps"),
  dir = ".",
  load = TRUE,
  format = c("sav", "dta", "csv"),
  quiet = FALSE
)
```

## Arguments

- dataset:

  Dataset to download: "ssm" (2015 SSM Survey) or "jlps" (JLPS-Y wave1
  2007)

- dir:

  Directory to save data. Default is current working directory.

- load:

  If TRUE, load the data into R after downloading. Default is TRUE.

- format:

  File format to load: "sav" (SPSS), "dta" (Stata), or "csv". Default is
  "sav".

- quiet:

  If TRUE, suppress messages. Default is FALSE.

## Value

If load = TRUE, returns a tibble. Otherwise returns the path to the
extracted directory invisibly.

## Details

Available datasets:

- `ssm`: 2015 SSM Japan Survey (u002) - 2,000 cases, 35 variables

- `jlps`: JLPS-Y wave1 2007 (u001) - 1,000 cases, 72 variables

These are pseudo-data created from actual survey data with noise added.
They are intended for education and practice only, not for academic
research. For academic research, please apply for actual data through
SSJDA Direct.

Data source: <https://csrda.iss.u-tokyo.ac.jp/infrastructure/urd/>

## Note

Questionnaires and codebooks are not included in the download. Please
download them directly from the CSRDA website:

- SSM: <https://csrda.iss.u-tokyo.ac.jp/infrastructure/urd/ssm/>

- JLPS: <https://csrda.iss.u-tokyo.ac.jp/infrastructure/urd/jlps/>

## Examples

``` r
if (FALSE) { # \dontrun{
# Download and load SSM data
ssm <- download_csrda("ssm")

# Download JLPS data to specific directory
jlps <- download_csrda("jlps", dir = "data")

# Download without loading
download_csrda("ssm", load = FALSE)
} # }
```
