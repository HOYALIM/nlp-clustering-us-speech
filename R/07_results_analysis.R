############################################################
# 07_results_analysis.R
# Final Project: Framing in U.S. State of the Union Speeches
# Additional analysis for memo and presentation
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
# Analysis 1: Frame distribution by historical era
# ============================================================
cat("=== Analysis 1: Frame Distribution by Historical Era ===\n")

meta <- meta %>%
  mutate(
    era = case_when(
      year < 1860 ~ "Early Republic (1790-1859)",
      year >= 1860 & year < 1900 ~ "Civil War & Reconstruction (1860-1899)",
      year >= 1900 & year < 1945 ~ "Early 20th Century (1900-1944)",
      year >= 1945 & year < 1990 ~ "Cold War (1945-1989)",
      year >= 1990 ~ "Post-Cold War (1990-2015)"
    )
  )

frame_by_era <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  count(era, frame_main_auto) %>%
  group_by(era) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup() %>%
  arrange(era, desc(prop))

print(frame_by_era)
write.csv(frame_by_era, "results/tables/frame_distribution_by_era.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/frame_distribution_by_era.csv\n\n")

# ============================================================
# Analysis 2: Key presidents comparison
# ============================================================
cat("=== Analysis 2: Key Presidents Frame Usage ===\n")

key_presidents <- c("Franklin D. Roosevelt", "Ronald Reagan", "Barack Obama", 
                    "George W. Bush", "Bill Clinton", "Lyndon B. Johnson")

president_frames <- meta %>%
  filter(!is.na(frame_main_auto), president %in% key_presidents) %>%
  count(president, frame_main_auto) %>%
  group_by(president) %>%
  mutate(prop = n / sum(n), total = sum(n)) %>%
  ungroup() %>%
  arrange(president, desc(prop))

print(president_frames)
write.csv(president_frames, "results/tables/key_presidents_frames.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/key_presidents_frames.csv\n\n")

# ============================================================
# Analysis 3: Wartime vs Peacetime
# ============================================================
cat("=== Analysis 3: Wartime vs Peacetime Frame Usage ===\n")

# Define major war periods
meta <- meta %>%
  mutate(
    wartime = case_when(
      year %in% 1861:1865 ~ "Civil War",
      year %in% 1917:1918 ~ "WWI",
      year %in% 1941:1945 ~ "WWII",
      year %in% 1950:1953 ~ "Korean War",
      year %in% 1964:1973 ~ "Vietnam War",
      year %in% 2001:2011 ~ "War on Terror",
      TRUE ~ "Peacetime"
    )
  )

wartime_frames <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  count(wartime, frame_main_auto) %>%
  group_by(wartime) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

print(wartime_frames)
write.csv(wartime_frames, "results/tables/frame_distribution_wartime.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/frame_distribution_wartime.csv\n\n")

# ============================================================
# Analysis 4: Frame intensity (keyword counts)
# ============================================================
cat("=== Analysis 4: Average Frame Keyword Counts ===\n")

frame_intensity <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  summarise(
    economy_avg = mean(frame_economy_count, na.rm = TRUE),
    security_avg = mean(frame_security_count, na.rm = TRUE),
    welfare_avg = mean(frame_welfare_count, na.rm = TRUE),
    governance_avg = mean(frame_governance_count, na.rm = TRUE),
    values_avg = mean(frame_values_count, na.rm = TRUE)
  )

print(frame_intensity)
write.csv(frame_intensity, "results/tables/frame_intensity_averages.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/frame_intensity_averages.csv\n\n")

# ============================================================
# Analysis 5: Democratic vs Republican detailed comparison
# ============================================================
cat("=== Analysis 5: Democratic vs Republican Detailed Comparison ===\n")

party_comparison <- meta %>%
  filter(!is.na(frame_main_auto), party %in% c("Democratic", "Republican")) %>%
  group_by(party, frame_main_auto) %>%
  summarise(
    n = n(),
    avg_economy_count = mean(frame_economy_count, na.rm = TRUE),
    avg_security_count = mean(frame_security_count, na.rm = TRUE),
    avg_welfare_count = mean(frame_welfare_count, na.rm = TRUE),
    avg_governance_count = mean(frame_governance_count, na.rm = TRUE),
    avg_values_count = mean(frame_values_count, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  group_by(party) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

print(party_comparison)
write.csv(party_comparison, "results/tables/party_comparison_detailed.csv", row.names = FALSE)
cat("\n✓ Saved: results/tables/party_comparison_detailed.csv\n\n")

# ============================================================
# Summary Statistics for Memo
# ============================================================
cat("=== Summary Statistics for Memo ===\n")
cat("\nOverall Frame Distribution:\n")
overall <- meta %>%
  filter(!is.na(frame_main_auto)) %>%
  count(frame_main_auto) %>%
  mutate(prop = n / sum(n)) %>%
  arrange(desc(n))
print(overall)

cat("\nDemocratic vs Republican (Main Parties Only):\n")
dem_rep <- meta %>%
  filter(!is.na(frame_main_auto), party %in% c("Democratic", "Republican")) %>%
  count(party, frame_main_auto) %>%
  group_by(party) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup() %>%
  arrange(party, desc(prop))
print(dem_rep)

cat("\n✓ Additional analysis complete!\n")
cat("\nAll results saved to: results/tables/\n")

