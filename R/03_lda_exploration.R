############################################################
# 03_lda_exploration.R
# Final Project: Framing in U.S. State of the Union Speeches
# LDA topic modeling for exploratory analysis (based on PS1 Q4)
############################################################

library(tidyverse)
library(quanteda)
library(topicmodels)

# Set working directory to project root
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(dirname(script_path)))  # go up to project root
  }
}

cat("Working directory:", getwd(), "\n\n")

# Load preprocessed data
cat("Loading preprocessed data...\n")
dfm_sotu_trim <- readRDS("data/dfm_sotu_trim.rds")

cat("Documents:", ndoc(dfm_sotu_trim), "\n")
cat("Features:", nfeat(dfm_sotu_trim), "\n\n")

# Convert to topicmodels DTM
cat("Converting DFM to DTM (topicmodels format)...\n")
dtm_sotu <- convert(dfm_sotu_trim, to = "topicmodels")

# Run LDA with 10 topics (same as PS1)
cat("Running LDA with K=10 topics...\n")
set.seed(161)  # for reproducibility
K <- 10

lda_sotu <- LDA(
  dtm_sotu,
  k       = K,
  control = list(seed = 161)
)

cat("✓ LDA complete\n\n")

# Extract top terms per topic
cat("=== Top 10 Terms per Topic ===\n")
top_terms <- terms(lda_sotu, 10)

for (topic_id in seq_len(K)) {
  cat("\nTopic", topic_id, ":\n")
  cat(paste(top_terms[, topic_id], collapse = ", "), "\n")
}

# Save top terms as CSV
top_terms_df <- as.data.frame(top_terms)
colnames(top_terms_df) <- paste0("Topic_", seq_len(K))

write.csv(
  top_terms_df,
  "results/tables/lda_topics_top_terms.csv",
  row.names = FALSE
)

cat("\n✓ Saved: results/tables/lda_topics_top_terms.csv\n")

# Save LDA model
saveRDS(lda_sotu, "data/lda_model_sotu.rds")
cat("✓ Saved: data/lda_model_sotu.rds\n\n")

# Extract topic proportions per document
cat("Extracting topic proportions per document...\n")
topic_props <- posterior(lda_sotu)$topics
colnames(topic_props) <- paste0("topic_", seq_len(K))

# Add to docvars
docvars(dfm_sotu_trim) <- cbind(
  docvars(dfm_sotu_trim),
  as.data.frame(topic_props)
)

saveRDS(dfm_sotu_trim, "data/dfm_sotu_with_topics.rds")
cat("✓ Saved: data/dfm_sotu_with_topics.rds\n\n")

cat("=== Suggested Topic Interpretations ===\n")
cat("(Based on top terms - manual inspection recommended)\n\n")
cat("Note: These topics represent broad themes in SOTU speeches.\n")
cat("They may overlap with our 5 frame categories (economy, security, welfare, governance, values).\n")
cat("Use this as exploratory analysis to understand the data structure.\n\n")

cat("✓ LDA exploration complete!\n")

