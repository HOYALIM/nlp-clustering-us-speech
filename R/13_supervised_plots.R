############################################################
# 13_supervised_plots.R
# Final Project: Visualizations for supervised classifier results
# - Uses CSV outputs from 12_supervised_classifier_nb.R
# - Creates:
#   * Bar plot of per-class F1 scores (hold-out set)
#   * Heatmap of confusion matrix (truth x predicted)
############################################################

library(tidyverse)
library(ggplot2)

# Set working directory to project root
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(dirname(script_path)))  # go up to project root
  }
}

cat("Working directory:", getwd(), "\n\n")

fig_dir <- "results/figures"
tables_dir <- "results/tables"
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

############################################################
# 1. Per-class F1 scores (hold-out set)
############################################################

holdout_per_class_path <- file.path(tables_dir, "supervised_nb_holdout_per_class.csv")

if (!file.exists(holdout_per_class_path)) {
  stop("supervised_nb_holdout_per_class.csv not found. Please run R/12_supervised_classifier_nb.R first.")
}

cat("Loading per-class hold-out metrics from:\n  ", holdout_per_class_path, "\n\n")

per_class <- read_csv(holdout_per_class_path, show_col_types = FALSE) %>%
  # Ensure expected column names
  rename(
    class = class,
    precision = precision,
    recall = recall,
    f1 = f1
  )

cat("Per-class metrics:\n")
print(per_class)
cat("\n")

p_f1 <- per_class %>%
  mutate(class = factor(class, levels = class[order(f1, decreasing = TRUE)])) %>%
  ggplot(aes(x = class, y = f1, fill = class)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = round(f1, 2)), vjust = -0.3, size = 3) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  labs(
    title = "Naive Bayes Classifier: Per-Frame F1 Scores (Hold-out Set)",
    x = "Frame",
    y = "F1 Score"
  ) +
  theme_minimal()

f1_path <- file.path(fig_dir, "supervised_nb_per_class_f1.png")
ggsave(f1_path, p_f1, width = 8, height = 5, dpi = 300)
cat("✓ Saved:", f1_path, "\n\n")

############################################################
# 2. Confusion matrix heatmap (truth x predicted)
############################################################

conf_mat_path <- file.path(tables_dir, "supervised_nb_confusion_matrix.csv")

if (!file.exists(conf_mat_path)) {
  stop("supervised_nb_confusion_matrix.csv not found. Please run R/12_supervised_classifier_nb.R first.")
}

cat("Loading confusion matrix from:\n  ", conf_mat_path, "\n\n")

conf_mat_df <- read_csv(conf_mat_path, show_col_types = FALSE)

# Expect columns: truth, pred, Freq (if written as data.frame), but our 12_* saved as data.frame of table
if (!all(c("truth", "pred", "Freq") %in% names(conf_mat_df))) {
  # Try to guess structure if saved differently
  if (all(c("truth", "pred") %in% names(conf_mat_df)) && !"Freq" %in% names(conf_mat_df)) {
    conf_mat_df <- conf_mat_df %>%
      mutate(Freq = 1)
  } else {
    stop("Unexpected structure in supervised_nb_confusion_matrix.csv. Expected columns: truth, pred, Freq.")
  }
}

conf_mat_df <- conf_mat_df %>%
  mutate(
    truth = factor(truth),
    pred = factor(pred, levels = levels(truth))
  )

p_conf <- conf_mat_df %>%
  ggplot(aes(x = pred, y = truth, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), color = "black", size = 3) +
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(
    title = "Naive Bayes Classifier: Confusion Matrix (Hold-out Set)",
    x = "Predicted Frame",
    y = "True Frame",
    fill = "Count"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

conf_fig_path <- file.path(fig_dir, "supervised_nb_confusion_matrix.png")
ggsave(conf_fig_path, p_conf, width = 7, height = 6, dpi = 300)
cat("✓ Saved:", conf_fig_path, "\n\n")

cat("✓ Supervised classifier plots created.\n")
cat("You can now reference these figures in the memo (Step 2A: Measurement).\n")


