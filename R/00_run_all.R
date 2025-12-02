############################################################
# 00_run_all.R
# Final Project: Framing in U.S. State of the Union Speeches
# Master script to run all analysis steps in sequence
############################################################

# This script runs all analysis steps in order
# Make sure you're in the project root directory

cat("========================================\n")
cat("Final Project: Framing in SOTU Speeches\n")
cat("Running complete analysis pipeline\n")
cat("========================================\n\n")

# Step 1: Load and segment data
cat("\n>>> Step 1: Loading and segmenting data...\n")
source("R/01_load_and_segment.R")

# Step 2: Preprocess text
cat("\n>>> Step 2: Preprocessing text...\n")
source("R/02_preprocess_dfm.R")

# Step 3: LDA exploration (optional but recommended)
cat("\n>>> Step 3: LDA topic modeling (exploratory)...\n")
source("R/03_lda_exploration.R")

# Step 4: Join hand-coded labels
cat("\n>>> Step 4: Joining hand-coded labels...\n")
source("R/04_handcoding_join.R")

# Step 5: Assign frames to all speeches
cat("\n>>> Step 5: Assigning frames to all speeches...\n")
source("R/05_frame_model_or_rules.R")

# Step 6: Create visualizations
cat("\n>>> Step 6: Creating visualizations...\n")
source("R/06_descriptive_plots.R")

# Step 7: Additional results analysis
cat("\n>>> Step 7: Additional results analysis...\n")
source("R/07_results_analysis.R")

# Step 8: Focused analyses
cat("\n>>> Step 8: Focused analyses...\n")
source("R/08_focused_analyses.R")

# Step 9: Strategic analysis (overview + focused era + case studies)
cat("\n>>> Step 9: Strategic analysis (overview + focused era + case studies)...\n")
source("R/09_strategic_analysis.R")

cat("\n========================================\n")
cat("✓ All analysis steps complete!\n")
cat("========================================\n")
cat("\nCheck the following directories for results:\n")
cat("  - results/figures/  (visualizations)\n")
cat("  - results/tables/   (summary statistics)\n")
cat("  - data/             (processed data files)\n")

