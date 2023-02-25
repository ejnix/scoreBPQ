
<!-- README.md is generated from README.Rmd. Please edit that file -->

# scoreBPQ

<!-- badges: start -->
<!-- badges: end -->

The scoreBPQ package makes scoring the Body Perception Questionnaire
fast and easy, but some initial checks must be made to ensure that the
data is formatted properly.

-   In order for the scoring function to work properly, data must be in
    the proper form:
    -   All bpq items have the prefix “bpq\_”
    -   All bpq items must be properly numbered, from 1 to total number
        of items.
        -   Common Error: numbering each subscale separately. This will
            break the code.
    -   The correct form must be set as an argument in the function call
        (Default: Short Form)

For detailed descriptions of item numbers for each form, see Page 14 of
the BPQ Manual:
<https://www.traumascience.org/body-perception-questionnaire>

------------------------------------------------------------------------

# Example Use

## Installation

``` r
devtools::install_github("ejnix/scoreBPQ")
```

``` r
library(scoreBPQ)
```

## Data: test\_data

An example dataset has been included in the package as a reference for
what properly formatted raw data should look like. This dataset is
documented in ?test\_data. We can view this dataset at any time by
calling test\_data in the R console.

``` r
test_data
#>    ID bpq_1 bpq_2 bpq_3 bpq_4 bpq_5 bpq_6 bpq_7 bpq_8 bpq_9 bpq_10 bpq_11
#> 1 101     1     1     5     2     1     2     3     2     3      2      3
#> 2 102     3     4     1     3     1     3     1     3     1      2      2
#> 3 103     2     2     1     3     2     4     1     2     5      2      3
#> 4 104     3     1     1     3     2     1     4     1     2      1      2
#> 5 105     1     1     3     2     1     3     5     1     3      2      1
#>   bpq_12 bpq_13 bpq_14 bpq_15 bpq_16 bpq_17 bpq_18 bpq_19 bpq_20 bpq_21 bpq_22
#> 1      1      3      1      3      1      3      2      2      3      5      1
#> 2      4      3      3      2      2      3      3      3      4      2      3
#> 3      2      3      3      4      3      1      4      3      5      3      4
#> 4      1      5      2      2      3      3      4      2      2      3      1
#> 5      1      4      2      1      5      2      1     NA     NA      2      3
#>   bpq_23 bpq_24 bpq_25 bpq_26 bpq_27 bpq_28 bpq_29 bpq_30 bpq_31 bpq_32 bpq_33
#> 1      3      1      3      3      4      3      3      2      4      3      1
#> 2      2      3      1      3      1      1      3      4      1      5      2
#> 3      2      5      2      2      5      4      2      3      3      2      5
#> 4      3      2      1      2      1      5      3      4      3      2      1
#> 5      1      5      1     NA      1      2      2      2      5      1      2
#>   bpq_34 bpq_35 bpq_36 bpq_37 bpq_38 bpq_39 bpq_40 bpq_41 bpq_42 bpq_43 bpq_44
#> 1      3      3      3      3      4      4      1      2      1      2      4
#> 2      2      5      1      1      3      2      1      2      3      2      3
#> 3      2      4      3      2      1      2      2     NA      5      1      4
#> 4      1      1      1      3      3      1      1      3      1      5      1
#> 5      2      3      5      2      2      2      2      3      3      1      1
#>   bpq_45 bpq_46
#> 1      3     NA
#> 2      1      3
#> 3      1      2
#> 4      3      2
#> 5      5      3
```

test\_data is an example of the BPQ short form, which contains 46 items.

## BPQ\_all\_scoring

The scoreBPQ package contains several functions, but they are structured
in a way to interact with each other behind the scenes. Once you have
formatted your data, all you need to use is the function
**BPQ\_all\_scoring**. This function will do all the work in the
background and output a scored dataframe.

------------------------------------------------------------------------

In order to score test\_data, all we need to do is call the function
BPQ\_all\_scoring.

-   The first argument: df, is the input dataframe,
-   The second argument: form, is the form of the Body Perception
    Questionnaire,
    -   More information on how to use different forms can be found in
        the documentation ?BPQ\_all\_scoring
-   The third argument: version, is the population norms that the data
    will be compared to. Population norms were collected in 2018
    and 2020. It is advised to use version = 2020 for all new data, but
    certain users will want to compare to the older norms, perhaps if
    their study took place in 2018.

``` r
# Outputs original dataframe, with scored subscales appended to the end of the dataframe.
BPQ_all_scoring(df = test_data, form = "SF", version = 2020)
#>    ID bpq_1 bpq_2 bpq_3 bpq_4 bpq_5 bpq_6 bpq_7 bpq_8 bpq_9 bpq_10 bpq_11
#> 1 101     1     1     5     2     1     2     3     2     3      2      3
#> 2 102     3     4     1     3     1     3     1     3     1      2      2
#> 3 103     2     2     1     3     2     4     1     2     5      2      3
#> 4 104     3     1     1     3     2     1     4     1     2      1      2
#> 5 105     1     1     3     2     1     3     5     1     3      2      1
#>   bpq_12 bpq_13 bpq_14 bpq_15 bpq_16 bpq_17 bpq_18 bpq_19 bpq_20 bpq_21 bpq_22
#> 1      1      3      1      3      1      3      2      2      3      5      1
#> 2      4      3      3      2      2      3      3      3      4      2      3
#> 3      2      3      3      4      3      1      4      3      5      3      4
#> 4      1      5      2      2      3      3      4      2      2      3      1
#> 5      1      4      2      1      5      2      1     NA     NA      2      3
#>   bpq_23 bpq_24 bpq_25 bpq_26 bpq_27 bpq_28 bpq_29 bpq_30 bpq_31 bpq_32 bpq_33
#> 1      3      1      3      3      4      3      3      2      4      3      1
#> 2      2      3      1      3      1      1      3      4      1      5      2
#> 3      2      5      2      2      5      4      2      3      3      2      5
#> 4      3      2      1      2      1      5      3      4      3      2      1
#> 5      1      5      1     NA      1      2      2      2      5      1      2
#>   bpq_34 bpq_35 bpq_36 bpq_37 bpq_38 bpq_39 bpq_40 bpq_41 bpq_42 bpq_43 bpq_44
#> 1      3      3      3      3      4      4      1      2      1      2      4
#> 2      2      5      1      1      3      2      1      2      3      2      3
#> 3      2      4      3      2      1      2      2     NA      5      1      4
#> 4      1      1      1      3      3      1      1      3      1      5      1
#> 5      2      3      5      2      2      2      2      3      3      1      1
#>   bpq_45 bpq_46 Aware AwarePercentMissing SupraReact SupraPercentMissing
#> 1      3     NA    60             0.00000       43.0            0.000000
#> 2      1      3    65             0.00000       34.0            0.000000
#> 3      1      2    73             0.00000       42.5            6.666667
#> 4      3      2    57             0.00000       33.0            0.000000
#> 5      5      3    57            11.53846       36.0            0.000000
#>   SubReact SubPercentMissing CReact CReactPercentMissing AwarePercent
#> 1     14.0          16.66667   55.0                    0    0.5759289
#> 2     14.0           0.00000   46.0                    0    0.6523963
#> 3     15.5           0.00000   55.5                    0    0.7498654
#> 4     15.0           0.00000   45.0                    0    0.5296177
#> 5     16.0           0.00000   49.0                    0    0.5296177
#>   AwareTScore SupPercent SupTScore SubPercent SubTScore CRPercent CRTScore
#> 1    51.91489  0.9184168  63.94501  0.7889068  58.02634 0.9049542 63.10308
#> 2    53.91798  0.8497577  60.35395  0.7889068  58.02634 0.8484114 60.29644
#> 3    56.74066  0.9116855  63.51208  0.8578352  60.70644 0.9103393 63.42847
#> 4    50.74309  0.8392569  59.91408  0.8249865  59.34537 0.8381799 59.87005
#> 5    50.74309  0.8667205  61.11022  0.8578352  60.70644 0.8688745 61.21087
```

In the output, you will find all scored subscales, and the percent of
missing data for each subscale appended to the end of the input
dataframe.

## Common Errors

### Incorrect column names

A common error is a mistake in the column names of the bpq items. To
simulate this, we will create a new dataframe, test\_data\_incorrect, by
renaming all the prefixes from ‘bpq’ to ‘body\_perception’.

``` r
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
#> ✓ tibble  3.1.4     ✓ dplyr   1.0.7
#> ✓ tidyr   1.1.2     ✓ stringr 1.4.0
#> ✓ readr   1.4.0     ✓ forcats 0.5.0
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

``` r
test_data_incorrect <- test_data %>% 
  rename_all(~gsub("bpq", "body_perception", .))
```

``` r
BPQ_all_scoring(test_data_incorrect)
#> Error: Can't subset columns that don't exist.
#> x Columns `1`, `2`, `3`, `4`, `5`, etc. don't exist.
```

### Calling the wrong functions

As previously stated, there are several functions included in the
package. These can be used to score individual responses, but if given
an entire dataset of multiple responses, they will break.

``` r
BPQ_single_scoring(test_data)
#> Error in with(table, setNames(percents, raw)): argument "table" is missing, with no default
```

Remember to always use the function BPQ\_all\_scoring when scoring
multiple observations.

### Using non-numeric data

Another common error is to input the character string responses instead
of their numeric conversions. To simulate this, we will create a new
dataframe, test\_data\_character, by changing all the numbers back to
their character string analogues.

``` r
test_data_character <- test_data %>% 
  mutate_at(vars(starts_with('bpq')),
                 ~case_when(. == 1 ~ 'Never',
                            . == 2 ~ 'Occasionally',
                            . == 3 ~ 'Sometimes',
                            . == 4 ~ 'Usually',
                            . == 5 ~ 'Always'))
```

``` r
BPQ_all_scoring(test_data_character)
#>    ID        bpq_1        bpq_2     bpq_3        bpq_4        bpq_5
#> 1 101        Never        Never    Always Occasionally        Never
#> 2 102    Sometimes      Usually     Never    Sometimes        Never
#> 3 103 Occasionally Occasionally     Never    Sometimes Occasionally
#> 4 104    Sometimes        Never     Never    Sometimes Occasionally
#> 5 105        Never        Never Sometimes Occasionally        Never
#>          bpq_6     bpq_7        bpq_8        bpq_9       bpq_10       bpq_11
#> 1 Occasionally Sometimes Occasionally    Sometimes Occasionally    Sometimes
#> 2    Sometimes     Never    Sometimes        Never Occasionally Occasionally
#> 3      Usually     Never Occasionally       Always Occasionally    Sometimes
#> 4        Never   Usually        Never Occasionally        Never Occasionally
#> 5    Sometimes    Always        Never    Sometimes Occasionally        Never
#>         bpq_12    bpq_13       bpq_14       bpq_15       bpq_16       bpq_17
#> 1        Never Sometimes        Never    Sometimes        Never    Sometimes
#> 2      Usually Sometimes    Sometimes Occasionally Occasionally    Sometimes
#> 3 Occasionally Sometimes    Sometimes      Usually    Sometimes        Never
#> 4        Never    Always Occasionally Occasionally    Sometimes    Sometimes
#> 5        Never   Usually Occasionally        Never       Always Occasionally
#>         bpq_18       bpq_19       bpq_20       bpq_21    bpq_22       bpq_23
#> 1 Occasionally Occasionally    Sometimes       Always     Never    Sometimes
#> 2    Sometimes    Sometimes      Usually Occasionally Sometimes Occasionally
#> 3      Usually    Sometimes       Always    Sometimes   Usually Occasionally
#> 4      Usually Occasionally Occasionally    Sometimes     Never    Sometimes
#> 5        Never         <NA>         <NA> Occasionally Sometimes        Never
#>         bpq_24       bpq_25       bpq_26  bpq_27       bpq_28       bpq_29
#> 1        Never    Sometimes    Sometimes Usually    Sometimes    Sometimes
#> 2    Sometimes        Never    Sometimes   Never        Never    Sometimes
#> 3       Always Occasionally Occasionally  Always      Usually Occasionally
#> 4 Occasionally        Never Occasionally   Never       Always    Sometimes
#> 5       Always        Never         <NA>   Never Occasionally Occasionally
#>         bpq_30    bpq_31       bpq_32       bpq_33       bpq_34    bpq_35
#> 1 Occasionally   Usually    Sometimes        Never    Sometimes Sometimes
#> 2      Usually     Never       Always Occasionally Occasionally    Always
#> 3    Sometimes Sometimes Occasionally       Always Occasionally   Usually
#> 4      Usually Sometimes Occasionally        Never        Never     Never
#> 5 Occasionally    Always        Never Occasionally Occasionally Sometimes
#>      bpq_36       bpq_37       bpq_38       bpq_39       bpq_40       bpq_41
#> 1 Sometimes    Sometimes      Usually      Usually        Never Occasionally
#> 2     Never        Never    Sometimes Occasionally        Never Occasionally
#> 3 Sometimes Occasionally        Never Occasionally Occasionally         <NA>
#> 4     Never    Sometimes    Sometimes        Never        Never    Sometimes
#> 5    Always Occasionally Occasionally Occasionally Occasionally    Sometimes
#>      bpq_42       bpq_43    bpq_44    bpq_45       bpq_46 Aware
#> 1     Never Occasionally   Usually Sometimes         <NA>    NA
#> 2 Sometimes Occasionally Sometimes     Never    Sometimes    NA
#> 3    Always        Never   Usually     Never Occasionally    NA
#> 4     Never       Always     Never Sometimes Occasionally    NA
#> 5 Sometimes        Never     Never    Always    Sometimes    NA
#>   AwarePercentMissing SupraReact SupraPercentMissing SubReact SubPercentMissing
#> 1                 100         NA                 100       NA               100
#> 2                 100         NA                 100       NA               100
#> 3                 100         NA                 100       NA               100
#> 4                 100         NA                 100       NA               100
#> 5                 100         NA                 100       NA               100
#>   CReact CReactPercentMissing AwarePercent AwareTScore SupPercent SupTScore
#> 1     NA                   20           NA          NA         NA        NA
#> 2     NA                   20           NA          NA         NA        NA
#> 3     NA                   20           NA          NA         NA        NA
#> 4     NA                   20           NA          NA         NA        NA
#> 5     NA                   20           NA          NA         NA        NA
#>   SubPercent SubTScore CRPercent CRTScore
#> 1         NA        NA        NA       NA
#> 2         NA        NA        NA       NA
#> 3         NA        NA        NA       NA
#> 4         NA        NA        NA       NA
#> 5         NA        NA        NA       NA
```

Observe how the function still runs, and gives an output, but all the
subscale scores are NA, and the Percent Missing for each subscale is
100%.

### Own codes for missing values

Some users code missing values with some value other than NA, such as
-99 or 999. This will cause the function output to have incorrect
values, and all the percent missing columns to show 0.

First we will simulate this error by creating a new dataframe,
test\_data\_missing, by changing missing values to -99.

``` r
test_data_missing <- test_data %>% 
  mutate_all(~ifelse(is.na(.), -99, .))

test_data_missing
#>    ID bpq_1 bpq_2 bpq_3 bpq_4 bpq_5 bpq_6 bpq_7 bpq_8 bpq_9 bpq_10 bpq_11
#> 1 101     1     1     5     2     1     2     3     2     3      2      3
#> 2 102     3     4     1     3     1     3     1     3     1      2      2
#> 3 103     2     2     1     3     2     4     1     2     5      2      3
#> 4 104     3     1     1     3     2     1     4     1     2      1      2
#> 5 105     1     1     3     2     1     3     5     1     3      2      1
#>   bpq_12 bpq_13 bpq_14 bpq_15 bpq_16 bpq_17 bpq_18 bpq_19 bpq_20 bpq_21 bpq_22
#> 1      1      3      1      3      1      3      2      2      3      5      1
#> 2      4      3      3      2      2      3      3      3      4      2      3
#> 3      2      3      3      4      3      1      4      3      5      3      4
#> 4      1      5      2      2      3      3      4      2      2      3      1
#> 5      1      4      2      1      5      2      1    -99    -99      2      3
#>   bpq_23 bpq_24 bpq_25 bpq_26 bpq_27 bpq_28 bpq_29 bpq_30 bpq_31 bpq_32 bpq_33
#> 1      3      1      3      3      4      3      3      2      4      3      1
#> 2      2      3      1      3      1      1      3      4      1      5      2
#> 3      2      5      2      2      5      4      2      3      3      2      5
#> 4      3      2      1      2      1      5      3      4      3      2      1
#> 5      1      5      1    -99      1      2      2      2      5      1      2
#>   bpq_34 bpq_35 bpq_36 bpq_37 bpq_38 bpq_39 bpq_40 bpq_41 bpq_42 bpq_43 bpq_44
#> 1      3      3      3      3      4      4      1      2      1      2      4
#> 2      2      5      1      1      3      2      1      2      3      2      3
#> 3      2      4      3      2      1      2      2    -99      5      1      4
#> 4      1      1      1      3      3      1      1      3      1      5      1
#> 5      2      3      5      2      2      2      2      3      3      1      1
#>   bpq_45 bpq_46
#> 1      3    -99
#> 2      1      3
#> 3      1      2
#> 4      3      2
#> 5      5      3
```

``` r
BPQ_all_scoring(test_data_missing)
#>    ID bpq_1 bpq_2 bpq_3 bpq_4 bpq_5 bpq_6 bpq_7 bpq_8 bpq_9 bpq_10 bpq_11
#> 1 101     1     1     5     2     1     2     3     2     3      2      3
#> 2 102     3     4     1     3     1     3     1     3     1      2      2
#> 3 103     2     2     1     3     2     4     1     2     5      2      3
#> 4 104     3     1     1     3     2     1     4     1     2      1      2
#> 5 105     1     1     3     2     1     3     5     1     3      2      1
#>   bpq_12 bpq_13 bpq_14 bpq_15 bpq_16 bpq_17 bpq_18 bpq_19 bpq_20 bpq_21 bpq_22
#> 1      1      3      1      3      1      3      2      2      3      5      1
#> 2      4      3      3      2      2      3      3      3      4      2      3
#> 3      2      3      3      4      3      1      4      3      5      3      4
#> 4      1      5      2      2      3      3      4      2      2      3      1
#> 5      1      4      2      1      5      2      1    -99    -99      2      3
#>   bpq_23 bpq_24 bpq_25 bpq_26 bpq_27 bpq_28 bpq_29 bpq_30 bpq_31 bpq_32 bpq_33
#> 1      3      1      3      3      4      3      3      2      4      3      1
#> 2      2      3      1      3      1      1      3      4      1      5      2
#> 3      2      5      2      2      5      4      2      3      3      2      5
#> 4      3      2      1      2      1      5      3      4      3      2      1
#> 5      1      5      1    -99      1      2      2      2      5      1      2
#>   bpq_34 bpq_35 bpq_36 bpq_37 bpq_38 bpq_39 bpq_40 bpq_41 bpq_42 bpq_43 bpq_44
#> 1      3      3      3      3      4      4      1      2      1      2      4
#> 2      2      5      1      1      3      2      1      2      3      2      3
#> 3      2      4      3      2      1      2      2    -99      5      1      4
#> 4      1      1      1      3      3      1      1      3      1      5      1
#> 5      2      3      5      2      2      2      2      3      3      1      1
#>   bpq_45 bpq_46 Aware AwarePercentMissing SupraReact SupraPercentMissing
#> 1      3    -99    60                   0         43                   0
#> 2      1      3    65                   0         34                   0
#> 3      1      2    73                   0        -59                   0
#> 4      3      2    57                   0         33                   0
#> 5      5      3  -246                   0         36                   0
#>   SubReact SubPercentMissing CReact CReactPercentMissing AwarePercent
#> 1      -87                 0    -46                    0    0.5759289
#> 2       14                 0     46                    0    0.6523963
#> 3      -86                 0    -46                    0    0.7498654
#> 4       15                 0     45                    0    0.5296177
#> 5       16                 0     49                    0           NA
#>   AwareTScore SupPercent SupTScore SubPercent SubTScore CRPercent CRTScore
#> 1    51.91489  0.9184168  63.94501         NA        NA        NA       NA
#> 2    53.91798  0.8497577  60.35395  0.7889068  58.02634 0.8484114 60.29644
#> 3    56.74066         NA        NA         NA        NA        NA       NA
#> 4    50.74309  0.8392569  59.91408  0.8249865  59.34537 0.8381799 59.87005
#> 5          NA  0.8667205  61.11022  0.8578352  60.70644 0.8688745 61.21087
```

Observe the effect on the subscale scores, which should never be
negative. Be sure to change all missing values to NA prior to running
BPQ\_all\_scoring.
