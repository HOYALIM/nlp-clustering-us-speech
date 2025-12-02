############################################################
# 01_load_and_segment.R
# Final Project: Framing in U.S. State of the Union Speeches
# Load SOTU data and optionally segment into paragraphs
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

# Load SOTU speeches
cat("Loading SOTU data...\n")
sotu <- read_csv("data/SOTU_WithText.csv", show_col_types = FALSE)

cat("SOTU speeches loaded:", nrow(sotu), "\n")
cat("Columns:", paste(names(sotu), collapse = ", "), "\n\n")

# Add doc_id
sotu <- sotu %>%
  mutate(doc_id = row_number())

# OPTION 1: Use speech-level data (current default)
# Save as is for speech-level analysis
saveRDS(sotu, "data/sotu_speeches.rds")
cat("✓ Saved speech-level data: data/sotu_speeches.rds\n")
cat("  Total speeches:", nrow(sotu), "\n\n")

# OPTION 2: Segment into paragraphs (optional, for finer-grained analysis)
# Uncomment below if you want paragraph-level analysis

# library(stringr)
# 
# cat("Segmenting speeches into paragraphs...\n")
# sotu_paragraphs <- sotu %>%
#   mutate(
#     paragraphs = str_split(text, "\\n\\s*\\n+")  # Split by double newlines
#   ) %>%
#   unnest(paragraphs) %>%
#   filter(str_trim(paragraphs) != "") %>%  # Remove empty paragraphs
#   group_by(doc_id) %>%
#   mutate(para_id = row_number()) %>%
#   ungroup() %>%
#   rename(text_para = paragraphs)
# 
# cat("  Total paragraphs:", nrow(sotu_paragraphs), "\n")
# cat("  Average paragraphs per speech:", round(nrow(sotu_paragraphs) / nrow(sotu), 2), "\n\n")
# 
# saveRDS(sotu_paragraphs, "data/sotu_paragraphs.rds")
# cat("✓ Saved paragraph-level data: data/sotu_paragraphs.rds\n")

cat("\n✓ Data loading complete!\n")

