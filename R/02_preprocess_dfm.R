############################################################
# 02_preprocess_dfm.R
# Final Project: Framing in U.S. State of the Union Speeches
# Preprocess text using quanteda (based on PS1 Q4)
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

# Load speech-level data (or paragraph-level if using that option)
cat("Loading SOTU data...\n")
sotu <- readRDS("data/sotu_speeches.rds")

cat("Documents:", nrow(sotu), "\n\n")

# Create corpus
cat("Creating corpus...\n")
corp_sotu <- corpus(sotu, text_field = "text")

# Attach metadata as docvars
docvars(corp_sotu)$doc_id    <- sotu$doc_id
docvars(corp_sotu)$president <- sotu$president
docvars(corp_sotu)$year      <- sotu$year
docvars(corp_sotu)$party     <- sotu$party
docvars(corp_sotu)$sotu_type <- sotu$sotu_type

cat("  Corpus created with", ndoc(corp_sotu), "documents\n\n")

# Tokenization and preprocessing (same as PS1)
cat("Preprocessing pipeline:\n")
cat("1. Tokenization (removing punctuation and numbers)...\n")
toks_sotu <- tokens(
  corp_sotu,
  remove_punct   = TRUE,
  remove_numbers = TRUE
)

cat("2. Converting to lowercase...\n")
toks_sotu <- tokens_tolower(toks_sotu)

cat("3. Removing English stopwords...\n")
toks_sotu <- tokens_select(
  toks_sotu,
  pattern   = stopwords("en"),
  selection = "remove"
)

cat("4. Removing very short tokens (min 2 characters)...\n")
toks_sotu <- tokens_keep(toks_sotu, min_nchar = 2)

# Create DFM
cat("5. Creating document-feature matrix...\n")
dfm_sotu <- dfm(toks_sotu)

cat("   - Documents:", ndoc(dfm_sotu), "\n")
cat("   - Features (before trimming):", nfeat(dfm_sotu), "\n")

# Trim to words appearing in at least 5% of documents (same as PS1)
cat("6. Trimming rare features (min 5% document frequency)...\n")
dfm_sotu_trim <- dfm_trim(
  dfm_sotu,
  min_docfreq  = 0.05,
  docfreq_type = "prop"
)

cat("   - Features (after trimming):", nfeat(dfm_sotu_trim), "\n\n")

# Save preprocessed objects
cat("Saving preprocessed data...\n")
saveRDS(dfm_sotu_trim, "data/dfm_sotu_trim.rds")
saveRDS(corp_sotu, "data/corp_sotu.rds")

cat("✓ Saved:\n")
cat("  - data/dfm_sotu_trim.rds\n")
cat("  - data/corp_sotu.rds\n\n")

cat("✓ Preprocessing complete!\n")
cat("  Final dataset: ", ndoc(dfm_sotu_trim), " documents × ", 
    nfeat(dfm_sotu_trim), " features\n", sep = "")

