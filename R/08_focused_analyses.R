############################################################
# 08_focused_analyses.R
# Final Project: Framing in U.S. State of the Union Speeches
# Focused analyses: Modern Era & Key Presidents Comparison
############################################################

library(tidyverse)
library(quanteda)
library(ggplot2)
library(scales)

# Set working directory to project root
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(dirname(script_path)))  # go up to project root
  }
}

cat("Working directory:", getwd(), "\n\n")

# Load data with frame assignments
cat("Loading data with frame assignments...\n")
dfm_with_frames <- readRDS("data/dfm_sotu_with_frames.rds")

# Extract metadata
meta <- docvars(dfm_with_frames) %>%
  as_tibble() %>%
  select(doc_id, president, year, party, frame_main_auto, 
         starts_with("frame_") & ends_with("_count"))

cat("Documents:", nrow(meta), "\n\n")

# ============================================================
# Analysis Option 1: Modern Era Focus (1990-2015)
# ============================================================
cat("=== Analysis Option 1: Modern Era (1990-2015) ===\n")

modern_era <- meta %>%
  filter(!is.na(frame_main_auto), year >= 1990, year <= 2015) %>%
  filter(party %in% c("Democratic", "Republican"))

cat("Modern era speeches:", nrow(modern_era), "\n")
cat("Democratic:", sum(modern_era$party == "Democratic"), "\n")
cat("Republican:", sum(modern_era$party == "Republican"), "\n\n")

# Frame distribution by party in modern era
modern_by_party <- modern_era %>%
  count(party, frame_main_auto) %>%
  group_by(party) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

print(modern_by_party)
write.csv(modern_by_party, "results/tables/modern_era_by_party.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/modern_era_by_party.csv\n\n")

# Plot: Modern era frame distribution by party
p_modern <- ggplot(modern_by_party, aes(x = frame_main_auto, y = prop, fill = party)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  scale_fill_manual(values = c("Democratic" = "blue", "Republican" = "red")) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Frame Distribution by Party: Modern Era (1990-2015)",
    subtitle = "Focusing on recent speeches to highlight contemporary party differences",
    x = "Frame",
    y = "Proportion",
    fill = "Party"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom")

ggsave("results/figures/modern_era_by_party.png", 
       plot = p_modern, width = 10, height = 6, dpi = 300)
cat("✓ Saved: results/figures/modern_era_by_party.png\n\n")

# Time series in modern era
modern_timeseries <- modern_era %>%
  count(year, party, frame_main_auto) %>%
  group_by(year, party) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

# Economy frame over time in modern era
modern_economy <- modern_era %>%
  filter(frame_main_auto == "economy") %>%
  count(year, party) %>%
  group_by(year, party) %>%
  summarise(n_econ = n(), .groups = "drop") %>%
  left_join(
    modern_era %>%
      count(year, party, name = "n_total"),
    by = c("year", "party")
  ) %>%
  mutate(prop_econ = n_econ / n_total) %>%
  replace_na(list(prop_econ = 0))

p_modern_economy <- ggplot(modern_economy, aes(x = year, y = prop_econ, color = party)) +
  # Individual points (will be 0% or 100% for most years with 1 speech)
  geom_point(alpha = 0.3, size = 1, shape = 1) +
  # Smoothed trend line (focus on this for interpretation)
  geom_smooth(se = TRUE, method = "loess", span = 0.5, size = 1.5, alpha = 0.3) +
  scale_color_manual(values = c("Democratic" = "blue", "Republican" = "red")) +
  scale_y_continuous(labels = percent_format(), limits = c(0, NA)) +
  labs(
    title = "Economy Frame in Modern Era (1990-2015)",
    subtitle = "Proportion of speeches with economy as dominant frame\n(Note: Most years have 1 speech, so individual points show 0% or 100%. Focus on smoothed line.)",
    x = "Year",
    y = "Proportion",
    color = "Party"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.subtitle = element_text(size = 9, color = "gray50"))

ggsave("results/figures/modern_era_economy_timeseries.png", 
       plot = p_modern_economy, width = 10, height = 6, dpi = 300)
cat("✓ Saved: results/figures/modern_era_economy_timeseries.png\n\n")

# ============================================================
# Analysis Option 2: Key Presidents Comparison (1980-2015)
# ============================================================
cat("=== Analysis Option 2: Key Presidents Comparison (1980-2015) ===\n")

# Focus on modern presidents with multiple speeches
key_presidents_modern <- meta %>%
  filter(!is.na(frame_main_auto), year >= 1980, year <= 2015) %>%
  filter(president %in% c("Ronald Reagan", "George H.W. Bush", "Bill Clinton", 
                           "George W. Bush", "Barack Obama"))

cat("Modern presidents speeches:", nrow(key_presidents_modern), "\n")
cat("Presidents:", paste(unique(key_presidents_modern$president), collapse = ", "), "\n\n")

# Frame distribution by president
president_frames <- key_presidents_modern %>%
  count(president, frame_main_auto) %>%
  group_by(president) %>%
  mutate(prop = n / sum(n), total = sum(n)) %>%
  ungroup() %>%
  arrange(president, desc(prop))

print(president_frames)
write.csv(president_frames, "results/tables/modern_presidents_frames.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/modern_presidents_frames.csv\n\n")

# Plot: Presidents comparison
p_presidents <- ggplot(president_frames, aes(x = president, y = prop, fill = frame_main_auto)) +
  geom_bar(stat = "identity", position = "stack", alpha = 0.8) +
  scale_fill_brewer(palette = "Set2", name = "Frame") +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Frame Distribution by President (1980-2015)",
    subtitle = "Comparing modern presidents' framing strategies",
    x = "President",
    y = "Proportion",
    fill = "Frame"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom")

ggsave("results/figures/modern_presidents_comparison.png", 
       plot = p_presidents, width = 12, height = 6, dpi = 300)
cat("✓ Saved: results/figures/modern_presidents_comparison.png\n\n")

# Detailed comparison table
president_detailed <- key_presidents_modern %>%
  group_by(president, party) %>%
  summarise(
    n_speeches = n(),
    economy_pct = mean(frame_main_auto == "economy", na.rm = TRUE) * 100,
    security_pct = mean(frame_main_auto == "security", na.rm = TRUE) * 100,
    governance_pct = mean(frame_main_auto == "governance", na.rm = TRUE) * 100,
    welfare_pct = mean(frame_main_auto == "welfare", na.rm = TRUE) * 100,
    .groups = "drop"
  ) %>%
  arrange(year = desc(n_speeches))

print(president_detailed)
write.csv(president_detailed, "results/tables/modern_presidents_detailed.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/modern_presidents_detailed.csv\n\n")

# ============================================================
# Summary Statistics
# ============================================================
cat("=== Summary: Modern Era vs Historical ===\n")

# Compare modern era with historical
historical <- meta %>%
  filter(!is.na(frame_main_auto), year < 1990) %>%
  filter(party %in% c("Democratic", "Republican"))

comparison <- bind_rows(
  modern_era %>%
    mutate(period = "Modern (1990-2015)") %>%
    count(period, party, frame_main_auto) %>%
    group_by(period, party) %>%
    mutate(prop = n / sum(n)) %>%
    ungroup(),
  historical %>%
    mutate(period = "Historical (pre-1990)") %>%
    count(period, party, frame_main_auto) %>%
    group_by(period, party) %>%
    mutate(prop = n / sum(n)) %>%
    ungroup()
)

print(comparison)
write.csv(comparison, "results/tables/modern_vs_historical_comparison.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/modern_vs_historical_comparison.csv\n\n")

cat("✓ Focused analyses complete!\n")
cat("\nGenerated:\n")
cat("  Option 1 (Modern Era):\n")
cat("    - modern_era_by_party.png\n")
cat("    - modern_era_economy_timeseries.png\n")
cat("    - modern_era_by_party.csv\n")
cat("  Option 2 (Key Presidents):\n")
cat("    - modern_presidents_comparison.png\n")
cat("    - modern_presidents_frames.csv\n")
cat("    - modern_presidents_detailed.csv\n")

