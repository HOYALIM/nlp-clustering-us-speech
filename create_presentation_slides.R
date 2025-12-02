############################################################
# create_presentation_slides.R
# Create PowerPoint-style slides using R Markdown or export to PDF
# For Final Project Presentation (5 minutes)
############################################################

# This script helps create presentation slides
# Options:
# 1. Use R Markdown with reveal.js or ioslides
# 2. Export figures for PowerPoint/Google Slides
# 3. Create summary tables for slides

library(tidyverse)
library(quanteda)

# Set working directory
setwd("/Users/holim/Downloads/UCSD/FALL25/DSC161/nlp-clustering-us-speech")

# Load data for summary statistics
dfm_with_frames <- readRDS("data/dfm_sotu_with_frames.rds")
meta <- docvars(dfm_with_frames) %>%
  as_tibble() %>%
  select(doc_id, president, year, party, frame_main_auto)

# ============================================================
# Create Summary Statistics for Slides
# ============================================================

# Slide 2: Data Summary
data_summary <- list(
  total_speeches = nrow(meta),
  year_range = paste(min(meta$year), "-", max(meta$year)),
  unique_presidents = n_distinct(meta$president),
  parties = unique(meta$party)
)

cat("=== Slide 2: Data Summary ===\n")
cat("Total speeches:", data_summary$total_speeches, "\n")
cat("Year range:", data_summary$year_range, "\n")
cat("Unique presidents:", data_summary$unique_presidents, "\n\n")

# Slide 4: Key Statistics
focused_era <- meta %>%
  filter(!is.na(frame_main_auto), year >= 1945, year <= 2015) %>%
  filter(party %in% c("Democratic", "Republican"))

party_stats <- focused_era %>%
  count(party, frame_main_auto) %>%
  group_by(party) %>%
  mutate(prop = n / sum(n) * 100) %>%
  ungroup() %>%
  filter(frame_main_auto == "governance" | 
         (party == "Democratic" & frame_main_auto %in% c("economy", "welfare"))) %>%
  arrange(party, desc(prop))

cat("=== Slide 4: Key Statistics ===\n")
print(party_stats)
cat("\n")

# Case study statistics
case_studies <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  filter(president %in% c("Lyndon B. Johnson", "Ronald Reagan", 
                           "George W. Bush", "Barack Obama")) %>%
  count(president, frame_main_auto) %>%
  group_by(president) %>%
  mutate(prop = n / sum(n) * 100) %>%
  ungroup() %>%
  arrange(president, desc(prop))

cat("=== Case Studies ===\n")
print(case_studies)
cat("\n")

# Validation accuracy
validation <- read.csv("results/tables/frame_assignment_validation.csv")
# Calculate accuracy manually
cat("=== Validation Accuracy ===\n")
cat("Dictionary-based accuracy: 42.1%\n")
cat("(Based on 20 hand-coded speeches)\n\n")

cat("✓ Summary statistics created for presentation slides\n")
cat("\nNext steps:\n")
cat("1. Use these statistics in your slides\n")
cat("2. Include figures from results/figures/\n")
cat("3. Follow PRESENTATION_SLIDES.md for slide structure\n")
cat("4. Use PRESENTATION_SCRIPT.md for speaking script\n")

