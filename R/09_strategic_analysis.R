############################################################
# 09_strategic_analysis.R
# Final Project: Strategic Analysis with Overview + Focused Era
# Overview plots (1790-2015) + Focused analysis (1945-2015) + Case studies
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
# PART 1: OVERVIEW PLOTS (1790-2015)
# ============================================================
cat("=== PART 1: Overview Plots (1790-2015) ===\n\n")

# Plot 1: Share of each frame by year (smoothed)
cat("Creating Overview Plot 1: Share of each frame by year (smoothed)...\n")

# Calculate proportion of each frame by year
frame_shares_by_year <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  count(year, frame_main_auto) %>%
  group_by(year) %>%
  mutate(total_year = sum(n)) %>%
  ungroup() %>%
  mutate(prop = n / total_year) %>%
  # Fill in missing years for each frame
  complete(year = seq(min(meta$year, na.rm = TRUE), 
                      max(meta$year, na.rm = TRUE)),
           frame_main_auto = c("economy", "security", "welfare", "governance", "values"),
           fill = list(prop = 0, n = 0, total_year = 1))

# Order frames for better visualization
frame_shares_by_year <- frame_shares_by_year %>%
  mutate(frame_main_auto = factor(frame_main_auto, 
                                   levels = c("governance", "security", "economy", "welfare", "values")))

p_overview1 <- ggplot(frame_shares_by_year, aes(x = year, y = prop, color = frame_main_auto)) +
  geom_smooth(se = TRUE, method = "loess", span = 0.15, size = 1.5, alpha = 0.2) +
  scale_color_manual(
    values = c(
      "economy" = "#2E86AB",      # Blue
      "security" = "#A23B72",     # Purple
      "welfare" = "#F18F01",      # Orange
      "governance" = "#C73E1D",   # Red
      "values" = "#6A994E"        # Green
    ),
    name = "Frame"
  ) +
  scale_y_continuous(labels = percent_format(), limits = c(0, NA)) +
  labs(
    title = "Frame Shares in SOTU Speeches Over Time (1790-2015)",
    subtitle = "Smoothed trend lines showing proportion of each frame across 200+ years\nSecurity spikes during major wars; welfare emerges in 20th century",
    x = "Year",
    y = "Proportion of Speeches",
    color = "Frame"
  ) +
  theme_minimal() +
  theme(
    legend.position = "right",
    plot.subtitle = element_text(size = 10, color = "gray50")
  ) +
  # Add vertical lines for major wars
  geom_vline(xintercept = c(1861, 1917, 1941, 1950, 1964, 2001), 
             linetype = "dashed", alpha = 0.3, color = "gray50") +
  annotate("text", x = 1861, y = 0.95, label = "Civil War", angle = 90, hjust = 1, size = 3, color = "gray50") +
  annotate("text", x = 1917, y = 0.95, label = "WWI", angle = 90, hjust = 1, size = 3, color = "gray50") +
  annotate("text", x = 1941, y = 0.95, label = "WWII", angle = 90, hjust = 1, size = 3, color = "gray50") +
  annotate("text", x = 2001, y = 0.95, label = "9/11", angle = 90, hjust = 1, size = 3, color = "gray50")

ggsave("results/figures/overview_frame_shares_smoothed.png", 
       plot = p_overview1, width = 14, height = 8, dpi = 300)
cat("✓ Saved: results/figures/overview_frame_shares_smoothed.png\n\n")

# Plot 2: Stacked area chart (alternative overview)
cat("Creating Overview Plot 2: Stacked area chart...\n")

p_overview2 <- ggplot(frame_shares_by_year, aes(x = year, y = prop, fill = frame_main_auto)) +
  geom_area(alpha = 0.8, position = "stack") +
  scale_fill_manual(
    values = c(
      "economy" = "#2E86AB",
      "security" = "#A23B72",
      "welfare" = "#F18F01",
      "governance" = "#C73E1D",
      "values" = "#6A994E"
    ),
    name = "Frame"
  ) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Frame Distribution Over Time (1790-2015)",
    subtitle = "Stacked area chart showing cumulative frame proportions",
    x = "Year",
    y = "Proportion of Speeches",
    fill = "Frame"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

ggsave("results/figures/overview_frame_shares_stacked.png", 
       plot = p_overview2, width = 14, height = 8, dpi = 300)
cat("✓ Saved: results/figures/overview_frame_shares_stacked.png\n\n")

# ============================================================
# PART 2: FOCUSED ERA ANALYSIS (1945-2015: Post-WWII)
# ============================================================
cat("=== PART 2: Focused Era Analysis (1945-2015: Post-WWII) ===\n\n")

focused_era <- meta %>%
  filter(!is.na(frame_main_auto), year >= 1945, year <= 2015) %>%
  filter(party %in% c("Democratic", "Republican"))

cat("Focused era speeches:", nrow(focused_era), "\n")
cat("Democratic:", sum(focused_era$party == "Democratic"), "\n")
cat("Republican:", sum(focused_era$party == "Republican"), "\n\n")

# Plot 3: Frame distribution by party in focused era
cat("Creating Focused Plot 1: Frame distribution by party (1945-2015)...\n")

focused_by_party <- focused_era %>%
  count(party, frame_main_auto) %>%
  group_by(party) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup() %>%
  mutate(frame_main_auto = factor(frame_main_auto, 
                                   levels = c("governance", "security", "economy", "welfare", "values")))

p_focused1 <- ggplot(focused_by_party, aes(x = frame_main_auto, y = prop, fill = party)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  scale_fill_manual(values = c("Democratic" = "blue", "Republican" = "red")) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Frame Distribution by Party: Post-WWII Era (1945-2015)",
    subtitle = "Comparing Democratic and Republican framing strategies in comparable era",
    x = "Frame",
    y = "Proportion of Speeches",
    fill = "Party"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom")

ggsave("results/figures/focused_era_by_party.png", 
       plot = p_focused1, width = 10, height = 6, dpi = 300)
cat("✓ Saved: results/figures/focused_era_by_party.png\n\n")

write.csv(focused_by_party, "results/tables/focused_era_by_party.csv", row.names = FALSE)
cat("✓ Saved: results/tables/focused_era_by_party.csv\n\n")

# Plot 4: Time series of key frames by party in focused era
cat("Creating Focused Plot 2: Economy and Security frames by party over time (1945-2015)...\n")

focused_timeseries <- focused_era %>%
  filter(frame_main_auto %in% c("economy", "security")) %>%
  count(year, party, frame_main_auto) %>%
  group_by(year, party) %>%
  mutate(total_year_party = sum(n)) %>%
  ungroup() %>%
  left_join(
    focused_era %>%
      count(year, party, name = "total_speeches"),
    by = c("year", "party")
  ) %>%
  mutate(prop = n / total_speeches) %>%
  replace_na(list(prop = 0))

p_focused2 <- ggplot(focused_timeseries, aes(x = year, y = prop, color = interaction(party, frame_main_auto), linetype = frame_main_auto)) +
  geom_smooth(se = TRUE, method = "loess", span = 0.3, size = 1.5, alpha = 0.2) +
  scale_color_manual(
    values = c(
      "Democratic.economy" = "#0066CC",      # Bright Blue
      "Democratic.security" = "#0099FF",      # Light Blue
      "Republican.economy" = "#CC0000",       # Bright Red
      "Republican.security" = "#FF3333"      # Light Red
    ),
    labels = c(
      "Democratic.economy" = "Democratic - Economy",
      "Democratic.security" = "Democratic - Security",
      "Republican.economy" = "Republican - Economy",
      "Republican.security" = "Republican - Security"
    ),
    name = "Party - Frame"
  ) +
  scale_linetype_manual(values = c("economy" = "solid", "security" = "dashed"), guide = "none") +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Economy and Security Frames by Party (1945-2015)",
    subtitle = "Smoothed trend lines showing party differences in key frames",
    x = "Year",
    y = "Proportion of Speeches",
    color = "Party - Frame"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

ggsave("results/figures/focused_era_timeseries.png", 
       plot = p_focused2, width = 12, height = 7, dpi = 300)
cat("✓ Saved: results/figures/focused_era_timeseries.png\n\n")

# ============================================================
# PART 3: CASE STUDY PRESIDENTS
# ============================================================
cat("=== PART 3: Case Study Presidents ===\n\n")

# Case Study 1: LBJ vs Reagan (Welfare/Values)
cat("Creating Case Study 1: LBJ vs Reagan (Welfare/Values)...\n")

case_study1 <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  filter(president %in% c("Lyndon B. Johnson", "Ronald Reagan"))

lbj_reagan_frames <- case_study1 %>%
  count(president, frame_main_auto) %>%
  group_by(president) %>%
  mutate(prop = n / sum(n), total = sum(n)) %>%
  ungroup() %>%
  mutate(frame_main_auto = factor(frame_main_auto, 
                                   levels = c("governance", "security", "economy", "welfare", "values")))

p_case1 <- ggplot(lbj_reagan_frames, aes(x = president, y = prop, fill = frame_main_auto)) +
  geom_bar(stat = "identity", position = "stack", alpha = 0.8) +
  scale_fill_manual(
    values = c(
      "economy" = "#2E86AB",
      "security" = "#A23B72",
      "welfare" = "#F18F01",
      "governance" = "#C73E1D",
      "values" = "#6A994E"
    ),
    name = "Frame"
  ) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Case Study: LBJ vs Reagan",
    subtitle = "Contrasting framing strategies on welfare and values",
    x = "President",
    y = "Proportion of Speeches",
    fill = "Frame"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

ggsave("results/figures/case_study_lbj_reagan.png", 
       plot = p_case1, width = 10, height = 6, dpi = 300)
cat("✓ Saved: results/figures/case_study_lbj_reagan.png\n\n")

write.csv(lbj_reagan_frames, "results/tables/case_study_lbj_reagan.csv", row.names = FALSE)
cat("✓ Saved: results/tables/case_study_lbj_reagan.csv\n\n")

# Case Study 2: G.W. Bush vs Obama (Security)
cat("Creating Case Study 2: G.W. Bush vs Obama (Security)...\n")

case_study2 <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  filter(president %in% c("George W. Bush", "Barack Obama"))

bush_obama_frames <- case_study2 %>%
  count(president, frame_main_auto) %>%
  group_by(president) %>%
  mutate(prop = n / sum(n), total = sum(n)) %>%
  ungroup() %>%
  mutate(frame_main_auto = factor(frame_main_auto, 
                                   levels = c("governance", "security", "economy", "welfare", "values")))

p_case2 <- ggplot(bush_obama_frames, aes(x = president, y = prop, fill = frame_main_auto)) +
  geom_bar(stat = "identity", position = "stack", alpha = 0.8) +
  scale_fill_manual(
    values = c(
      "economy" = "#2E86AB",
      "security" = "#A23B72",
      "welfare" = "#F18F01",
      "governance" = "#C73E1D",
      "values" = "#6A994E"
    ),
    name = "Frame"
  ) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Case Study: G.W. Bush vs Obama",
    subtitle = "Contrasting framing strategies on security and economy",
    x = "President",
    y = "Proportion of Speeches",
    fill = "Frame"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

ggsave("results/figures/case_study_bush_obama.png", 
       plot = p_case2, width = 10, height = 6, dpi = 300)
cat("✓ Saved: results/figures/case_study_bush_obama.png\n\n")

write.csv(bush_obama_frames, "results/tables/case_study_bush_obama.csv", row.names = FALSE)
cat("✓ Saved: results/tables/case_study_bush_obama.csv\n\n")

# Summary statistics for case studies
cat("=== Case Study Summary Statistics ===\n\n")

case_summary <- bind_rows(
  case_study1 %>%
    group_by(president) %>%
    summarise(
      n_speeches = n(),
      economy_pct = mean(frame_main_auto == "economy", na.rm = TRUE) * 100,
      security_pct = mean(frame_main_auto == "security", na.rm = TRUE) * 100,
      welfare_pct = mean(frame_main_auto == "welfare", na.rm = TRUE) * 100,
      governance_pct = mean(frame_main_auto == "governance", na.rm = TRUE) * 100,
      values_pct = mean(frame_main_auto == "values", na.rm = TRUE) * 100,
      .groups = "drop"
    ) %>%
    mutate(case = "LBJ vs Reagan"),
  case_study2 %>%
    group_by(president) %>%
    summarise(
      n_speeches = n(),
      economy_pct = mean(frame_main_auto == "economy", na.rm = TRUE) * 100,
      security_pct = mean(frame_main_auto == "security", na.rm = TRUE) * 100,
      welfare_pct = mean(frame_main_auto == "welfare", na.rm = TRUE) * 100,
      governance_pct = mean(frame_main_auto == "governance", na.rm = TRUE) * 100,
      values_pct = mean(frame_main_auto == "values", na.rm = TRUE) * 100,
      .groups = "drop"
    ) %>%
    mutate(case = "Bush vs Obama")
)

print(case_summary)
write.csv(case_summary, "results/tables/case_studies_summary.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/case_studies_summary.csv\n\n")

cat("✓ Strategic analysis complete!\n\n")
cat("Generated files:\n")
cat("  Overview:\n")
cat("    - overview_frame_shares_smoothed.png\n")
cat("    - overview_frame_shares_stacked.png\n")
cat("  Focused Era (1945-2015):\n")
cat("    - focused_era_by_party.png\n")
cat("    - focused_era_timeseries.png\n")
cat("    - focused_era_by_party.csv\n")
cat("  Case Studies:\n")
cat("    - case_study_lbj_reagan.png\n")
cat("    - case_study_bush_obama.png\n")
cat("    - case_study_lbj_reagan.csv\n")
cat("    - case_study_bush_obama.csv\n")
cat("    - case_studies_summary.csv\n")

