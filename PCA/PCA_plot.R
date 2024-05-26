# Author: Karine
# Description: This script processes PCA results, generates plots of percentage variance explained and PCA plots.

# Load necessary libraries
library(tidyverse)
library(readr)
library(ggplot2)
library(gridExtra)

# Set the working directory
setwd("/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/PCA/")

# Read PCA data
pca <- read_table("slittonewref_2023.SNP.filtered.PCA.eigenvec")

# Read eigenvalues
eigenval <- scan("slittonewref_2023.SNP.filtered.PCA.eigenval")

# Create a species vector
spp <- rep(NA, length(pca$X1))

# Calculate percentage variance explained (PVE)
pve <- data.frame(PC = 1:5, pve = eigenval/sum(eigenval)*100)
pve

# Plot percentage variance explained
a <- ggplot(pve, aes(PC, pve)) + 
  geom_bar(stat = "identity") +
  ylab("Percentage variance explained") +
  theme_light()
a

# Plot PCA results
a <- ggplot(pca, aes(PC1, PC2, col = pop)) + 
  geom_point(size = 4)
a


# Define a custom color palette for populations
palette <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#999999")

# Create a customized PCA plot with the defined color palette
a <- ggplot(pca, aes(PC1, PC2, col = pop)) + 
  geom_point(size = 4) +
  scale_color_manual(values = palette) +
  theme(
    axis.line = element_line(color = "black", linewidth = 0.5),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 14),
    legend.position = "right",
    legend.title = element_text(size = 14, face = "bold"),
    legend.text = element_text(size = 14)
  ) +
  xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + 
  ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)")) +
  labs(color = "Population")

# Display the customized PCA plot
a
