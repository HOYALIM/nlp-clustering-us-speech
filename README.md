# Final Project: Framing in U.S. State of the Union Speeches

**DSC 161 - Text as Data**  
**Author**: Ho Lim

## Project Overview

This project analyzes how U.S. presidents frame key policy domains in State of the Union (SOTU) speeches from 1790 to 2015. The analysis focuses on five main frames:

- **Economy**: growth, jobs, taxes, trade, inflation
- **Security**: defense, war, terrorism, foreign policy
- **Welfare**: healthcare, education, inequality, social programs
- **Governance**: budget, deficit, government performance, institutional reform
- **Values**: democracy, rights, freedom, faith, family, moral rhetoric

### Research Questions

1. How do U.S. presidents frame the nation's economy, security, welfare, governance, and values in SOTU speeches?
2. How does framing differ by party (Democrat vs Republican)?
3. How has framing changed over time (from Washington to Obama)?

## Project Structure

```
nlp-clustering-us-speech/
├── data/
│   ├── SOTU_WithText.csv                    # Raw SOTU data (236 speeches)
│   └── ps2_q4_handcoding_sample_labeled.csv # Hand-coded labels (20 speeches)
├── R/
│   ├── 00_sample_for_handcoding.R          # (Optional) Sample speeches for additional hand-coding
│   ├── 00_run_all.R                         # Master script (runs all steps)
│   ├── 01_load_and_segment.R                # Load data, optional paragraph segmentation
│   ├── 02_preprocess_dfm.R                  # Text preprocessing with quanteda
│   ├── 03_lda_exploration.R                 # LDA topic modeling (exploratory)
│   ├── 04_handcoding_join.R                 # Join hand-coded frame labels
│   ├── 05_frame_model_or_rules.R            # Assign frames using dictionary
│   ├── 06_descriptive_plots.R               # Create visualizations
│   ├── 07_results_analysis.R                # Additional analysis (era, presidents, wartime)
│   └── 08_focused_analyses.R                # Focused analyses (modern era, key presidents)
├── results/
│   ├── figures/                              # All plots and visualizations (8 PNG files)
│   └── tables/                               # Summary statistics and tables (14 CSV files)
└── README.md                                 # This file
```

**Note**: Large RDS files (processed data) are excluded from git via `.gitignore`. Run the scripts to regenerate them.

## Methodology

### Data
- **Source**: SOTU_WithText.csv (236 speeches, 1790-2015)
- **Variables**: president, year, party, sotu_type, text

### Preprocessing
1. Tokenization (remove punctuation and numbers)
2. Lowercase conversion
3. Stopword removal (English)
4. Feature trimming (keep words in ≥5% of documents)

### Frame Assignment
- **Method**: Dictionary-based assignment
- **Dictionary**: Keywords for each of the 5 frame categories
- **Assignment rule**: Frame with highest keyword count (ties → NA)

### Validation
- Hand-coded sample: 20 speeches from PS2 (minimum)
- **Optional**: Additional hand-coding recommended (30-80 more speeches)
- Used to validate dictionary-based assignment
- Can train supervised classifier if ≥50 hand-coded speeches available

## Running the Analysis

### Option 0: Interactive Analysis (R Markdown)

For an interactive analysis with code and results together:

```r
# In RStudio, open and knit:
# analysis.Rmd
```

This will generate an HTML report with all analysis steps and visualizations.

### Step 0: (Optional) Additional Hand-Coding

If you want to add more hand-coded speeches for better validation:

```r
source("R/00_sample_for_handcoding.R")
```

This will create CSV files with sampled speeches. Open them in Excel/Google Sheets, assign `frame_main` to each speech, and save as `*_labeled.csv`. The `04_handcoding_join.R` script will automatically pick them up.

**Recommended**: Code 30-80 additional speeches (total 50-100) for better validation.

### Option 1: Run all steps at once
```r
source("R/00_run_all.R")
```

### Option 2: Run steps individually
```r
source("R/01_load_and_segment.R")
source("R/02_preprocess_dfm.R")
source("R/03_lda_exploration.R")
source("R/04_handcoding_join.R")      # Uses PS2 labels + any additional labels
source("R/05_frame_model_or_rules.R")
source("R/06_descriptive_plots.R")
source("R/07_results_analysis.R")     # (Optional) Additional analysis
source("R/08_focused_analyses.R")     # (Optional) Focused analyses
```

## Required Packages

```r
install.packages(c(
  "tidyverse",
  "quanteda",
  "topicmodels",
  "scales"  # For percentage formatting in plots
))
```

## Results

### Key Visualizations
1. **Frame Distribution Over Time**: Stacked area chart showing frame proportions across all years
2. **Economy Frame by Party**: Time series comparing Democratic vs Republican emphasis on economy
3. **Frame Distribution by Party**: Bar chart comparing frame usage across parties
4. **Security vs Economy Over Time**: Line chart tracking these two key frames (focus on smoothed trend line)
5. **Frame Heatmap by Decade**: Heatmap showing frame distribution across decades
6. **Modern Era Analysis** (1990-2015): Party differences in recent decades
7. **Key Presidents Comparison**: Individual framing strategies of modern presidents

### Output Files
- `results/figures/`: All visualization PNG files
- `results/tables/`: CSV files with summary statistics
- `data/`: Processed RDS files for intermediate steps

## Notes

- This project builds on work from **PS1** (LDA topic modeling) and **PS2** (frame definition and hand-coding)
- Current implementation uses **speech-level** analysis (can be extended to paragraph-level)
- Dictionary-based assignment is a simple rule-based method; supervised classification could improve accuracy

## Future Improvements

1. Expand hand-coded sample (currently 20 speeches)
2. Train supervised classifier (e.g., Naive Bayes, Logistic Regression)
3. Move to paragraph-level analysis for finer granularity
4. Implement multi-label frame assignment (allow multiple frames per speech)
5. Refine dictionary keywords based on validation results

