############################################################
# 12_supervised_classifier_nb.R
# Final Project: Supervised classifier using hand-coded frames
# - Uses Naive Bayes (quanteda.textmodels::textmodel_nb)
# - Cross-validation + train/test evaluation
# - Outputs precision/recall/F1 and confusion matrix
############################################################

#install.packages("tidyverse")
#install.packages("quanteda")
#install.packages("quanteda.textmodels")

library(tidyverse)
library(quanteda)
library(quanteda.textmodels)

# Set working directory to project root
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(dirname(script_path)))  # go up to project root
  }
}

cat("Working directory:", getwd(), "\n\n")

############################################################
# 1. Load data
############################################################

cat("Loading DFM and hand-coded labels...\n")

dfm_sotu <- readRDS("data/dfm_sotu_trim.rds")
sotu_labeled <- readRDS("data/sotu_with_handcoded_labels.rds")

# Ensure docvars contain doc_id and frame_main
if (is.null(docvars(dfm_sotu)$doc_id)) {
  stop("dfm_sotu_trim.rds does not have docvars$doc_id. Please ensure 02_preprocess_dfm.R sets doc_id as a docvar.")
}

meta_dfm <- docvars(dfm_sotu) %>%
  as_tibble() %>%
  select(doc_id)

# Join hand-coded frame_main from sotu_labeled
labels_df <- sotu_labeled %>%
  select(doc_id, frame_main) %>%
  distinct(doc_id, .keep_all = TRUE)

meta_dfm <- meta_dfm %>%
  left_join(labels_df, by = "doc_id")

docvars(dfm_sotu)$frame_main_hand <- meta_dfm$frame_main

# Keep only documents with hand-coded labels
dfm_labeled <- dfm_sotu[!is.na(docvars(dfm_sotu)$frame_main_hand), ]
y <- factor(docvars(dfm_labeled)$frame_main_hand)

cat("Total labeled speeches available for supervised learning:", length(y), "\n")
cat("Frame distribution:\n")
print(table(y))
cat("\n")

if (length(y) < 30) {
  stop("Not enough labeled speeches for supervised learning (need at least ~30).")
}

############################################################
# 2. Helper functions for evaluation
############################################################

compute_metrics <- function(truth, pred) {
  truth <- factor(truth)
  pred  <- factor(pred, levels = levels(truth))
  
  classes <- levels(truth)
  out <- map_dfr(classes, function(cl) {
    tp <- sum(truth == cl & pred == cl)
    fp <- sum(truth != cl & pred == cl)
    fn <- sum(truth == cl & pred != cl)
    
    precision <- if ((tp + fp) == 0) NA_real_ else tp / (tp + fp)
    recall    <- if ((tp + fn) == 0) NA_real_ else tp / (tp + fn)
    f1        <- if (is.na(precision) || is.na(recall) || (precision + recall) == 0) NA_real_ else 2 * precision * recall / (precision + recall)
    
    tibble(
      class = cl,
      tp = tp,
      fp = fp,
      fn = fn,
      precision = precision,
      recall = recall,
      f1 = f1
    )
  })
  
  macro_precision <- mean(out$precision, na.rm = TRUE)
  macro_recall    <- mean(out$recall, na.rm = TRUE)
  macro_f1        <- mean(out$f1, na.rm = TRUE)
  accuracy        <- mean(truth == pred)
  
  list(
    per_class = out,
    summary = tibble(
      accuracy = accuracy,
      macro_precision = macro_precision,
      macro_recall = macro_recall,
      macro_f1 = macro_f1
    )
  )
}

############################################################
# 3. K-fold cross-validation (Naive Bayes)
############################################################

set.seed(161)
k <- 5
n <- length(y)
folds <- sample(rep(1:k, length.out = n))

cat("Running", k, "fold cross-validation with Naive Bayes...\n\n")

cv_results <- vector("list", k)

for (fold in 1:k) {
  cat(" Fold", fold, "of", k, "...\n")
  
  test_idx  <- which(folds == fold)
  train_idx <- which(folds != fold)
  
  dfm_train <- dfm_labeled[train_idx, ]
  dfm_test  <- dfm_labeled[test_idx, ]
  
  y_train <- y[train_idx]
  y_test  <- y[test_idx]
  
  model_nb <- textmodel_nb(dfm_train, y_train)
  pred_nb  <- predict(model_nb, newdata = dfm_test)
  
  metrics  <- compute_metrics(y_test, pred_nb)
  cv_results[[fold]] <- list(
    fold = fold,
    per_class = metrics$per_class,
    summary = metrics$summary
  )
}

# Aggregate CV summaries
cv_summaries <- map_dfr(cv_results, ~ .x$summary %>% mutate(fold = .x$fold))
cv_per_class <- map_dfr(cv_results, ~ .x$per_class %>% mutate(fold = .x$fold))

cat("\n=== Cross-Validation Summary (Naive Bayes) ===\n")
print(cv_summaries)

cv_summary_overall <- cv_summaries %>%
  summarise(
    accuracy_mean = mean(accuracy),
    accuracy_sd   = sd(accuracy),
    macro_precision_mean = mean(macro_precision),
    macro_recall_mean    = mean(macro_recall),
    macro_f1_mean        = mean(macro_f1)
  )

cat("\n=== Overall CV Performance (Naive Bayes) ===\n")
print(cv_summary_overall)

dir.create("results/tables", showWarnings = FALSE, recursive = TRUE)

write.csv(cv_summaries, "results/tables/supervised_nb_cv_summaries.csv", row.names = FALSE)
write.csv(cv_per_class, "results/tables/supervised_nb_cv_per_class.csv", row.names = FALSE)
write.csv(cv_summary_overall, "results/tables/supervised_nb_cv_overall.csv", row.names = FALSE)

cat("\n✓ Saved CV results to results/tables/ (supervised_nb_cv_*.csv)\n\n")

############################################################
# 4. Train final model on all labeled data and evaluate on hold-out set
############################################################

set.seed(1610)
test_prop <- 0.2
test_size <- max(1L, round(n * test_prop))
test_idx_final  <- sample(seq_len(n), size = test_size)
train_idx_final <- setdiff(seq_len(n), test_idx_final)

dfm_train_final <- dfm_labeled[train_idx_final, ]
dfm_test_final  <- dfm_labeled[test_idx_final, ]

y_train_final <- y[train_idx_final]
y_test_final  <- y[test_idx_final]

cat("Training final Naive Bayes model on", length(y_train_final), "speeches;\n",
    "Evaluating on hold-out set of", length(y_test_final), "speeches.\n\n")

model_nb_final <- textmodel_nb(dfm_train_final, y_train_final)
pred_final     <- predict(model_nb_final, newdata = dfm_test_final)

final_metrics <- compute_metrics(y_test_final, pred_final)

cat("=== Hold-out Set Performance (Naive Bayes) ===\n")
print(final_metrics$summary)
cat("\nPer-class metrics:\n")
print(final_metrics$per_class)

# Confusion matrix
conf_mat <- table(truth = y_test_final, pred = pred_final)
cat("\nConfusion matrix (truth x pred):\n")
print(conf_mat)

write.csv(as.data.frame(conf_mat), "results/tables/supervised_nb_confusion_matrix.csv", row.names = FALSE)
write.csv(final_metrics$per_class, "results/tables/supervised_nb_holdout_per_class.csv", row.names = FALSE)
write.csv(final_metrics$summary, "results/tables/supervised_nb_holdout_summary.csv", row.names = FALSE)

cat("\n✓ Saved supervised classifier evaluation tables to results/tables/.\n")
cat("You can now report precision/recall/F1 and accuracy in the memo.\n")


