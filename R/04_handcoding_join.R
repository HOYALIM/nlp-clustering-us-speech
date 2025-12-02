############################################################
# 04_handcoding_join.R
# Final Project: Framing in U.S. State of the Union Speeches
# Join hand-coded frame labels from PS2 and additional coding
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
sotu <- readRDS("data/sotu_speeches.rds")

cat("Total speeches:", nrow(sotu), "\n\n")

# Load hand-coded labels from PS2
hand_labeled_list <- list()

if (file.exists("data/ps2_q4_handcoding_sample_labeled.csv")) {
  cat("Loading hand-coded labels from PS2...\n")
  hand_labeled_list[[1]] <- read_csv("data/ps2_q4_handcoding_sample_labeled.csv", show_col_types = FALSE)
  cat("  PS2 labels:", nrow(hand_labeled_list[[1]]), "speeches\n")
}

# Load additional hand-coded labels (if available)
additional_files <- c(
  "data/additional_handcoding_labeled.csv",
  "data/stratified_handcoding_labeled.csv",
  "data/key_periods_handcoding_labeled.csv"
)

for (file_path in additional_files) {
  if (file.exists(file_path)) {
    cat("Loading additional labels:", basename(file_path), "\n")
    additional <- read_csv(file_path, show_col_types = FALSE)
    # Make sure it has frame_main column and is not all NA
    if ("frame_main" %in% names(additional) && sum(!is.na(additional$frame_main)) > 0) {
      hand_labeled_list[[length(hand_labeled_list) + 1]] <- additional
      cat("  ", basename(file_path), ":", sum(!is.na(additional$frame_main)), "labeled speeches\n")
    }
  }
}

# Combine all hand-coded labels
if (length(hand_labeled_list) > 0) {
  hand_labeled <- bind_rows(hand_labeled_list) %>%
    filter(!is.na(frame_main)) %>%  # Only keep rows with labels
    distinct(doc_id, .keep_all = TRUE)  # Remove duplicates (keep first)
  
  cat("\nTotal hand-coded speeches:", nrow(hand_labeled), "\n")
  cat("Frame categories:", paste(unique(hand_labeled$frame_main), collapse = ", "), "\n\n")
} else {
  stop("No hand-coded labels found! Please run 00_sample_for_handcoding.R first or ensure PS2 labels exist.")
}

# Check frame distribution
cat("=== Frame Distribution in Hand-Coded Sample ===\n")
frame_dist <- hand_labeled %>%
  count(frame_main, sort = TRUE)
print(frame_dist)
cat("\n")

# Join hand-coded labels to full dataset
cat("Joining hand-coded labels to full dataset...\n")
sotu_labeled <- sotu %>%
  left_join(
    hand_labeled %>% select(doc_id, frame_main),
    by = "doc_id"
  )

# Check how many have labels
n_labeled <- sum(!is.na(sotu_labeled$frame_main))
cat("  Speeches with hand-coded labels:", n_labeled, "\n")
cat("  Speeches without labels:", nrow(sotu_labeled) - n_labeled, "\n\n")

# Save labeled dataset
saveRDS(sotu_labeled, "data/sotu_with_handcoded_labels.rds")
cat("✓ Saved: data/sotu_with_handcoded_labels.rds\n\n")

# Create summary table of hand-coded frames by party and era
cat("=== Hand-Coded Frames by Party ===\n")
frame_by_party <- sotu_labeled %>%
  filter(!is.na(frame_main)) %>%
  count(party, frame_main) %>%
  group_by(party) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

print(frame_by_party)
write.csv(frame_by_party, "results/tables/handcoded_frames_by_party.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/handcoded_frames_by_party.csv\n\n")

# Create summary by era (decade)
cat("=== Hand-Coded Frames by Decade ===\n")
sotu_labeled <- sotu_labeled %>%
  mutate(decade = floor(year / 10) * 10)

frame_by_decade <- sotu_labeled %>%
  filter(!is.na(frame_main)) %>%
  count(decade, frame_main) %>%
  group_by(decade) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

print(frame_by_decade)
write.csv(frame_by_decade, "results/tables/handcoded_frames_by_decade.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/handcoded_frames_by_decade.csv\n\n")

cat("✓ Hand-coding join complete!\n")
cat("\nNote: This hand-coded sample (", n_labeled, " speeches) can be used to:\n", sep = "")
cat("  - Validate automated frame assignment methods\n")
if (n_labeled >= 50) {
  cat("  - Train a supervised classifier (Naive Bayes, Logistic Regression)\n")
}
cat("  - Understand frame distribution patterns\n")
if (n_labeled < 50) {
  cat("\n⚠ Consider adding more hand-coded speeches (run 00_sample_for_handcoding.R)\n")
  cat("   for better validation and potential supervised learning.\n")
}
