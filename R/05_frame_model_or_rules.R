############################################################
# 05_frame_model_or_rules.R
# Final Project: Framing in U.S. State of the Union Speeches
# Assign frame_main to all speeches using dictionary-based rules
############################################################

library(tidyverse)
library(quanteda)

# Set working directory to project root
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(dirname(script_path)))  # go up to project root
  }
}

cat("Working directory:", getwd(), "\n\n")

# Load preprocessed DFM
cat("Loading preprocessed data...\n")
dfm_sotu_trim <- readRDS("data/dfm_sotu_trim.rds")

cat("Documents:", ndoc(dfm_sotu_trim), "\n")
cat("Features:", nfeat(dfm_sotu_trim), "\n\n")

# Define frame dictionary
# Based on PS2 frame definitions:
# - economy: growth, jobs, taxes, trade, inflation
# - security: defense, war, terrorism, foreign policy
# - welfare: healthcare, education, inequality, social programs
# - governance: budget, deficit, government performance, institutional reform
# - values: democracy, rights, freedom, faith, family, moral rhetoric

cat("Creating frame dictionary...\n")
dict_frames <- dictionary(list(
  economy = c(
    "job*", "wage*", "tax*", "growth", "trade", "inflation", 
    "unemployment", "economic", "economy", "business", "market*",
    "commerce", "industry", "manufactur*", "revenue", "income",
    "prosperity", "wealth", "financial", "bank*", "invest*"
  ),
  security = c(
    "war", "troop*", "enemy", "terror*", "defense", "security",
    "alliance", "nato", "military", "soldier*", "army", "navy",
    "peace", "conflict", "threat", "attack", "weapon*", "combat",
    "foreign policy", "diplomacy", "treaty", "border*"
  ),
  welfare = c(
    "health*", "medicare", "medicaid", "education", "school*",
    "poverty", "welfare", "social security", "benefit*", "assistance",
    "inequality", "disadvantaged", "vulnerable", "elderly", "children",
    "student*", "teacher*", "university", "college", "scholarship"
  ),
  governance = c(
    "budget", "deficit", "bureaucracy", "agency", "congress",
    "institution", "reform", "government", "administration", "federal",
    "legislation", "law", "regulation", "policy", "executive",
    "judicial", "constitution", "democracy", "election*", "vote*"
  ),
  values = c(
    "freedom", "liberty", "democracy", "right*", "faith", "family",
    "moral*", "justice", "equality", "dignity", "honor", "courage",
    "patriotism", "tradition", "heritage", "god", "religion", "belief",
    "principle", "virtue", "character", "integrity"
  )
))

cat("  Frame categories:", length(dict_frames), "\n")
cat("  Total keywords:", sum(sapply(dict_frames, length)), "\n\n")

# Apply dictionary lookup
cat("Applying dictionary to DFM...\n")
dfm_frames <- dfm_lookup(dfm_sotu_trim, dictionary = dict_frames)

# Get frame counts per document
cat("Calculating frame scores per document...\n")
frame_counts <- convert(dfm_frames, to = "data.frame")
row.names(frame_counts) <- NULL  # Remove document names as row names
frame_counts <- frame_counts[, -1]  # Remove first column (doc_id)

# Assign frame_main: frame with highest count (ties -> NA)
frame_main_auto <- apply(frame_counts, 1, function(x) {
  if (all(x == 0)) return(NA_character_)
  max_val <- max(x)
  if (sum(x == max_val) > 1) return(NA_character_)  # tie -> NA
  names(x)[which.max(x)]
})

# Add to docvars
docvars(dfm_sotu_trim)$frame_main_auto <- frame_main_auto

# Also add individual frame counts for analysis
for (frame_name in names(dict_frames)) {
  docvars(dfm_sotu_trim)[[paste0("frame_", frame_name, "_count")]] <- 
    as.numeric(frame_counts[[frame_name]])
}

cat("✓ Frame assignment complete\n\n")

# Summary statistics
cat("=== Frame Assignment Summary ===\n")
frame_summary <- table(frame_main_auto, useNA = "always")
print(frame_summary)
cat("\n")

# Check agreement with hand-coded labels (if available)
if (file.exists("data/sotu_with_handcoded_labels.rds")) {
  cat("=== Validation: Comparing with Hand-Coded Labels ===\n")
  sotu_labeled <- readRDS("data/sotu_with_handcoded_labels.rds")
  
  # Merge
  validation_df <- data.frame(
    doc_id = docvars(dfm_sotu_trim)$doc_id,
    frame_auto = frame_main_auto,
    frame_hand = NA_character_
  )
  
  validation_df <- validation_df %>%
    left_join(
      sotu_labeled %>% select(doc_id, frame_main),
      by = "doc_id"
    ) %>%
    mutate(frame_hand = frame_main) %>%
    select(-frame_main) %>%
    filter(!is.na(frame_hand))
  
  if (nrow(validation_df) > 0) {
    # Agreement table
    agreement_table <- table(
      Auto = validation_df$frame_auto,
      Hand = validation_df$frame_hand
    )
    print(agreement_table)
    
    # Calculate accuracy
    accuracy <- mean(validation_df$frame_auto == validation_df$frame_hand, na.rm = TRUE)
    cat("\nAccuracy (exact match):", round(accuracy * 100, 1), "%\n")
    cat("(Note: This is on a small sample of", nrow(validation_df), "hand-coded speeches)\n\n")
    
    write.csv(agreement_table, "results/tables/frame_assignment_validation.csv", row.names = TRUE)
    cat("✓ Saved: results/tables/frame_assignment_validation.csv\n\n")
  }
}

# Save DFM with frame assignments
saveRDS(dfm_sotu_trim, "data/dfm_sotu_with_frames.rds")
cat("✓ Saved: data/dfm_sotu_with_frames.rds\n\n")

cat("✓ Frame assignment complete!\n")
cat("\nNote: Dictionary-based assignment is a simple rule-based method.\n")
cat("For higher accuracy, consider:\n")
cat("  - Expanding hand-coded sample and training a supervised classifier\n")
cat("  - Refining dictionary keywords based on validation results\n")
cat("  - Using multi-label approach (allowing multiple frames per speech)\n")

