############################################################
# 06_descriptive_plots.R
# Final Project: Framing in U.S. State of the Union Speeches
# Create visualizations of frame trends by party and time
############################################################

library(tidyverse)
library(quanteda)
library(scales)

# Set working directory to project root
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  script_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(script_path)) {
    setwd(dirname(dirname(script_path)))  # go up to project root
  }
}

cat("Working directory:", getwd(), "\n\n")

# Load DFM with frame assignments
cat("Loading data with frame assignments...\n")
dfm_sotu_with_frames <- readRDS("data/dfm_sotu_with_frames.rds")

# Extract metadata and frame assignments
meta <- docvars(dfm_sotu_with_frames) %>%
  as_tibble() %>%
  select(doc_id, president, year, party, frame_main_auto, 
         starts_with("frame_") & ends_with("_count"))

cat("Documents:", nrow(meta), "\n\n")

# Create decade variable for aggregation
meta <- meta %>%
  mutate(decade = floor(year / 10) * 10)

# Filter to main parties for comparison
meta_main <- meta %>%
  filter(party %in% c("Democratic", "Republican"))

# ============================================================
# Plot 1: Frame distribution over time (all speeches)
# ============================================================
cat("Creating Plot 1: Frame distribution over time...\n")

frame_by_year <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  count(year, frame_main_auto) %>%
  group_by(year) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

p1 <- ggplot(frame_by_year, aes(x = year, y = prop, fill = frame_main_auto)) +
  geom_area(alpha = 0.7, position = "stack") +
  scale_fill_brewer(palette = "Set2", name = "Frame") +
  labs(
    title = "Frame Distribution in SOTU Speeches Over Time (1790-2015)",
    subtitle = "Proportion of speeches by dominant frame",
    x = "Year",
    y = "Proportion",
    caption = "Based on dictionary-based frame assignment"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

ggsave("results/figures/frame_distribution_over_time.png", 
       plot = p1, width = 12, height = 6, dpi = 300)
cat("✓ Saved: results/figures/frame_distribution_over_time.png\n\n")

# ============================================================
# Plot 2: Economy frame by party over time
# ============================================================
cat("Creating Plot 2: Economy frame by party over time...\n")

economy_by_party <- meta_main %>%
  filter(!is.na(frame_main_auto)) %>%
  filter(frame_main_auto == "economy") %>%
  count(year, party) %>%
  group_by(year, party) %>%
  summarise(n_econ = n(), .groups = "drop") %>%
  left_join(
    meta_main %>%
      filter(!is.na(frame_main_auto)) %>%
      count(year, party, name = "n_total"),
    by = c("year", "party")
  ) %>%
  mutate(prop_econ = n_econ / n_total) %>%
  replace_na(list(prop_econ = 0))

p2 <- ggplot(economy_by_party, aes(x = year, y = prop_econ, color = party)) +
  # Individual points (will be 0% or 100% for most years with 1 speech)
  geom_point(alpha = 0.3, size = 1, shape = 1) +
  # Smoothed trend line (focus on this for interpretation)
  geom_smooth(se = TRUE, method = "loess", span = 0.3, size = 1.5) +
  scale_color_manual(values = c("Democratic" = "#0066CC", "Republican" = "#CC0000")) +
  scale_y_continuous(labels = scales::percent_format(), limits = c(0, NA)) +
  labs(
    title = "Economy Frame in SOTU Speeches by Party",
    subtitle = "Proportion of speeches with economy as dominant frame\n(Note: Most years have 1 speech, so individual points show 0% or 100%. Focus on smoothed line.)",
    x = "Year",
    y = "Proportion",
    color = "Party"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.subtitle = element_text(size = 9, color = "gray50"))

ggsave("results/figures/economy_frame_by_party.png", 
       plot = p2, width = 10, height = 6, dpi = 300)
cat("✓ Saved: results/figures/economy_frame_by_party.png\n\n")

# ============================================================
# Plot 3: All frames by party (bar chart)
# ============================================================
cat("Creating Plot 3: Frame distribution by party...\n")

frame_by_party <- meta_main %>%
  filter(!is.na(frame_main_auto)) %>%
  count(party, frame_main_auto) %>%
  group_by(party) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

p3 <- ggplot(frame_by_party, aes(x = frame_main_auto, y = prop, fill = party)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("Democratic" = "blue", "Republican" = "red")) +
  labs(
    title = "Frame Distribution by Party",
    subtitle = "Proportion of speeches by frame category",
    x = "Frame",
    y = "Proportion",
    fill = "Party"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom")

ggsave("results/figures/frame_distribution_by_party.png", 
       plot = p3, width = 10, height = 6, dpi = 300)
cat("✓ Saved: results/figures/frame_distribution_by_party.png\n\n")

# ============================================================
# Plot 4: Security vs Economy frames over time
# ============================================================
cat("Creating Plot 4: Security vs Economy frames over time...\n")

# Calculate proportion of ALL speeches (not just security/economy subset)
# Note: Most years have only 1 speech, so individual years can show 0% or 100%
# This is why we use smoothing to show the overall trend

# First, get total speeches per year
total_by_year <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  count(year, name = "total_speeches")

# Calculate proportion for security and economy frames
security_economy <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  filter(frame_main_auto %in% c("security", "economy")) %>%
  count(year, frame_main_auto) %>%
  left_join(total_by_year, by = "year") %>%
  mutate(prop = n / total_speeches) %>%
  # Fill in missing years with 0
  complete(year = seq(min(meta$year, na.rm = TRUE), 
                      max(meta$year, na.rm = TRUE)),
           frame_main_auto = c("security", "economy"),
           fill = list(prop = 0, n = 0, total_speeches = 1))

# Note: Individual years with 1 speech will show 0% or 100%
# This is expected behavior. The smoothed line shows the overall trend.

p4 <- ggplot(security_economy, aes(x = year, y = prop, color = frame_main_auto)) +
  # Show individual data points (will be 0% or 100% for single-speech years)
  geom_point(alpha = 0.3, size = 1, shape = 1) +
  # Smoothed trend line (this is the main visualization)
  geom_smooth(se = TRUE, method = "loess", span = 0.25, size = 1.5, alpha = 0.3) +
  # Optional: thin line connecting points (can be removed if too cluttered)
  # geom_line(size = 0.5, alpha = 0.2) +
  scale_color_manual(
    values = c("security" = "red", "economy" = "blue"),
    labels = c("security" = "Security", "economy" = "Economy")
  ) +
  scale_y_continuous(labels = scales::percent_format(), limits = c(0, NA)) +
  labs(
    title = "Security vs Economy Frames Over Time",
    subtitle = "Proportion of all speeches with security or economy as dominant frame\n(Note: Most years have 1 speech, so individual points show 0% or 100%)",
    x = "Year",
    y = "Proportion of All Speeches",
    color = "Frame"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.subtitle = element_text(size = 9, color = "gray50"))

ggsave("results/figures/security_vs_economy_over_time.png", 
       plot = p4, width = 10, height = 6, dpi = 300)
cat("✓ Saved: results/figures/security_vs_economy_over_time.png\n\n")

# ============================================================
# Plot 5: Frame counts by decade (heatmap-style)
# ============================================================
cat("Creating Plot 5: Frame distribution by decade...\n")

frame_by_decade <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  count(decade, frame_main_auto) %>%
  group_by(decade) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

p5 <- ggplot(frame_by_decade, aes(x = factor(decade), y = frame_main_auto, fill = prop)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "steelblue", name = "Proportion") +
  labs(
    title = "Frame Distribution by Decade",
    subtitle = "Heatmap of frame proportions across decades",
    x = "Decade",
    y = "Frame"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("results/figures/frame_heatmap_by_decade.png", 
       plot = p5, width = 12, height = 6, dpi = 300)
cat("✓ Saved: results/figures/frame_heatmap_by_decade.png\n\n")

# ============================================================
# Summary statistics table
# ============================================================
cat("Creating summary statistics table...\n")

summary_stats <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  group_by(party, frame_main_auto) %>%
  summarise(
    n = n(),
    .groups = "drop"
  ) %>%
  group_by(party) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup() %>%
  arrange(party, desc(prop))

write.csv(summary_stats, "results/tables/frame_summary_by_party.csv", row.names = FALSE)
cat("✓ Saved: results/tables/frame_summary_by_party.csv\n\n")

cat("=== Summary Statistics ===\n")
print(summary_stats)
cat("\n")

cat("✓ All visualizations and tables created!\n")
cat("\nGenerated files:\n")
cat("  Figures:\n")
cat("    - frame_distribution_over_time.png\n")
cat("    - economy_frame_by_party.png\n")
cat("    - frame_distribution_by_party.png\n")
cat("    - security_vs_economy_over_time.png\n")
cat("    - frame_heatmap_by_decade.png\n")
cat("  Tables:\n")
cat("    - frame_summary_by_party.csv\n")

