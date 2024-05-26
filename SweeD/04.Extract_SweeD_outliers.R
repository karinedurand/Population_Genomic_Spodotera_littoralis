# Load necessary libraries
library(ggplot2)
library(gridExtra)
library(grid)
library(dplyr)

# Function to set viewport layout for ggplot
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)

# Set working directory
setwd("/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results")

# Define output file paths
output1 <- '/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/2024Sweed.SA.pdf'
output2 <- '/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/2024Sweed.EGT.pdf'
output3 <- '/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/2024Sweed.ML.pdf'


# Read the SweeD parsed files
v1 <- read.table('/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/SweeD_parsed.SA', header = TRUE)
v2 <- read.table('/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/SweeD_parsed.EGT', header = TRUE)
v3 <- read.table('/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/SweeD_parsed.ML', header = TRUE)

# Add an index column to each dataframe
v1$i <- c(1:nrow(v1))
v2$i <- c(1:nrow(v2))
v3$i <- c(1:nrow(v3))

# Determine the threshold for the top 0.05% highest values
thresholdv1 <- quantile(v1$likelihood, probs = 0.9995)
thresholdv2 <- quantile(v2$likelihood, probs = 0.9995)
thresholdv3 <- quantile(v3$likelihood, probs = 0.9995, na.rm = TRUE)

# Extract data that exceeds the threshold for each dataset
selected_data_SweeD_SA <- v1 %>%
  filter(likelihood > thresholdv1)
write.csv(selected_data_SweeD_SA, "/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/result_selected_data_SweeD_SA_0.9995.csv", row.names = FALSE)

selected_data_SweeD_EGT <- v2 %>%
  filter(likelihood > thresholdv2)
write.csv(selected_data_SweeD_EGT, "/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/result_selected_data_SweeD_EGT_0.9995.csv", row.names = FALSE)

selected_data_SweeD_ML <- v3 %>%
  filter(likelihood > thresholdv3)
write.csv(selected_data_SweeD_ML, "/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/result_selected_data_SweeD_ML_0.9995.csv", row.names = FALSE)


