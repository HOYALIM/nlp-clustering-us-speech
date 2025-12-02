############################################################
# 10_sample_paragraphs_for_handcoding.R
# Final Project: Create paragraph-level hand-coding templates
# - Samples ~120 paragraphs from SOTU speeches
# - Writes two CSV templates: one for Coder 1, one for Coder 2
############################################################

library(tidyverse)
library(stringr)

# Set working directory to project root (when running from RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(dirname(script_path)))  # go up to project root
  }
}

cat("Working directory:", getwd(), "\n\n")

############################################################
# 1. Load speech-level data
############################################################

if (file.exists("data/sotu_speeches.rds")) {
  cat("Loading speech-level data from data/sotu_speeches.rds ...\n")
  sotu <- readRDS("data/sotu_speeches.rds")
} else if (file.exists("data/SOTU_WithText.csv")) {
  cat("Loading speech-level data from data/SOTU_WithText.csv ...\n")
  sotu <- read_csv("data/SOTU_WithText.csv", show_col_types = FALSE) |>
    mutate(doc_id = row_number())
} else {
  stop("Could not find data/sotu_speeches.rds or data/SOTU_WithText.csv")
}

cat("Total speeches:", nrow(sotu), "\n")
cat("Year range:", min(sotu$year, na.rm = TRUE), "-", max(sotu$year, na.rm = TRUE), "\n\n")

############################################################
# 2. Split speeches into paragraphs
############################################################

cat("Splitting speeches into paragraphs...\n")

sotu_paragraphs <- sotu |>
  mutate(
    # Split on blank lines; adjust if your formatting is different
    paragraphs = str_split(text, "\\n\\s*\\n+")
  ) |>
  unnest(paragraphs) |>
  group_by(doc_id) |>
  mutate(para_id = row_number()) |>
  ungroup() |>
  rename(text_para = paragraphs) |>
  mutate(
    text_para = str_squish(text_para)
  ) |>
  filter(nchar(text_para) > 50)  # drop very short fragments

cat("Total paragraphs after cleaning:", nrow(sotu_paragraphs), "\n\n")

############################################################
# 3. Define strata (party + era) and sample paragraphs
############################################################

cat("Sampling paragraphs for hand-coding...\n")

sotu_paragraphs <- sotu_paragraphs |>
  mutate(
    era = case_when(
      year < 1860 ~ "Early Republic",
      year >= 1860 & year < 1900 ~ "Civil War & Gilded Age",
      year >= 1900 & year < 1945 ~ "Early 20th Century",
      year >= 1945 & year < 1990 ~ "Post-WWII / Cold War",
      year >= 1990 ~ "Post-Cold War",
      TRUE ~ "Other"
    ),
    party_group = case_when(
      party %in% c("Democratic", "Republican") ~ party,
      TRUE ~ "Other"
    )
  )

target_n <- 120  # target total paragraphs to sample

# Compute per-stratum target (roughly proportional, with a minimum)
strata_counts <- sotu_paragraphs |>
  count(party_group, era, name = "n_stratum") |>
  mutate(
    weight = n_stratum / sum(n_stratum),
    target = pmax(5, round(weight * target_n))  # at least 5 per stratum when possible
  )

set.seed(161)

sampled_paragraphs <- sotu_paragraphs |>
  inner_join(strata_counts, by = c("party_group", "era")) |>
  group_by(party_group, era) |>
  slice_sample(n = pmin(n(), first(target))) |>
  ungroup() |>
  arrange(year, president, para_id) |>
  select(
    doc_id,
    para_id,
    president,
    year,
    party,
    era,
    text_para
  )

cat("Sampled paragraphs:", nrow(sampled_paragraphs), "\n\n")

############################################################
# 4. Create templates for Coder 1 and Coder 2
############################################################

cat("Creating CSV templates for Coder 1 and Coder 2...\n")

template_coder1 <- sampled_paragraphs |>
  mutate(frame_main = NA_character_)  # Coder 1 will fill this

template_coder2 <- sampled_paragraphs |>
  mutate(frame_main = NA_character_)  # Coder 2 will fill this

write_csv(template_coder1, "data/frame_handcoding_paragraphs_coder1.csv")
write_csv(template_coder2, "data/frame_handcoding_paragraphs_coder2.csv")

cat("✓ Saved: data/frame_handcoding_paragraphs_coder1.csv\n")
cat("✓ Saved: data/frame_handcoding_paragraphs_coder2.csv\n\n")

cat("Instructions:\n")
cat("  - Send 'frame_handcoding_paragraphs_coder1.csv' to Coder 1 (you).\n")
cat("  - Send 'frame_handcoding_paragraphs_coder2.csv' to Coder 2 (your friend).\n")
cat("  - Each coder reads each paragraph and fills 'frame_main' with one of:\n")
cat("      economy, security, welfare, governance, values\n")
cat("  - Save the files and return them to the project folder.\n")
cat("  - A separate script will later merge Coder 1 & Coder 2 labels and compute reliability.\n")


