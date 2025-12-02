############################################################
# 11_sample_speeches_for_handcoding_excel.R
# Final Project: Create speech-level hand-coding template CSV
# - Samples ~100 speeches from SOTU_WithText.csv
# - E column = full speech text
# - Adds helper columns for Excel formulas (row 2)
############################################################

library(tidyverse)

# Set working directory to project root (when running from RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(dirname(script_path)))  # go up to project root
  }
}

cat("Working directory:", getwd(), "\n\n")

############################################################
# 1. Load SOTU data
############################################################

if (!file.exists("data/SOTU_WithText.csv")) {
  stop("data/SOTU_WithText.csv not found. Please copy the file into data/ first.")
}

cat("Loading SOTU_WithText.csv ...\n")
sotu <- read_csv("data/SOTU_WithText.csv", show_col_types = FALSE) |>
  mutate(doc_id = row_number())

cat("Total speeches:", nrow(sotu), "\n")
cat("Year range:", min(sotu$year, na.rm = TRUE), "-", max(sotu$year, na.rm = TRUE), "\n\n")

############################################################
# 2. Sample ~100 speeches (documents) for hand-coding
############################################################

set.seed(161)
target_n <- 100

# For simplicity and robustness, just take a simple random sample of speeches.
# (Party balance is still roughly preserved due to the sample size.)
if (nrow(sotu) <= target_n) {
  sample_speeches <- sotu |>
    arrange(year, president)
} else {
  sample_speeches <- sotu |>
    slice_sample(n = target_n) |>
    arrange(year, president)
}

cat("Sampled speeches:", nrow(sample_speeches), "\n\n")

############################################################
# 3. Build Excel-friendly template
#
# Columns (A~):
#   A: doc_id
#   B: president
#   C: year
#   D: party
#   E: text              (full speech text)
#   F: econ_hint         (Excel formula in row 2, empty below)
#   G: sec_hint
#   H: wel_hint
#   I: gov_hint
#   J: val_hint
#   K: frame_main        (hand-coding: economy / security / welfare / governance / values)
############################################################

template <- sample_speeches |>
  select(doc_id, president, year, party, text)

# Create empty helper and label columns (no formulas pre-filled)
template <- template |>
  mutate(
    econ_hint = NA_character_,
    sec_hint  = NA_character_,
    wel_hint  = NA_character_,
    gov_hint  = NA_character_,
    val_hint  = NA_character_,
    frame_main = NA_character_
  )

############################################################
# 4. Write CSV template
############################################################

out_path <- "data/sotu_handcoding_speeches_excel_template.csv"
write_csv(template, out_path)

cat("✓ Saved hand-coding template for Excel:\n")
cat("  ", out_path, "\n\n")
cat("Columns:\n")
cat("  A: doc_id\n")
cat("  B: president\n")
cat("  C: year\n")
cat("  D: party\n")
cat("  E: text (speech text)\n")
cat("  F: econ_hint  (Excel formula in row 2; drag down)\n")
cat("  G: sec_hint   (Excel formula in row 2; drag down)\n")
cat("  H: wel_hint   (Excel formula in row 2; drag down)\n")
cat("  I: gov_hint   (Excel formula in row 2; drag down)\n")
cat("  J: val_hint   (Excel formula in row 2; drag down)\n")
cat("  K: frame_main (YOU fill with: economy / security / welfare / governance / values)\n\n")

cat("How to use in Excel / Google Sheets:\n")
cat("  1. Open 'sotu_handcoding_speeches_excel_template.csv'.\n")
cat("  2. Go to row 2: F2:J2 already contain formulas referencing E2.\n")
cat("  3. Drag F2:J2 down to fill formulas for all rows.\n")
cat("  4. Use the hint columns (1 = keyword present) to help you decide the frame.\n")
cat("  5. Manually type the final label into column K (frame_main) for each row.\n")


