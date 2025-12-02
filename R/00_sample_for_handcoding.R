############################################################
# 00_sample_for_handcoding.R
# Final Project: Framing in U.S. State of the Union Speeches
# Sample additional speeches for hand-coding (optional)
############################################################

library(tidyverse)

# Set working directory to project root
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(dirname(script_path)))  # go up to project root
  }
}

cat("Working directory:", getwd(), "\n\n")

# Load SOTU data
cat("Loading SOTU data...\n")
sotu <- read_csv("data/SOTU_WithText.csv", show_col_types = FALSE) %>%
  mutate(doc_id = row_number())

cat("Total speeches:", nrow(sotu), "\n\n")

# Check existing hand-coded labels
if (file.exists("data/ps2_q4_handcoding_sample_labeled.csv")) {
  cat("Loading existing hand-coded labels...\n")
  existing_labeled <- read_csv("data/ps2_q4_handcoding_sample_labeled.csv", show_col_types = FALSE)
  already_coded <- existing_labeled$doc_id
  cat("Already hand-coded:", length(already_coded), "speeches\n\n")
} else {
  already_coded <- integer(0)
  cat("No existing hand-coded labels found.\n\n")
}

# ============================================================
# Option 1: Sample additional speeches (excluding already coded)
# ============================================================
cat("=== Option 1: Random Sample ===\n")
cat("How many additional speeches do you want to code?\n")
cat("(Recommended: 30-80 more, for a total of 50-100)\n\n")

# You can adjust this number
n_additional <- 50  # <-- CHANGE THIS NUMBER

set.seed(161)  # for reproducibility

# Sample from speeches NOT already coded
sotu_uncoded <- sotu %>%
  filter(!doc_id %in% already_coded)

additional_sample <- sotu_uncoded %>%
  sample_n(min(n_additional, nrow(sotu_uncoded))) %>%
  arrange(year, president) %>%
  select(doc_id, president, year, party, sotu_type, text) %>%
  mutate(frame_main = NA_character_)  # <-- YOU fill this column

cat("Sampled", nrow(additional_sample), "additional speeches for coding\n")
cat("Frame categories: economy, security, welfare, governance, values\n\n")

# Save
write_csv(additional_sample, "data/additional_handcoding_sample.csv")
cat("✓ Saved: data/additional_handcoding_sample.csv\n\n")

# ============================================================
# Option 2: Stratified sample (by party and era)
# ============================================================
cat("=== Option 2: Stratified Sample (by Party and Era) ===\n")

# Define eras
sotu_uncoded <- sotu_uncoded %>%
  mutate(
    era = case_when(
      year < 1860 ~ "Early Republic",
      year >= 1860 & year < 1900 ~ "Civil War & Reconstruction",
      year >= 1900 & year < 1945 ~ "Early 20th Century",
      year >= 1945 & year < 1990 ~ "Cold War",
      year >= 1990 ~ "Post-Cold War"
    )
  )

# Sample stratified by party and era
stratified_sample <- sotu_uncoded %>%
  filter(party %in% c("Democratic", "Republican")) %>%
  group_by(party, era) %>%
  sample_n(min(5, n()), replace = FALSE) %>%  # 5 per party-era combination
  ungroup() %>%
  arrange(year, president) %>%
  select(doc_id, president, year, party, era, sotu_type, text) %>%
  mutate(frame_main = NA_character_)

cat("Stratified sample:", nrow(stratified_sample), "speeches\n")
cat("Breakdown:\n")
print(stratified_sample %>% count(party, era))
cat("\n")

write_csv(stratified_sample, "data/stratified_handcoding_sample.csv")
cat("✓ Saved: data/stratified_handcoding_sample.csv\n\n")

# ============================================================
# Option 3: Sample specific years/events
# ============================================================
cat("=== Option 3: Sample Specific Periods ===\n")
cat("You can manually select speeches from important periods:\n")
cat("  - Major wars (Civil War, WWI, WWII, Vietnam, Iraq)\n")
cat("  - Economic crises (Great Depression, 2008 Financial Crisis)\n")
cat("  - Key presidencies (FDR, Reagan, Obama, etc.)\n\n")

# Example: Sample from specific years
key_periods <- sotu_uncoded %>%
  filter(
    year %in% c(1933, 1941, 1964, 1981, 2001, 2009) |  # Key years
    president %in% c("Franklin D. Roosevelt", "Ronald Reagan", "Barack Obama")
  ) %>%
  sample_n(min(20, n())) %>%
  arrange(year, president) %>%
  select(doc_id, president, year, party, sotu_type, text) %>%
  mutate(frame_main = NA_character_)

write_csv(key_periods, "data/key_periods_handcoding_sample.csv")
cat("✓ Saved: data/key_periods_handcoding_sample.csv\n\n")

# ============================================================
# Summary
# ============================================================
cat("========================================\n")
cat("Summary of Sampling Options:\n")
cat("========================================\n")
cat("1. Random sample:", nrow(additional_sample), "speeches\n")
cat("   → data/additional_handcoding_sample.csv\n\n")
cat("2. Stratified sample:", nrow(stratified_sample), "speeches\n")
cat("   → data/stratified_handcoding_sample.csv\n\n")
cat("3. Key periods sample:", nrow(key_periods), "speeches\n")
cat("   → data/key_periods_handcoding_sample.csv\n\n")

cat("Instructions:\n")
cat("1. Choose one of the CSV files above\n")
cat("2. Open in Excel/Google Sheets\n")
cat("3. Read each speech and assign frame_main:\n")
cat("   - economy, security, welfare, governance, or values\n")
cat("4. Save as 'additional_handcoding_labeled.csv'\n")
cat("5. Use '04_handcoding_join.R' to merge with existing labels\n\n")

cat("Frame Definitions:\n")
cat("  - economy: growth, jobs, taxes, trade, inflation\n")
cat("  - security: defense, war, terrorism, foreign policy\n")
cat("  - welfare: healthcare, education, inequality, social programs\n")
cat("  - governance: budget, deficit, government performance, reform\n")
cat("  - values: democracy, rights, freedom, faith, family, moral rhetoric\n")

