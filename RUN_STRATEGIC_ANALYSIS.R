############################################################
# RUN_STRATEGIC_ANALYSIS.R
# Quick script to run only the strategic analysis
# (Assumes data has already been processed)
############################################################

# Set working directory
setwd("/Users/holim/Downloads/UCSD/FALL25/DSC161/nlp-clustering-us-speech")

# Run strategic analysis
source("R/09_strategic_analysis.R")

cat("\n✓ Strategic analysis complete!\n")
cat("New visualizations saved to: results/figures/\n")

